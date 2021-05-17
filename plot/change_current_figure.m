% Wechsle zu einem neuen Fenster ohne den Fokus auf Matlab zu ziehen
% Nützlich für Skripte, in denen viele Bilder generiert werden, während
% gleichzeitig am Rechner gearbeitet wird.
% 
% Eingabe:
% h
%   Nummer des Figure-Handles (Sollte in Plot-Skripten auf einen
%   definierten Wert gesetzt werden).

% https://stackoverflow.com/questions/8488758/inhibit-matlab-window-focus-stealing

% Moritz Schappler, moritz.schappler@imes.uni-hannover.de, 2019-08
% (C) Institut für Mechatronische Systeme, Universität Hannover

function h_out = change_current_figure(h)
try
  set(0,'CurrentFigure',h);
  h_out = h;
  if nargout > 0 && ~isa(h,'handle')
    h_out = gcf(); % Ausgabe muss echtes handles sein
  end
catch
  h_out = figure(h);
end
