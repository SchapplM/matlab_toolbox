% Ändere Werte aller gezeichneter Daten durch Skalierung
% 
% Beispiel:
% change_plot_data_scale(gca, [1 1e3 1])
%   multipliziert die y-Plot-Werte mit 1000 (z.B. zur Umwandlung [m] -> [mm])
% 
% Durchsucht alle übergebenen Axes-Handles axhdl [nx1] und
% skaliert die xyz-Werte um einen festgelegten Faktor xyz_scale [3x1]

% Moritz Schappler, schappler@irt.uni-hannover.de, 2016-07
% (c) Institut für Regelungstechnik, Leibniz Universität Hannover

function change_plot_data_scale(axhdl, xyz_scale)


% loop through all axis
for i = 1:length(axhdl)
  % Finde Handle zu line und stair-Plots
  linhdl = findobj(axhdl(i),'type','Line'); 
  Istair = false(length(linhdl),1);
  % Stair müssen separat behandelt werden, da keine z-Eigenschaft.
  linhdl = [linhdl;findobj(axhdl(i),'type','Stair')]; %#ok<AGROW>
  Istair = [Istair; true(length(linhdl)-length(Istair),1)]; %#ok<AGROW>
  % loop through all lines
  for j = 1:length(linhdl)
    % Skaliere Daten in dieser-Achse
    xdata = get(linhdl(j), 'XDATA');
    set(linhdl(j), 'XDATA', xdata*xyz_scale(1));

    ydata = get(linhdl(j), 'YDATA');
    set(linhdl(j), 'YDATA', ydata*xyz_scale(2));
    
    if ~Istair(j)
      zdata = get(linhdl(j), 'ZDATA');
      set(linhdl(j), 'ZDATA', zdata*xyz_scale(3));
    end
  end
end