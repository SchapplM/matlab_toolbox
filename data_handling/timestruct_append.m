% Strukturen mit Zeitreihen aneinanderhängen
% 
% Eingabe:
% struct_old
%   Struktur mit beliebigen Feldern, die eine Zeitreihe beinhalten sollten
%   (Zeile: Zeit, Spalte: Signale)
% struct_append
%   Struktur mit gleicher Art wie struct_old
% timeshift [1x1]
%   Zeit, um die die anzuhängende Struktur nach hinten verschoben werden
%   soll. Dient dazu, einen konsistenten Zeitverlauf zu erhalten
% 
% Ausgabe:
% struct_new
%   Struktur, die die Signale der beiden Eingangsstrukturen
%   aneinandergehängt enthält

% Moritz Schappler, schappler@irt.uni-hannover.de, 2016-04
% (c) Institut für Regelungstechnik, Universität Hannover

function struct_new = timestruct_append(struct_old, struct_append, timeshift)
struct_new = struct_old;

  
% Verschiebe die Zeit der anzuhängenden Daten
if nargin > 2 && isfield(struct_append, 't')
  struct_append.t = struct_append.t + timeshift;
end

% Gehe alle Felder durch und hänge alle Felder an
n1 = NaN;
for fn = fieldnames(struct_old)'
  fns = fn{1};
  if ~isfield(struct_append, fns)
    error('timestruct_append:FieldMismatch', 'Anzuhängende Struktur hat kein Feld %s', fns);
  end
  if isempty(struct_append.(fns))
    % Leere Felder lassen sich nicht anhängen
    continue
  end
  if size(struct_new.(fns),3) == 1
    struct_new.(fns) = [struct_new.(fns); struct_append.(fns)];
  else
    [d1,d2,~] = size(struct_old.(fns));
    tmp = NaN(d1,d2,size(struct_old.(fns),3)+size(struct_append.(fns),3));
    tmp(:,:,1:size(struct_old.(fns),3)) = struct_old.(fns);
    tmp(:,:,size(struct_old.(fns),3)+1:end) = struct_append.(fns);
    struct_new.(fns) = tmp;
  end
  % Prüfen ob die Dimensionen stimmen
  if isnan(n1)
    n1 = length(struct_new.(fns));
  elseif n1 ~= length(struct_new.(fns))
    error('Die Anzahl der Einträge ist nicht konsistent!');
  end    
end

% Prüfe Zeitverlauf
% Verschiebe die Zeit der anzuhängenden Daten
if nargin > 2 && isfield(struct_new, 't')
  dt = diff(struct_new.t);
  if any(dt <= 0)
    warning('Der Zeitverlauf der Gesamtstruktur ist nicht streng monoton steigend!');
  elseif length(unique(round(dt/mean(dt),4))) > 1
    warning('Die Zeitschritte sind nicht äquidistant! %e<=dt<=%e',min(dt),max(dt));
  end
end