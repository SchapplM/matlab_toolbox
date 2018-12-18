% Entferne Alle Unterordner eines Verzeichnisses aus dem Matlab-Suchpfad
% Diese Funktion hat den selben Effekt wie rmpath(genpath(ORDNER))
% Der Aufruf sollte aber effizienter sein, da nur der vorhandene
% Matlab-Suchpfad nach dem Verzeichnis abgesucht wird und nicht der
% komplette Verzeichnisbaum im Dateisystem durchsucht wird.
% 
% Beispiel: rmpath_genpath('/home/schappler')
% 
% Eingabe:
% pfad
%   Absolute Verzeichnisangabe zum Ordner, der rekursiv aus dem
%   Matlab-Suchpfad entfernt werden soll
% verbose
%   Schalter für Textausgabe bei erfolgreichem Entfernen eines Ordners vom
%   Pfad

% Moritz Schappler, moritz.schappler@imes.uni-hannover.de, 2018-12
% (C) Institut für Mechatronische Systeme, Universität Hannover

function rmpath_genpath(pathrmdir, verbose)

if nargin < 2
  verbose = true;
end

% Matlab-Pfad-Variable aufteilen
pp = split(path(),':');
% Alle einzelnen Einträge durchgehen
for p = pp'
  if ispc()
    % Unter Windows wird das Laufwerk hintenangestellt (mit ";C"),
    % in der Absoluten Pfadangabe wird das Laufwerk am Anfang geschrieben ("C:"}
    p_abs = sprintf('%s:%s', p{1}(end), p{1}(1:end-2)); % korrigiere Pfadvariable
  else
    % Normales Betriebssystem, kein Windows. Keine Korrektur notwendig.
    p_abs = p{1};
  end
  % Entferne Unterordner des Home-Ordners
  if contains(p_abs, pathrmdir)
    if verbose
      fprintf('Entferne Ordner aus Matlab-Pfad: %s\n', p_abs);
    end
    rmpath(p_abs);
  end
  % Jetzt kommt nur noch das Matlab-Stammverzeichnis (steht immer am Ende
  % des Pfades. Dort können keine Verzeichnisse entfernt werden.
  if contains(p_abs, matlabroot)
    break;
  end
end