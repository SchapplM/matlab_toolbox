% Bring Angle into (-pi, pi]
% 
% Input:
% theta [arbitrary dimension]
%   Angle [rad]
% 
% Output:
% theta_n [dimension of input]
%   Normalized angle [rad]
% 

% Moritz Schappler, schappler@irt.uni-hannover.de, 2014-09
% (C) Institut für Regelungstechnik, Leibniz Universität Hannover

function theta_n = normalize_angle(theta)
%% Init
%#codegen
%$cgargs {coder.newtype('double',[inf,inf])}
assert(isa(theta,'double') && isreal(theta), ...
  'normalize_angle: has to be of type double, non-complex');

%% Calculate
theta_n = theta;

for i = 1:length(theta(:))
    % Check if Angle is already in (-pi, pi]
    if theta(i) <= pi && theta(i) > -pi
        theta_n(i) = theta(i);
        continue;
    end

    % Add 2pi to bring the angle into (-pi, pi]
    N = theta(i)/(2*pi);
    theta_n(i) = theta(i) - round(N)*2*pi;
end