% Ändere x-Werte aller gezeichneter Daten
% 
% Durchsucht alle Kind-Elemente des übergebenen Figure-Handles fighdl und
% verschiebt die x-Werte um einen festgelegten Offset x_off

% Moritz Schappler, schappler@irt.uni-hannover.de, 2016-02
% (c) Institut für Regelungstechnik, Leibniz Universität Hannover

function change_x_data(fighdl, x_off)


hAllAxes = findobj(fighdl,'type','axes');

% loop through all axis
for i = 1:length(hAllAxes)
  linhdl = findobj(hAllAxes(i),'type','Line');
  % loop through all lines
  for j = 1:length(linhdl)
    xdata = get(linhdl(j), 'XDATA');
    % Verschieben Daten in der x-Achse
    set(linhdl(j), 'XDATA', xdata+x_off);
  end
end