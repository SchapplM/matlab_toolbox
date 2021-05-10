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
%     Linienstärke (double)
%     Markergröße (double)
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
default_markersize = 6; % 6pt (Matlab-Standard)
default_linewidth = 0.5; % 0.5pt (Matlab-Standard)
if nargin < 2 || isempty(format)
  format = {'r',  '', '-', 0; ...
            'k', 'd', '-', 25; ...
            'b', 's', '-', 25; ...
            'm', 'x', '-', 25; ...
            'k', '',  ':', 25; ...
            'g', 'v', '-', 25};
end
if size(format,2) < 5
  format = [format, repmat({default_linewidth}, size(format,1), 1)];
end
if size(format,2) < 6
  format = [format, repmat({default_markersize}, size(format,1), 1)];
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
  set(linhdl(i), 'LineWidth', format{i,5});
  % Marker so setzen, dass sie gut verteilt sind und Legendeneinträge gut
  % aussehen
  if ~strcmp(format{i,2}, '')
    X = get(linhdl(i), 'XDATA');
    Y = get(linhdl(i), 'YDATA');
    % Indizes zur Auswahl der Zeitpunkte für das Setzen der Marker
    % Alle x Datenpunkte ein Marker. Setzt gleichmäßige Daten voraus.
    I_Ausw = round(linspace(1, length(X), format{i,4}));
    if ~isempty(which('knnsearch')) % Falls Toolbox installiert ist
      % Finde Stützstellen für nicht gleichmäßige Daten (besser)
      I_Ausw = knnsearch(X', (X(1)+(X(end)-X(1))*I_Ausw/length(X))');
    end
    % Handle des Axis-Objekts herausfinden, um die Marker dort zu plotten
    ax = get(linhdl(i), 'Parent');
    % Nur die Marker plotten (axis-Objekt muss nicht im Fokus (gca) sein)
    h = plot(ax, X(I_Ausw), Y(I_Ausw), format{i,2}, 'Color', format{i,1}, ...
      'MarkerSize', format{i,6}, 'LineWidth', format{i,5}); % Marker-Linienstärke wie Plot-Linie
    set(h, 'DisplayName', sprintf('%s: Marker', displaynames{i}));
    % Nichts plotten, leeren Plot für Legendeneintrag erzeugen
    leghdl(i) = plot(NaN, NaN, [format{i,2}, format{i,3}], 'Color', format{i,1}, ... % Für Legende
      'LineWidth', get(linhdl(i), 'LineWidth'), ... % Linienstärke auch für Legende übernehmen
      'MarkerSize', get(linhdl(i), 'MarkerSize'));
    set(leghdl(i), 'DisplayName', sprintf('%s: Legend Dummy', displaynames{i}));
  else
    leghdl(i) = linhdl(i);
  end
end