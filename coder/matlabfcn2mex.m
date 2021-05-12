% Automatisches Kompilieren von .m-Funktionen in .mex-Dateien
% 
% Durchsucht den Matlab-Pfad nach den angegebenen Funktionen und kompiliert
% sie mit dem Matlab-Coder als mex-Datei in den selben Ordner
% 
% * Damit die automatische Kompilierung möglich ist, müssen alle Eingabevariablen mit
%   `assert` vordimensioniert werden hinsichtlich Typ, Komplexität und Dimension. 
% * Die zu kompilierende Funktion muss "%#codegen" enthalten
% * Beispielargumente für die Funktion können mit der Zeile %$cgargs {...}
%   vorgegeben werden, wobei die geschweifte(!) Klammer die Beispieleingaben
%   enthält. Damit kann die Typvorgabe (assert(isa(...)) entfallen.
%   Beispiele für die cgargs-Zeile (Inhalt der geschweiften Klammer):
%   {zeros(3,3), zeros(3,1)}                          % 3x3-Matrix und 3x1-Vektor
%   {coder.newtype('double',[inf,6])}                 % Nx6-Matrix (beliebig viele Zeilen
%   {struct('field 1', zeros(3,3), 'field2', uint8(0)}% Struktur mit geg. Feldern
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
% 
% Beispiel: matlabfcn2mex({'rotx', 'roty', 'rotz'});

% Quelle:
% https://de.mathworks.com/help/fixedpoint/ug/define-input-properties-programmatically-in-the-matlab-file.html
% https://de.mathworks.com/help/fixedpoint/ref/coder.newtype.html
% `doc codegen`

% Moritz Schappler, moritz.schappler@imes.uni-hannover.de, 2013-08
% (C) Institut für Mechatronische Systeme, Leibniz Universität Hannover

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
if launchreport
  notmp = false; % Wenn man den Report sehen will, darf nicht gelöscht werden
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
    [mdat_pfad, mdat_name_fs, suffix_m] = fileparts(which(mdat_name));
    if strcmp(mdat_pfad, '') || ~strcmp(mdat_name_fs, mdat_name) % Prüfe, ob Groß-/Kleinschreibung korrekt
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
          eval([mexdat_name,';']);
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
    % Befehl für Aufruf von codegen zusammenstellen und ausführen
    if ~neukompilieren
      fprintf('\tKompilieren nicht erforderlich. Keine Änderungen erkannt.\n');
      continue
    end
    fprintf('\tKompiliere: %s\n', fullfile(mdat_pfad, [mdat_name, suffix_m]));
    % in den Pfad wechseln, damit das Ergebnis da hin geschrieben wird
    aktpfad = pwd;
    cd(mdat_pfad);
    % .mexw32/.mexw64 kompilieren
    cmdstring = 'codegen';
    if nargin >1 && launchreport
      cmdstring = [cmdstring, ' -launchreport'];%#ok<AGROW> % (erstellt einen Report auch bei Erfolg)
    else
      % Zum Unterdrücken der Nachricht "Code generation successful".
      % Tritt nur bei Versionen R2021a oder neuer auf. Erzeuge
      % Matlab-Versionszahl (Typ "9.10" ist nicht brauchbar, da seit R2021a
      % zweistellige zweite Versionsnummer, schlecht für Vergleich).
      [tokens] = regexp(version('-release'), '(\d+)([ab])', 'tokens');
      vnum = str2double(tokens{1}{1}) + (tokens{1}{2}=='b')*0.5;
      if vnum >= 2021.0 % Nur bei R2020a oder neuer
        cmdstring = [cmdstring, ' -silent']; %#ok<AGROW>
      end
    end
    cmdstring = [cmdstring, sprintf(' %s -o ''%s''', ...
       mdat_name, fullfile(mdat_pfad, mexdat_name))]; %#ok<AGROW>

    % Suche Beispiel-Übergabeargumente; gekennzeichnet durch %$cgargs
    % Damit ist es nicht mehr notwendig, die Übergabeargumente mit
    % isa(x,'double') zu kennzeichnen, was symbolische Eingaben unmöglich
    % macht.
    fid = fopen(fullfile(mdat_pfad, [mdat_name, suffix_m]),'r');
    tline = fgetl(fid);
    cga_found = false;
    cga_line = '';
    while ischar(tline)
      if contains(tline, '%$cgargs')
        if ~cga_found % erstes Vorkommnis
          cga_line = tline(9:end);
          cga_found = true;
        else % mehrzeilig
          cga_line = [cga_line, tline(9:end)]; %#ok<AGROW>
        end
      elseif cga_found
        % Der (mehrzeilige) Kommentar ist vorbei
        break;
      end
      tline = fgetl(fid);
    end
    fclose(fid);
    if ~isempty(cga_line)
      cmdstring = [cmdstring, ' -args ', cga_line]; %#ok<AGROW>
    end

    % Befehl ausführen
    try  
      eval(cmdstring);
    catch err
      if strcmp(err.identifier,'emlc:compilationError')
        fprintf('\tFehler beim Kompilieren\n');
        Fehlercode = 2;
      else
        warning('Unerwarteter Fehler beim Kompilieren: %s\n%s', err.identifier, err.message);
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
end



