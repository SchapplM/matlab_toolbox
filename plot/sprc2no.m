% Convert Subplot Row-Column-Notation to Subplot Number
% 
% Input:
% rt    total number of rows
% ct    total number of columns
% r     row number
% c     column number
% 
% Output:
% no    number of the subplot (to enter in subplot(rt,ct,no))
% 
% Useage:
%   subplot(3,4,sprc2no(3,4,1,2)) activates the second column, first row in
%   a 3x4 subplot grid

% Moritz Schappler, schappler@irt.uni-hannover.de, 2014-03
% (c) Institut für Regelungstechnik, Universität Hannover

function no = sprc2no(rt, ct, r, c)

if c>ct
    error('Column index exceeds maximum: %d > %d', c, ct);
end
if r>rt
    error('Row index exceeds maximum: %d > %d', r, rt);
end
no = ct*(r-1)+c;

