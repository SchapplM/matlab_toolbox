% Anordnung von Subplots mit prozentualen Größenangaben Verändern
% 
% Eingabe:
% fig_handle
%   figure handle
% fig_width
%   figure width in cm
% fig_height
%   figure height in cm
% axhdl
%   array of axis handles according to subplots.
%   can be any matrix ([1x2, 2x1, 2x2, ...]
% bl                
%   left border, [0-1] in percent
% br                
%   right border, [0-1] in percent
% hu                
%   upper border, [0-1] in percent
% hd                
%   lower border, [0-1] in percent
% bdx               
%   gap betweenploots in x, [0-1] in percent
% bdy               
%   gap betweenploots in y, [0-1] in percent 


% Moritz Schappler schappler@irt.uni-hannover.de, 2015-09
% Alexander Tödtheide toedtheide@irt.uni-hannover.de, 2015-06
% (c) Institut für Regelungstechnik, Leibniz Universität Hannover

function set_sizePositionPlotSubplot_byHandle(fig_handle,fig_width,fig_height,axhdl,bl,br,hu,hd,bdx,bdy)

% Die Größe und Position von Figure und Subplots bestimmen

% Alexander Tödtheide toedtheide@irt.uni-hannover.de, 2015-06
% (c) Institut für Regelungstechnik, Leibniz Universität Hannover
% shape = [4,2];  
n_rows = size(axhdl,1);
n_cols = size(axhdl,2);

% Breite und Höhe der subplots (alle gleich groß)
b = (1 - bl - br -(n_cols-1)*bdx)/n_cols;
h = (1 - hu - hd -(n_rows-1)*bdy)/n_rows;

%% Größe setzen

% Größe der axis-handles
for ii = 1:n_rows
  for jj = 1:n_cols
    % referred to the coordinate frame on the upper left corner
    x_frame = bl + (jj -1)*(b + bdx);
    y_frame =  1-hu -(ii -1)*(h + bdy)-h;
    
    set(axhdl(ii,jj),'position',[x_frame y_frame b h]);  
  end
end

% Größe des figure-handles
set(fig_handle, 'units', 'centimeters', ...
  'pos', [0 0 fig_width fig_height], ...
  'paperunits','centimeters', ...
  'papersize',[fig_width fig_height]);
end
