% Strukturen mit zeitbasierten Daten zusammenführen
% 
% Eingabe:
% struct_in1,struct_in2
%   Struktur mit beliebigen Feldern, die eine Zeitreihe beinhalten sollten
%   (Zeile: Zeit, Spalte: Signale)
% 
% Ausgabe:
% struct_out
%   Struktur, die die Signale der beiden Eingangsstrukturen
%   enthält

% Moritz Schappler, schappler@irt.uni-hannover.de, 2017-03
% (c) Institut für Regelungstechnik, Universität Hannover

function struct_out = timestruct_merge(struct_in1, struct_in2)
struct_out = struct_in1;
% Gehe alle Felder durch und hänge alle Felder an
for fn = fieldnames(struct_in2)'
  if isfield(struct_out, fn{1})
    % Feld existiert bereits in struct_in1. Nicht anhängen.
    Diff = struct_in1.(fn{1}) - struct_in2.(fn{1});
    if any(abs(Diff) > 1e-10 )
      error('Beide Strukturen haben ein Feld %s mit unterschiedlichen Werten', fn{1});
    else
      % Die Werte sind gleich
      continue
    end
  end
  % An AusgabeStruktur anhängen
  struct_out.(fn{1}) = struct_in2.(fn{1});  
end