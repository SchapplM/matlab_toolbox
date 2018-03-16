% Pfadangabe säubern und absoluten Pfad generieren (entferne relative Pfade)
% Der Pfad muss existieren
% 
% Eingabe:
% pfad: Pfad mit Relativen Teilen
% 
% Ausgabe:
% pfad2: Gesäuberter Pfad
% 
% 
% Moritz Schappler, schappler@imes.uni-hannover.de, 2018-03
% (C) Institut für mechatronische Systeme, Universität Hannover

function pfad2 = clean_absolute_path(pfad)

if exist(pfad, 'file') ~= 7
  error('Der gegebene Pfad muss existieren. %s existiert nicht', pfad)
end

% Zu gegebenem Pfad wechseln und so die absolute Pfadangabe, ohne "../"
% dazwischen generieren
% https://de.mathworks.com/matlabcentral/answers/56363-fully-resolving-path-names#answer_68239
oldwd = pwd();
cd(pfad);
pfad2 = pwd();
cd(oldwd);