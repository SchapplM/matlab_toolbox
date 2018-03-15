% Erzeuge Struktur mit Zeitreihen durch Wiederholung einer gegebene
% Zeitreihe
% Kann benutzt werden, um Warte-Trajektorien zu erzeugen (halten einer
% Position bei Geschwindigkeit Null)
% 
% Eingabe:
% struct_old
%   Struktur mit beliebigen Feldern, die eine Zeitreihe beinhalten sollten
%   (Zeile: Zeit, Spalte: Signale)
% n
%   Anzahl der Wiederholungen des Datenwertes
% 
% Ausgabe:
% struct_new
%   Struktur mit wiederholter Eingangsstruktur struct_old

% Moritz Schappler, schappler@irt.uni-hannover.de, 2017-03
% (c) Institut für Regelungstechnik, Universität Hannover

function struct_new = timestruct_repeat(struct_old, n)
struct_new = struct_old;

% Prüfe die maximale Anzahl der Zeitpunkte in der Eingangsstruktur
% Falls die Struktur gestapelte Matrizen (axbxc enthält ist dies für c=1
% nicht trivial)
nt_max = Inf; % Enthält am Ende die Anzahl der Zeitschritte
for fn = fieldnames(struct_old)'
  fns = fn{1};
  [d1,~,d3] = size(struct_old.(fns));
  if d3 == 1 % Feld ist eine Zeitreihe von Vektoren oder eine einzelne Matrix
    if nt_max > d1
      nt_max = d1;
    end
  end
end

% Gehe alle Felder durch und wiederhole die darin enthaltenen Daten
for fn = fieldnames(struct_old)'
  fns = fn{1};

  if isempty(struct_old.(fns))
    % Leere Felder lassen sich nicht vervielfältigen
    error('zu vervielfältigendes Feld ist leer');
  end
  if size(struct_new.(fns),1) == nt_max
    % Gestapelte Vektoren
    struct_new.(fns) = repmat(struct_old.(fns),n,1);
  else
    % Gestapelte Matrizen
    [d1,d2,~] = size(struct_old.(fns));
    tmp = NaN(d1,d2,nt_max*n);
    for i = 1:n
      tmp(:,:,((i-1)*nt_max+1):i*nt_max) = struct_old.(fns);
    end
    struct_new.(fns) = tmp;
  end
end
