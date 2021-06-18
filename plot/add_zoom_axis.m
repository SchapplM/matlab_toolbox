% Füge einen Vergrößerungsausschnitt eines bestehenden Axis-Objekts hinzu
% 
% Eingabe:
% axhdl
%   Handle zum Axis-Objekt, für das der Ausschnitt erzeugt wird
% zoomrange
%   Vergrößerungsbereich in Koordinaten des Axis-Objekts
%   2x2. Erste Zeile xlim, zweite Zeile ylim.
% 
% Ausgabe:
% newaxhdl
%   Handle zum neu erzeugten Axis-Objekt, dass die Vergrößerung enthält
% boxhdl
%   Linien-Objekt, das den Ausschnitt im alten Axis-Objekt einzeichnet.

% Moritz Schappler, moritz.schappler@imes.uni-hannover.de, 2021-05
% (C) Institut für Mechatronische Systeme, Leibniz Universität Hannover

function [newaxhdl, boxhdl] = add_zoom_axis(axhdl, zoomrange)
% Eingabe prüfen
assert(all(size(zoomrange)==[2 2]), 'zoomrange muss 2x2 sein');
assert(all(zoomrange(:,1)<zoomrange(:,2)), 'zoomrange muss min, max sein');
% Kopie des bestehenden Objekts erzeugen
fighdl = get(axhdl, 'parent');
newaxhdl = copyobj(axhdl,fighdl);
% Formatierung einstellen
set(newaxhdl, 'xlim', zoomrange(1,:));
set(newaxhdl, 'ylim', zoomrange(2,:));
xlh = get(newaxhdl, 'xlabel');
set(xlh, 'String', '');
ylh = get(newaxhdl, 'ylabel');
set(ylh, 'String', '');
set(newaxhdl, 'xticklabel', {});
set(newaxhdl, 'yticklabel', {});
set(newaxhdl, 'Box', 'on'); % Rand vollständig zeichnen

% Rahmen in bestehenden Plot einzeichnen
boxhdl = plot(axhdl, [zoomrange(1,1),zoomrange(1,1),zoomrange(1,2),...
  zoomrange(1,2),zoomrange(1,1)],[zoomrange(2,1),zoomrange(2,2),...
  zoomrange(2,2),zoomrange(2,1),zoomrange(2,1)], 'k-', 'LineWidth', 1);

% Textfelder löschen (passen nicht mehr in neuen Plot)
naxch = get(newaxhdl, 'children');
for i = 1:length(naxch)
  if strcmp(get(naxch(i), 'type'), 'text')
    delete(naxch(i));
  end
end
