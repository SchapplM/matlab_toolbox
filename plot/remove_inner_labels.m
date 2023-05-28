% Innere Tick labels entfernen

% Input:
% axhdl
%   Handle zu axis-Objekten
% flag [1x1]
%   1 remove x labels and ticks between two neighbour subplots
%   2 remove y labels and ticks between two neighbour subplots
%   3 remove x labels and keep ticks
%   4 remove y labels and keep ticks

% Moritz Schappler, schappler@irt.uni-hannover.de, 2016-03
% Alexander Tödtheide toedtheide@irt.uni-hannover.de, 2015-06
% (c) Institut für Regelungstechnik, Universität Hannover

function remove_inner_labels(axhdl,flag)

for i = 1:size(axhdl,1)
  for j = 1:size(axhdl,2)
    last_row_in_col_j = find(~isnan(axhdl(:,j)), 1, 'last');
    ca = axhdl(i,j);
    if isnan(ca), continue; end
    % x-Label entfernen
    if i < last_row_in_col_j
      if any(flag == [1,3])
        set( get(ca ,'XLabel'), 'String', '');
      end
      if flag == 1
        set( ca, 'xticklabel',{});
      end
    end
    % y-Label entfernen
    if j > 1
      if any(flag == [2, 4])
        set( get(ca ,'YLabel'), 'String', '');
      end
      if flag == 2
        set( ca, 'yticklabel',{});
      end
    end
  end
end