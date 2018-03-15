% Umbenennung von Feldern in einer Struktur
% 
% Eingabe:
% struct_in
%   Eingabe-Struktur
% prefix
%   String, der den Feldern vorgestellt werden soll
% 
% Ausgabe:
% struct_out
%   Struktur mit umbenannten Feldern

% Moritz Schappler, schappler@irt.uni-hannover.de, 2017-09
% (C) Institut für Regelungstechnik, Universität Hannover

function struct_out = timestruct_rename_fields_prefix(struct_in, prefix)
struct_out = struct('t', struct_in.t);
% Gehe alle Felder durch und benenne sie um
for fn = fieldnames(struct_in)'
  if strcmp(fn{1}, 't') % Zeit-Feld nicht umbenennen
    continue
  end
  struct_out.(sprintf('%s%s',prefix,fn{1})) = struct_in.(fn{1});
end