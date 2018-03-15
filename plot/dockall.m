% Docke alle Figures an

function dockall()
    figHandles = findobj('Type','figure');
    for i = 1:length(figHandles);
        hdl = figure(figHandles(i));
        set(hdl, 'WindowStyle', 'docked')         
    end