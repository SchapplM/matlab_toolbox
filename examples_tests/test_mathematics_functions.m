% Test all mathematics functions from this toolbox
% 
% Run this test: result = runtests('test_mathematics_functions');

% Moritz Schappler, moritz.schappler@imes.uni-hannover.de, 2020-05
% (C) Institut für Mechatronische Systeme, Leibniz Universität Hannover

clear
clc

test_angles = [-2*pi, -pi, -pi/2, -pi/4, 0, pi/4, pi/2, pi, 2*pi];

%% Test normalize_angle for different cases

expected_outcomes = [0, pi, -pi/2, -pi/4, 0, pi/4, pi/2, pi, 0];
angles_norm = normalize_angle(test_angles);
assert(all(expected_outcomes==angles_norm), ...
  'normalized angles do not match expected outcome');

%% Test normalize_angle for different dimensions

dim1 = rand(1,1);
dim2 = rand(10,1);
dim3 = rand(1,20);
dim4 = rand(50,23);
assert(all(size(normalize_angle(dim1))==size(dim1)));
assert(all(size(normalize_angle(dim2))==size(dim2)));
assert(all(size(normalize_angle(dim3))==size(dim3)));
assert(all(size(normalize_angle(dim4))==size(dim4)));

%% Test normalize_angle mex against matlab function

matlabfcn2mex({'normalize_angle'});
angles_input = 2*pi*2*(0.5-rand(20,50)); % random numbers in [-2pi, 2pi]
angles_norm1 = normalize_angle(angles_input);
angles_norm2 = normalize_angle_mex(angles_input);
assert(all(angles_norm1(:)==angles_norm2(:)), 'output of mex does not match non-mex');
