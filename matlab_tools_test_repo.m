% Gesamttest für das Matlab-Toolbox-Repo
% 
% Führt alle verfügbaren Modultests aus um die Funktionalität
% sicherzustellen

% Moritz Schappler, moritz.schappler@imes.uni-hannover.de, 2018-03
% (C) Institut für mechatronische Systeme, Universität Hannover

this_repo_path = fullfile(fileparts(which('matlab_tools_path_init.m')));
addpath(fullfile(this_repo_path, 'examples_tests'));

example_fft_filtering
example_figure_format
test_mathematics_functions

clc
close all
fprintf('Alle Testfunktionen dieses Repos ausgeführt\n');