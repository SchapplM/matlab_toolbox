% Pfad-Initialisierung für die Matlab-Toolbox

% Moritz Schappler, schappler@imes.uni-hannover.de, 2018-03
% (C) Institut für mechatronische Systeme, Universität Hannover

this_tb_path = fileparts( mfilename('fullpath') );
addpath(this_tb_path);

addpath(fullfile(this_tb_path, 'coder'));
addpath(fullfile(this_tb_path, 'data_handling'));
addpath(fullfile(this_tb_path, 'mathematics'));
addpath(fullfile(this_tb_path, 'miscellaneous'));
addpath(fullfile(this_tb_path, 'optimization'));
addpath(fullfile(this_tb_path, 'plot'));
addpath(fullfile(this_tb_path, 'signal_processing'));
addpath(fullfile(this_tb_path, 'simulink'));

