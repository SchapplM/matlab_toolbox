% Make all figures visible that are currently invisible
% 
% See also figure_invisible.m

% Moritz Schappler, moritz.schappler@imes.uni-hannover.de, 2022-01
% (C) Institut für Mechatronische Systeme, Leibniz Universität Hannover

function make_figures_visible()

figlist = get(0, 'children');
for i = 1:length(figlist)
  f = figlist(i);
  if strcmp(f.Visible, 'off')
    f.Visible = 'on';
  end
end