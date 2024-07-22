% Daten aus Strukturen mit Zeitreihen auswählen
% 
% Eingabe:
% struct_in
%   Struktur mit beliebigen Feldern, die eine Zeitreihe beinhalten sollten
%   (Zeile: Zeit, Spalte: Signale)
% I_SE [nx2]
%   Matrix mit Start- und Endindizes
% 
% Ausgabe:
% struct_out
%   Struktur, die nur die über Indizes ausgewählten Zeitbereiche enthält

% Moritz Schappler, schappler@irt.uni-hannover.de, 2016-04
% (c) Institut für Regelungstechnik, Universität Hannover

function struct_out = timestruct_select(struct_in, I_SE)
struct_out = struct_in;
% Gehe alle Felder durch und wähle die Zeitbereiche mit den Indizes aus
for fn = fieldnames(struct_in)'
  tmp = struct_in.(fn{1});
  if isa(tmp, 'struct'), continue; end % hiermit können Zusatz-Informationen übergeben werden
  struct_out.(fn{1}) = []; % Feld zurücksetzen
  for i = 1:size(I_SE, 1)
    if size(tmp,3) == 1
      struct_out.(fn{1}) = [ struct_out.(fn{1}); tmp((I_SE(i,1):I_SE(i,2)), :) ];  
    else
      struct_out.(fn{1}) = [ struct_out.(fn{1}); tmp(:,:,(I_SE(i,1):I_SE(i,2))) ];  
    end
  end
end