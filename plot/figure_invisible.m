% Create a new Matlab figure in invisible mode to avoid focus stealing
% https://de.mathworks.com/matlabcentral/answers/98788-is-it-possible-to-create-multiple-figures-in-background-such-that-it-does-not-steal-focus-in-matlab
% 
% See also: make_figures_visible.m

% Moritz Schappler, moritz.schappler@imes.uni-hannover.de, 2022-01
% (C) Institut für Mechatronische Systeme, Leibniz Universität Hannover

function fhdl = figure_invisible()

fhdl = figure('Visible','off');
% When opening the fig file again, the figure becomes visible.
set(fhdl, 'CreateFcn', 'set(gcf,''Visible'',''on'')');