% Generate C-Code from Matlab-Functions
% 
% Input:
% KompDat [1xn cell with strings]
%   Cell Array with function names. The functions will be converted to C
%   Code.
% launchreport [default: true]
%   if true, the code conversion report will be opened
% output_directory [string]
%   The C Code will be created in this directory

% Moritz Schappler, moritz.schappler@imes.uni-hannover.de, 2014-07
% (c) Institut für Regelungstechnik, Leibniz Universität Hannover

function matlabfcn2dll(KompDat, launchreport, output_directory)

for i = 1:length(KompDat)
  % Filename of Matlab-Function
  mdat_name = KompDat{i};

  % Get Directory
  [mdat_pfad, ~, suffix_m] = fileparts(which(mdat_name));

  % Get cgargs line
  cga_line = coder_gen_cgargs(fullfile(mdat_pfad, [mdat_name, suffix_m]));

  % Call of codegen to generate a dll file
  cmdstring = ['codegen ', fullfile(mdat_pfad, mdat_name), ...
    ' -v -config:dll -args ', cga_line, ...
    ' -d ''', fullfile(output_directory), ''''];

  if nargin >=1 && launchreport
    cmdstring = [cmdstring, ' -launchreport'];%#ok<AGROW> % (erstellt einen Report auch bei Erfolg)
  end

  mkdirs(output_directory);
  eval(cmdstring)
end