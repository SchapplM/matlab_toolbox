% Docke alle Figures an

% Moritz Schappler, moritz.schappler@imes.uni-hannover.de, 2012
% (C) Institut für Mechatronische Systeme, Leibniz Universität Hannover

function dockall()
  figHandles = findobj('Type','figure');
  for i = 1:length(figHandles)
    hdl = figHandles(i);
    if ~strcmp(get(hdl, 'WindowStyle'), 'docked')
      set(hdl, 'WindowStyle', 'docked');
    end
  end