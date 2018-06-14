% Alle Matlab-Funktionen in einem Verzeichnis kompilieren (nicht rekursiv)
% Nehme nur die Funktionen, die die Markierung "%#codegen" enthalten
% 
% Eingabe:
% compile_path
%   Pfad, in dem alle .m-Dateien kompiliert werden sollen
% verbosity (optional)
%   0: Keine Log-Ausgaben in der Konsole
%   1: Mehr Ausgaben
%   2: Noch mehr Ausgaben

% Moritz Schappler, moritz.schappler@imes.uni-hannover.de, 2018-06
% (C) Institut für mechatronische Systeme, Universität Hannover

function mex_all_matlabfcn_in_dir(compile_path, verbosity)

if nargin == 1
  verbosity = 0;
end
%% Loop through files and compile all Matlab Functions
% suche m-Dateien
files = dir(fullfile(compile_path, '*.m'));
for i = 1:length(files)
  fprintf('%03d: %s\n', i, files(i).name);
  % Prüfe ob Datei "%#codegen" enthält
  fid = fopen(fullfile(compile_path, files(i).name),'r');
  tline = fgetl(fid);
  codegen_set = false;
  while ischar(tline)
    if contains(tline, '%#codegen')
      codegen_set = true;
      break;
    end
    tline = fgetl(fid);
  end
  fclose(fid);
  if ~codegen_set
    if verbosity > 1
      fprintf('No %%#codegen - tag in file. Skip.\n');
    end
    continue
  end
  % einzelne Datei kompilieren
  [~,filebasename,~]=fileparts(files(i).name);

  Fehler = matlabfcn2mex({filebasename}, false, false, false);

  if Fehler
    error('Fehler beim Kompilieren');
  end
end
if verbosity > 0
  fprintf('Alle m-Funktionen als mex kompiliert!\n');
end