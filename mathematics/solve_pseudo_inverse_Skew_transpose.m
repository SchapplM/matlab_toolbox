% Solve the equation S(v)^T*x=b via the Moore-Penrose pseudoinverse 
% x = (S(v)^T)^#*b 
% 
% Input:
% v [3x1]
%   Vector to construct S with
%   S = [[0   -v3  v2];
%        [v3   0  -v1];
%        [-v2  v1  0 ]];
% b [3x1]
%   right hand side of equation
% Output:
% x [3x1]
%   Solution of the equation
function x=solve_pseudo_inverse_Skew_transpose(v,b)
  %#codegen
  assert(all(size(v)==[3 1]), ...
      'solve_pseudo_inverse_Skew_transpose: v = [3x1] double');
  assert(all(size(b)==[3 1]), ...
      'solve_pseudo_inverse_Skew_transpose: b = [3x1] double');
  % Moore-Penrose pseudoinverse of S(v)^T is 1/|v|^2*S(v) (can be shown by using
  % the Grassmann identity)
  x = 1/(v(1)^2+v(2)^2+v(3)^2)*cross(v,b);
end
