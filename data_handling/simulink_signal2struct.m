% Ansammlung von Simulink-Signalen in Struktur umwandeln
% 
% Eingabe:
% signal
%   Signal-Struktur, die entsteht, wenn im Simulink external Mode ein Scope
%   gespeichert wird
% 
% Ausgabe:
% signal_struct
%   Struktur mit den Messdaten. Die Zeit wird in den Zeilen und die Signale
%   in den Spalten abgelegt

% Moritz Schappler, schappler@irt.uni-hannover.de, 2016-04
% (c) Institut für Regelungstechnik, Universität Hannover

function signal_struct = simulink_signal2struct(signal)

% Gehe alle Felder durch und belege die Struktur
signal_struct = struct('t', signal.time);
nt = length(signal.time);
nn = length(signal.signals);
for j = 1:nn
  name = signal.signals(j).label;
  % spitze Klammern entfernen (tritt bei Bus-Signalen auf)
  name = strrep(name, '<', '');
  name = strrep(name, '>', '');
  % Leere Signalnamen ignorieren und nicht speichern
  if isempty(name)
      continue
  end
  signal_struct.(name) = signal.signals(j).values;

  % Probleme mit 2x1-Signalen
  if any(size(signal.signals(j).dimensions) > 1) && any(size(signal.signals(j).dimensions) == 1)
    % nx1
    if signal.signals(j).dimensions(2) == 1
      signal_struct.(name) = reshape(signal_struct.(name), max(signal.signals(j).dimensions), nt)';
    else % nxm
      % Nichts unternehmen. Das Datenformat ist nxmxnt
    end
  end
end
