% Automatisches Kompilieren von .m-Funktionen in .mex-Dateien
% 
% Durchsucht den Matlab-Pfad nach den angegebenen Funktionen und kompiliert
% sie mit dem Matlab-Coder als mex-Datei in den selben Ordner
% 
% Damit die Kompilierung möglich ist, müssen alle Eingabevariablen mit
% assert vordimensioniert werden. Die Funktion muss "%#codegen" enthalten
% 
% Eingaben:
% KompDat
%   - cell mit Namen von Funktionen
% launchreport [1x1 logical]
%   - Kompilierungsergebnis auch bei Erfolg anzeigen [Standard: false]
% notmp [1x1 logical]
%   - Lösche temporäre Dateien [Standard: true]
% force [1x1 logical]
%   - Neukompilieren erzwingen (auch ohne erkannte Änderungen) [Standard:
%   false]
% 
% Ausgabe:
% Fehlercode
%   0: Kein Fehler
%   1: Datei nicht gefunden
%   2: Fehler beim kompilieren

% Moritz Schappler, schappler@irt.uni-hannover.de, 2013-08
% (c) Institut für Regelungstechnik, Universität Hannover



function Fehlercode = matlabfcn2mex(KompDat, launchreport, notmp, force, skiponerror)

%% Argumente verwalten
if nargin < 2
  launchreport = false;
else
  assert(isa(launchreport,'logical') && all(size(launchreport) == [1 1]));    
end
if nargin < 3
  notmp = true;
else
  assert(isa(notmp,'logical') && all(size(notmp) == [1 1])); 
end
if nargin < 4
  force = false;
else
  assert(isa(force,'logical') && all(size(force) == [1 1])); 
end
if nargin < 5
  skiponerror = false;
else
  assert(isa(skiponerror,'logical') && all(size(force) == [1 1])); 
end
Fehlercode = 0;
%% Kompilierung
% Zu kompilierende Dateien in der richtigen Reihenfolge (!)
% eintragen. (Für Abhängigkeiten in den Funktionen)
fprintf('Kompiliere %d Matlab-Skripte als mex\n', length(KompDat))

% Der Reihe nach kompilieren
% Die Standard-Benennung ist: normale x.m-Datei -> x_mex.mexw64

for i = 1:length(KompDat)
    t1 = tic;
    
    neukompilieren = false; % Merker, ob neu kompiliert werden muss
    if force
        neukompilieren = true;
    end
    %% Dateiname und Pfad feststellen
    mdat_name = KompDat{i};
    fprintf('%02d (%s):\n', i, mdat_name);
    mexdat_name = [mdat_name, '_mex'];
    [mdat_pfad, ~, suffix_m] = fileparts(which(mdat_name));
    if strcmp(mdat_pfad, '')
        fprintf('\tm-Datei nicht gefunden.\n');
        if skiponerror
          Fehlercode = 1;
          return;
        else
          continue;
        end
    end
    
    %% Änderungsdatum feststellen
    mdat_DirInfo = dir(fullfile(mdat_pfad, [mdat_name, suffix_m]));
    mdat_date = mdat_DirInfo.datenum;
    
    [mexdat_pfad, ~, suffix_mex] = fileparts(which(mexdat_name)); 
    if strcmp(mexdat_pfad, '')
        % die mex-Datei existiert nicht
        mexdat_date = 0;
        fprintf('\tKompilieren notwendig. mex-Datei existiert nicht.\n');
        neukompilieren = true;
    else
        % Prüfe, ob die Pfade gleich sind
        if ~strcmp(mexdat_pfad, mdat_pfad)
            error('ME:Pfade', 'mex-Datei liegt nicht im selben Ordner wie m-Datei.\nmex: %s\nm: %s', ...
                mexdat_pfad, mdat_pfad)
        end
        % Änderungsdatum feststellen
        mexdat_DirInfo = dir(fullfile(mexdat_pfad, [mexdat_name, suffix_mex]));
        mexdat_date = mexdat_DirInfo.datenum;
    end
    
    %% Die mex-Datei testen
    if ~neukompilieren
      try
          eval(mexdat_name);
      catch err
          if strcmp(err.identifier,'MATLAB:invalidMEXFile')
              % Mex-Datei funktioniert nicht
              neukompilieren = true;
              fprintf('\t%s\n',err.message);
          elseif strcmp(err.identifier,'EMLRT:runTime:WrongNumberOfInputs')
            % Mex-Datei funktioniert
          elseif strcmp(err.identifier,'MATLAB:UndefinedFunction')
            % Mex-Datei existiert nicht
          else
            throw(err); % unbekannter Fehler in vorhandener Mex-Datei
          end
      end
    end

    %% Prüfen, ob die .mexwxx -Datei neuer ist als die .m-Datei
    if ~neukompilieren && mdat_date > mexdat_date
        fprintf('\tKompilieren notwendig. m-Datei ist neuer als mex-Datei.\n');
        neukompilieren = true;
    end
    
    %% Prüfe, ob Abhängigkeiten verändert wurden
    if ~neukompilieren
      % Erstelle Liste mit allen Funktionen, von denen die Funktion
      % abhängig ist
      try
        fList = matlab.codetools.requiredFilesAndProducts( fullfile(mdat_pfad, [mdat_name, suffix_m]) );
        abh_neuer = false; % Merker für geänderte Abhängigkeit
        for jj = 1:length(fList)
          depdat_DirInfo = dir(fList{jj});
          [~, depdat_name] = fileparts(fList{jj});
          depdat_date = depdat_DirInfo.datenum;
          if depdat_date > mexdat_date
            fprintf('\tAbhängigkeit %s ist neuer als mex-Datei.\n', depdat_name);
            abh_neuer = true;
            break;
          end
        end
        if abh_neuer % Abhängigkeit ist neuer. Neukompilieren erforderlich
          neukompilieren = true;
        end
      catch
        % Bei zu langen Funktionen kann die Suche nach Abhängigkeiten
        % versagen
        fprintf('\tFehler beim Prüfen der Abhängigkeiten.\n');
      end
    end
    %% Kompilieren
    if ~neukompilieren
      fprintf('\tKompilieren nicht erforderlich. Keine Änderungen erkannt.\n');
      continue
    end
    fprintf('\tKompiliere: %s\n', fullfile(mdat_pfad, [mdat_name, suffix_m]));
    % in den Pfad wechseln, damit das Ergebnis da hin geschrieben wird
    aktpfad = pwd;
    cd(mdat_pfad);
    % .mexw32/.mexw64 kompilieren
    %try
    cmdstring = sprintf('codegen %s -v -o ''%s''', ...
       mdat_name, fullfile(mdat_pfad, mexdat_name));
    if nargin >1 && launchreport
      cmdstring = [cmdstring, ' -launchreport'];%#ok<AGROW> % (erstellt einen Report auch bei Erfolg)
    end
    try  
      eval(cmdstring);
    catch err
      if strcmp(err.identifier,'emlc:compilationError')
        fprintf('\tFehler beim Kompilieren\n');
        Fehlercode = 2;
      end
    end
    fprintf('\tDauer: %1.1f s\n', toc(t1));
    % entferne den codegen-Ordner (mit C-Dateien und Müll)
    if notmp
      try
        ol = fullfile(mdat_pfad, 'codegen');
        rmdir(ol, 's');
        fprintf('\tOrdner %s gelöscht\n', ol);
      catch %#ok<CTCH>
        fprintf('\tOrdner %s konnte nicht gelöscht werden\n', ol);
      end
    end
    cd(aktpfad); % in vorheriges Verzeichnis zurückwechseln
    %catch %#ok<CTCH>
        %fprintf('Fehler bei der Erstellung. Dauer %1.1f s\n', toc(t1));
    %end
end



