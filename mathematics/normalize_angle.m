% Bring Angle into [-pi, pi)
% 
% Input:
% theta [arbitrary dimension]
%   Angle [rad]
% 
% Output:
% theta_n [dimension of input]
%   Normalized angle [rad]
% 
% See also: 
% wrapToPi from mathworks (not supported for code generation); uses [-pi, pi]
% normalizeAngle from geom2d; also uses [-pi,pi), but has two arguments

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

% Check if Angle is already in [-pi, pi)
I_new = (theta < -pi) | (theta >= pi);
% Add 2pi to bring the angle into [-pi, pi)
theta_n(I_new) = mod(theta(I_new)+pi, 2*pi)-pi;
