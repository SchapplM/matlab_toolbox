% load fig files and arrange them in subplots
% 
% Input:
% figHandle:
%   figure Handle
% CellFigfiles:
% 	cell array with full file paths to .fig files to assemble in subplots
%   number of rows and columns determines subplot arrangement
%
% Output:
% axhdl:
%   Handle to the created subplots in the figure handle figHandle
% other_hdl:
%   Handle to other objects that were copied into the figure. These objects
%   have to be repositioned afterwards using the handles

% Alexander Tödtheide, schappler@irt.uni-hannover.de, 2015-06
% Moritz Schappler, schappler@irt.uni-hannover.de, 2016-02
% (c) Institut für Regelungstechnik, Universität Hannover

function [axhdl, other_hdl] = set_fig2subfig(figHandle,CellFigfiles)
other_hdl = [];
n_rows = size(CellFigfiles,1);
n_cols = size(CellFigfiles,2);

fighhdl_in = NaN(size(CellFigfiles));
axhdl = NaN(size(CellFigfiles));
ax = NaN(size(CellFigfiles));

% Öffne alle figures und merke das Handle zum aktuellen Axes-Objekt (es
% wird nur eins erkannt)
fighdl_to_close = NaN(n_rows, n_cols);
for i = 1:n_rows
  for j = 1:n_cols
    pause(0.5)
    h1=openfig(CellFigfiles{i,j},'reuse'); % open figure
    fighhdl_in(i,j) = h1;
    fch = get(h1, 'children');
    % Bestimme alle Axis-Handles, um das in den Subplot zu kopierende zu bestimmen
    I_ax = strcmp(get(fch, 'type'), 'axes');
    I_axlabel = false(length(fch),1);
    if sum(I_ax) > 1
      % Bestimme bei mehreren, welches davon irgend welche Label hat. Das
      % ist voraussichtlich das Haupt-Handle
      for k = find(I_ax)'
        for ls = ['x', 'y', 'z']
          ll = get(fch(k), [ls, 'label']);
          if ~isempty(get(ll, 'String'))
            I_axlabel(k) = true;
          end
        end
      end
    else
      I_axlabel = I_ax; % Nehme das Axis-Handle, egal ob mit oder ohne Label
    end
    for k = find(I_axlabel)'
      if strcmp(get(fch(k), 'type'), 'axes')
        ax(i,j) = fch(k); % get handle to axes of figure
        pause(0.5)
        fighdl_to_close(i,j) = h1;
        break;
      end
    end
  end
end

figure(figHandle);
for i = 1:n_rows
  for j = 1:n_cols
    % create new figure
    sphdl = subplot(n_rows,n_cols,sprc2no(n_rows,n_cols,i,j)); %create and get handle to the subplot axes
    f_ij_ch = get(ax(i,j),'children');
    for k = 1:length(f_ij_ch)
      copyobj(f_ij_ch(k), sphdl);
    end
    axhdl(i,j) = sphdl;
    % Merkmale des Axis-Objektes mitkopieren
    proplist = {'xlabel', 'ylabel', 'zlabel', 'title', 'FontName', 'FontSize', ...
      'GridAlpha', 'GridAlphaMode', 'GridColor', 'GridColorMode', 'GridLineStyle', ...
      'XGrid', 'YGrid', 'XScale', 'YScale', 'Box', 'BoxStyle', 'xlim', 'ylim', 'zlim', ...
      'XDir', 'YDir', 'ZDir', 'Units', 'Colormap', 'ColorScale'};
    for k = 1:length(proplist)
      set(axhdl(i,j), proplist{k}, get(ax(i,j), proplist{k}));
    end
  end
end

% Kopiere andere Figure-Handles in das neue Figure (z.B. Legenden)
c = 0;
for f = fighhdl_in(:)'
  fch = get(f, 'children');
  for i = 1:length(fch)
    if any(fch(i) == ax(:))
      continue % ist schon das Haupt-Axis-Handle, das kopiert wurde
    end
    if strcmp(get(fch(i), 'Type'), 'colorbar')
      continue
    end
    c = c + 1;
    other_hdl(c) = copyobj(fch(i), figHandle); %#ok<AGROW> 
  end
end

for k = 1:length(fighdl_to_close(:))
  close(fighdl_to_close(k));
end