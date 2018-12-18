% Abhängigkeiten eines Matlab-Skriptes an einen Ort kopieren
% Dies kann z.B. zur Weitergabe von Skripten passieren, ohne das die
% komplette Toolbox-Umgebung mit weitergegeben wird.
% 
% Eingabe:
% script_filepath
%   Pfad zu einem Matlab-Skript (absoluter Pfad)
% dest_path
%   Absoluter Pfad zum Zielverzeichnis, an den alle Abhängigkeiten kopiert
%   werden sollen
% verbose
%   Schalter für Textausgabe bei erfolgtem Kopieren

% Moritz Schappler, moritz.schappler@imes.uni-hannover.de, 2018-12
% (C) Institut für Mechatronische Systeme, Universität Hannover

function copy_script_dependencies(script_filepath, dest_path, verbose)

if isempty(script_filepath)
  error('Leere Eingabe script_filepath ungültig');
end

if nargin < 3
  verbose = true;
end

% Ziel-Ordner erstellen
mkdirs(dest_path);

% Abhängigkeiten zusammenstellen und durchgehen
fList = matlab.codetools.requiredFilesAndProducts( script_filepath );
for i = 1:length(fList)
  [~, fname, ext] = fileparts(fList{i});
  % Kopiere Abhängigkeit zum Zielpfad
  destpath = fullfile(dest_path, [fname,ext]);
  copyfile(fList{i}, destpath);
  if verbose
    fprintf('%03d/%03d: Abhängigkeit %s kopiert\n', i, length(fList), fname);
  end
end