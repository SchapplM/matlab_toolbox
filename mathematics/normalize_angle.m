% Bring Angle into -pi to pi
% 
% Input:
% theta [1x1]
%   Angle [rad]
% 
% Output:
% theta_n [1x1]
%   Angle [rad]
% 

% Moritz Schappler, schappler@irt.uni-hannover.de, 2014-09
% (c) Institut für Regelungstechnik, Universität Hannover

function theta_n = normalize_angle(theta)
%% Init
%#codegen
assert(isa(theta,'double') && isreal(theta), ...
      'normalize_angle: theta = [1x1] double');

%% Calculate
theta_n = theta;

for i = 1:length(theta(:))
    % Check if Angle is already in [-pi, pi]
    if abs(theta(i)) < pi
        theta_n(i) = theta(i);
        continue;
    end

    % Add 2pi to bring the angle into [-pi, pi]
    N = theta(i)/(2*pi);
    theta_n(i) = theta(i) - round(N)*2*pi;
end