% Docke alle Figures an

% (C) Moritz Schappler, moritz.schappler@imes.uni-hannover.de, 2012

function dockall()
    figHandles = findobj('Type','figure');
    for i = 1:length(figHandles)
        hdl = figure(figHandles(i));
        set(hdl, 'WindowStyle', 'docked')         
    end