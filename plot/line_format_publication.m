% Linienformatierung eines axis-Objektes für Publikationen.
% Die Linien werden so optimiert, dass sie möglichst schwarz-weiß-tauglich
% sind.
% Dazu bekommt jede Linie einen Marker
% 
% Eingabe:
% linhdl
%   Handle zu Line-Objekten, die entsprechend der vorgegebenen Reihenfolge
%   gefärbt werden
% format
%   cell array mit Formatierungen für jede Linie
%   Zeilen: Format für einzelne Linien
%   Spalten:
%     Farbe (String oder 1x3 double)
%     Marker (String)
%     Linienstrichelung (String)
%     Markeranzahl (auf gesamte Datenreihe verteilt)
% displaynames
%   Cell mit Namen, die als Displayname eingesetzt werden. Dadurch werden
%   die Linien später besser erkannt.
% 
% Ausgabe:
% leghdl
%   Handle der Linien für Legendeneinträge (es werden neue Linien
%   eingezeichnet).

% Moritz Schappler, schappler@irt.uni-hannover.de, 2015-08
% (c) Institut für Regelungstechnik, Universität Hannover

function leghdl = line_format_publication(linhdl, format, displaynames)

leghdl = NaN(length(linhdl),1);

% Standard-Format definieren
if nargin < 2 || isempty(format)
  format = {'r',  '', '-', 0; ...
            'k', 'd', '-', 25; ...
            'b', 's', '-', 25; ...
            'm', 'x', '-', 25; ...
            'k', '',  ':', 25; ...
            'g', 'v', '-', 25};
end
if nargin < 3 || isempty(displaynames)
  displaynames = cell(length(linhdl),1);
  for i = 1:length(linhdl)
    displaynames{i} = sprintf('linhdl_%d', i);
  end
end

hold on;

for i = 1:length(linhdl)
  % Namen setzen, damit Linien wiederfindbar sind
  set(linhdl(i), 'DisplayName', displaynames{i});
  % Linienformat setzen
  set(linhdl(i), 'Color', format{i,1}, 'LineStyle', format{i,3}, 'Marker', 'none');
  
  % Marker so setzen, dass sie gut verteilt sind und Legendeneinträge gut
  % aussehen
  if ~strcmp(format{i,2}, '')
    X = get(linhdl(i), 'XDATA');
    Y = get(linhdl(i), 'YDATA');
    % Indizes zur Auswahl der Zeitpunkte für das Setzen der Marker
    I_Ausw = round(linspace(1, length(X), format{i,4})); % Indizes zur Auswahl: Alle 25 Datenpunkte ein Marker
    % Handle des Axis-Objekts herausfinden, um die Marker dort zu plotten
    ax = get(linhdl(i), 'Parent');
    % Nur die Marker plotten (axis-Objekt muss nicht im Fokus (gca) sein)
    h = plot(ax, X(I_Ausw), Y(I_Ausw), format{i,2}, 'Color', format{i,1});
    set(h, 'DisplayName', sprintf('%s: Marker', displaynames{i}));
    % Nichts plotten, Leeren Plot für Legendeneintrag erzeugen
    leghdl(i) = plot(NaN, NaN, [format{i,2}, format{i,3}], 'Color', format{i,1}); % Für Legende
    set(leghdl(i), 'DisplayName', sprintf('%s: Legend Dummy', displaynames{i}));
  else
    leghdl(i) = linhdl(i);
  end
end