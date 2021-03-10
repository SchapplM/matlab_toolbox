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

% Alexander Tödtheide, schappler@irt.uni-hannover.de, 2015-06
% Moritz Schappler, schappler@irt.uni-hannover.de, 2016-02
% (c) Institut für Regelungstechnik, Universität Hannover

function axhdl = set_fig2subfig(figHandle,CellFigfiles)

n_rows = size(CellFigfiles,1);
n_cols = size(CellFigfiles,2);

axhdl = NaN(size(CellFigfiles));
ax = NaN(size(CellFigfiles));

% Öffne alle figures und merke das Handle zum aktuellen Axes-Objekt (es
% wird nur eins erkannt)
fighdl_to_close = NaN(n_rows, n_cols);
for i = 1:n_rows
  for j = 1:n_cols
    pause(0.5)
    h1=openfig(CellFigfiles{i,j},'reuse'); % open figure
    fch = get(h1, 'children');
    for k = 1:length(fch)
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
    %create new figure
    sphdl = subplot(n_rows,n_cols,sprc2no(n_rows,n_cols,i,j)); %create and get handle to the subplot axes
    copyobj(get(ax(i,j),'children'), sphdl);
    axhdl(i,j) = sphdl;
    % TODO: Merkmale des Axis-Objektes mitkopieren
    % set(axhdl(i,j), 'ylabel', get(ax(i,j), 'ylabel'))
    % set(axhdl(i,j), 'title', get(ax(i,j), 'title'))
  end
end

for k = 1:length(fighdl_to_close(:))
  close(fighdl_to_close(k));
end