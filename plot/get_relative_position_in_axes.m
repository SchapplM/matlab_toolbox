% Gebe die Parameter zur Umwandlung der Achseneinheiten eines Plots in
% normierte Koordinaten wieder
% Dient zum Positionieren von Textfeldern und Achsenbeschriftungen
% 
% Achseneinheite: Von x_min bis x_max
% Normierte Einheiten: Von -1 bis +1
% 
% Eingabe:
% axhdl
%   Handle zu axis-Objekten
% axstring
%   'x', 'y', oder 'z'
% 
% Ausgabe:
% A_off
%   Offset dieser Achse. Gibt die Achsenkoordinaten bei 50% des
%   Wertebereichs an
% A_slope
%   Steigung zwischen der Achse und den relativen Koordinaten

% Benutzung:
% [X_off, X_slope] = get_relative_position_in_axes(axhdl(i), 'x');
% X_off+X_slope*(0) % liefert die Koordinaten bei 50%
% X_off+X_slope*(1) % liefert die Koordinaten am oberen Ende (100%)
% X_off+X_slope*(-1) % liefert die Koordinaten am unteren Ende (-100%)

% Moritz Schappler, schappler@irt.uni-hannover.de, 2016-02
% (c) Institut für Regelungstechnik, Universität Hannover

function [A_off, A_slope] = get_relative_position_in_axes(axhdl, axstring)

A_off = NaN(size(axhdl));
A_slope = NaN(size(axhdl));
for i = 1:length(axhdl)
    al = get(axhdl( i ), [axstring,'LIM']);
    % Transformation zwischen Achsen-Einheiten und prozentualer Angabe
    % Herleitung mit Steigungsdreieck aus y, y_min, y_max
    A_off(i) = (al(2)+al(1))/2;
    A_slope(i) = ((al(2)-al(1))/2);
end
    