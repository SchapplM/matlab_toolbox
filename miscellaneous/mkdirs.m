% Sicheres Erstellen eines Verzeichnisses
% 
% Eingabe:
% Zu erstellendes Verzeichnis
% 
% Ausgabe:
% Fehlercode. 0=i.O.; 1=Fehler

% Moritz Schappler, moritz.schappler@imes.uni-hannover.de, 2018-07
% (C) Institut für Mechatronische Systeme, Universität Hannover

function rval = mkdirs(directory)
rval = 0;
if ~isfolder(directory)
  mkdir(directory);
end
if ~isfolder(directory) % possible reason: invalid symlink exists
  warning('Not able to create %s', directory);
  rval = 1;
end