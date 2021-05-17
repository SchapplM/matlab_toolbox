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
% relpos
%   Relative Position auf der Achse. Zwischen -1 und 1.
%   -1 ist der kleinste Wert, 0 die Mitte, +1 der größe Wert.
% 
% Ausgabe:
% A_off
%   Offset dieser Achse. Gibt die Achsenkoordinaten bei 50% des
%   Wertebereichs an
% A_slope
%   Steigung zwischen der Achse und den relativen Koordinaten
% A_pos
%   Absoluter Wert im Koordinatensystem bei relpos

% Benutzung für manuelle Berechnung der Position auf der Achse
% [X_off, X_slope] = get_relative_position_in_axes(axhdl(i), 'x');
% Bei linearer Achse:
% X_off+X_slope*( 1) % liefert die Koordinaten am oberen Ende (100%)
% X_off+X_slope*( 0) % liefert die Koordinaten in der Mitte (bei 0%)
% X_off+X_slope*(-1) % liefert die Koordinaten am unteren Ende (-100%)
% Bei logarithmischer Achse:
% X_off*X_slope^( 1/2+0.5) % Koordinaten bei  100%
% X_off*X_slope^( 0/2+0.5) % Koordinaten bei    0%
% X_off*X_slope^(-1/2+0.5) % Koordinaten bei -100%
% 
% Benutzung für automatische Berechnung der Position auf der Achse
% [~, ~, A_pos] = get_relative_position_in_axes(axhdl(i), 'x', 1);

% Moritz Schappler, moritz.schappler@imes.uni-hannover.de, 2016-02
% (c) Institut für Regelungstechnik, Leibniz Universität Hannover

function [A_off, A_slope, A_pos] = get_relative_position_in_axes(axhdl, axstring, relpos)
A_off = NaN(size(axhdl));
A_slope = NaN(size(axhdl));
A_pos = NaN(size(axhdl));
for i = 1:length(axhdl)
  al = get(axhdl(i), [axstring,'LIM']);
  % Lineare Achse
  if strcmp(get(axhdl(i), [axstring,'Scale']), 'linear')
    % Transformation zwischen Achsen-Einheiten und prozentualer Angabe
    % Herleitung mit Steigungsdreieck aus y, y_min, y_max
    A_off(i) = (al(2)+al(1))/2;
    A_slope(i) = ((al(2)-al(1))/2);
    if nargout == 3
      A_pos(i) = A_off(i) + A_slope(i)*relpos(i);
    end
  % Logarithmische Achse
  elseif strcmp(get(axhdl(i), [axstring,'Scale']), 'log')
    A_off(i) = al(1); % Untere Grenze
    A_slope(i) = al(2)/al(1); % Verhältnis von oberer und unterer Grenze
    if nargout == 3
      % Umrechnung so, dass oben +1 ist und unten -1.
      A_pos(i) = A_off(i)*A_slope(i)^(relpos(i)/2+0.5);
    end
  else
    warning('Unerwarteter Achs-Typ');
  end
end
    