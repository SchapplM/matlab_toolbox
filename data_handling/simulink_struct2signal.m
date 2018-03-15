% Matlab-Zeitdaten-Struktur in Simulink-Signal-Struktur umwandeln
% Dient zum Testen von Skripten: So können Simulink-Ausgaben simuliert
% werden um Kompatibilität zu testen
% 
% Eingabe:
% signal_struct
%   Struktur mit den Messdaten. Die Zeit wird in den Zeilen und die Signale
%   in den Spalten abgelegt
% 
% Ausgabe:
% signal
%   Signal-Struktur, die entsteht, wenn im Simulink external Mode ein Scope
%   gespeichert wird
%
% Siehe auch: simulink_signal2struct.m

% Moritz Schappler, schappler@irt.uni-hannover.de, 2017-02
% (c) Institut für Regelungstechnik, Universität Hannover

function signal = simulink_struct2signal(signal_struct)


signal = struct('time', signal_struct.t, 'blockName', 'Generated', ...
  'signals', struct('values',[],'dimensions',[],'label',[],'title',[],'plotStyle',[]));
% Gehe alle Felder durch und belege die Struktur
i = 0;
for f = (fields(signal_struct))'
  fs = f{1};
  if strcmp(fs, 't')
    continue
  end
  i = i + 1;
  signal.signals(i).values = signal_struct.(fs);
  signal.signals(i).dimensions = size(signal_struct.(fs),2);
  signal.signals(i).label = fs;
  signal.signals(i).title = [];
  signal.signals(i).plotStyle = [1 1];
end
