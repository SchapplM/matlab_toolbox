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

% Moritz Schappler moritz.schappler@imes.uni-hannover.de, 2015-09
% Alexander Tödtheide toedtheide@irt.uni-hannover.de, 2015-06
% (c) Institut für Regelungstechnik, Leibniz Universität Hannover

function set_size_plot_subplot(fig_handle,fig_width,fig_height,axhdl,bl,br,hu,hd,bdx,bdy)

n_rows = size(axhdl,1);
n_cols = size(axhdl,2);
% Breite und Höhe der subplots (alle gleich groß)
b = (1 - bl - br -(n_cols-1)*bdx)/n_cols;
h = (1 - hu - hd -(n_rows-1)*bdy)/n_rows;
% Reihenfolge der Objekte speichern (Axis, Text, ...)
figch = get(fig_handle, 'children');
hIndex_all = NaN(length(figch),1);
for i = 1:length(figch)
  hIndex_all(i) = ZOrderGet(figch(i));
end
hIndex_all_flip = flipud(hIndex_all);
%% Maximierung aufheben
if strcmp(get(fig_handle, 'WindowStyle'), 'docked')
  set(fig_handle, 'WindowStyle', 'docked');
end
% Aus figureFullScreen.m; Nikolay S.
% Falls die Fenster-Maximierung nicht mehr zu entfernen ist, muss vorher
% sichergestellt werden, dass das Fenster nicht über das Betriebssystem
% maximiert wurde.
try %#ok<TRYNC>
  warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
  warning('off','MATLAB:ui:javaframe:PropertyToBeRemoved');
  jFrame = get(fig_handle,'JavaFrame'); %#ok<JAVFM> % TODO: Replace for future Matlab versions
  pause(0.3);    % unless pause is used error accures from time to time. 
                 % I guess jFrame takes some time to initialize
  set(jFrame,'Maximized',false);
  warning('on','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
  warning('on','MATLAB:ui:javaframe:PropertyToBeRemoved');
end
%% Größe setzen
% Größe der axis-handles
for ii = 1:n_rows
  for jj = 1:n_cols
    if length(axhdl(:))>1 && isa(axhdl(ii,jj), 'double') && isnan(axhdl(ii,jj))
      warning(['Element (%d,%d) of the axhdl array is NaN. You should ' ...
        'use gobjects to initialize the axhdl array.'], ii, jj);
      continue;
    end
    if isa(axhdl(ii,jj), 'matlab.graphics.GraphicsPlaceholder')
      continue;
    end
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

% Reihenfolge der Objekte wiederherstellen. Durch die Größenänderung ist
% die Reihenfolge geändert und die geänderten Objekte sind im Vordergrund.
% Werden zusätzliche Axis-Objekte eingeblendet, rücken diese ansonsten in
% den Hintergrund. TODO: Funktioniert beim zweiten Aufruf anders als beim ersten.
for i = 1:length(figch)
  ZOrderSet(figch(i), hIndex_all_flip(i));
end
