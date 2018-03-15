% Innere Tick labels entfernen

% input
% axhdl
%   Handle zu axis-Objekten
% flag [1x1]
%   1 remove x labels and ticks between two neighbour subplots
%   2 remove y labels and ticks between two neighbour subplots


% Moritz Schappler, schappler@irt.uni-hannover.de, 2016-03
% Alexander Tödtheide toedtheide@irt.uni-hannover.de, 2015-06
% (c) Institut für Regelungstechnik, Universität Hannover

function remove_inner_labels(axhdl,flag)

for i = 1:size(axhdl,1)
  for j = 1:size(axhdl,2)
    ca = axhdl(i,j);
    % x-Label entfernen
    if flag == 1 && i < size(axhdl,1)
      set( ca, 'xticklabel',{})
      set( get(ca ,'XLabel'), 'String', '');
    end
    % y-Label entfernen
    if flag == 2 && j > 1
      set( ca, 'yticklabel',{})
      set( get(ca ,'YLabel'), 'String', '');
    end
  end
end