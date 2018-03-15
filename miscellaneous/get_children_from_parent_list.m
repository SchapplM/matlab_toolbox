% Bestimme die Nachfolgerelemente einer Baumstruktur, wenn nur eine Liste
% der Vorgängerelemente gegeben ist.
% Kann benutzt werden, um Nachfolger-Segmente in kinematischen
% Baumstrukturen zu bestimmen.
% 
% Eingabe:
% v [Nx1]
%   Liste mit Vorgänger-Elementen (ohne Schleifen)
%   Beinhaltet Indizes der Vorgänger-Elemente. Eine 1 bezieht sich dabei
%   auf das erste Element der Liste.
% i [1x1]
%   Index des aktuellen Elements
% 
% Ausgabe:
% n [Mx1]
%   Liste mit Nachfolger-Elementen zu i

% Moritz Schappler, schappler@irt.uni-hannover.de, 2016-07
% (c) Institut für Regelungstechnik, Universität Hannover

function n = get_children_from_parent_list(v,i)

assert(all(size(i) == [1 1]), ...
  'get_children_from_parent_list: i has to be [1x1]');

% Ausgabevariable: Nachfolgerelemente
n = NaN(length(v),1);
% Liste mit noch zu untersuchenden Elementen (maximal so groß wie
% Eingabedaten)
I_offen = NaN(length(v)+1,1);

kk = 1; % Laufindex für n
ll = 2; % Laufindex für I_offen
I_offen(1) = i;

for jj = 1:length(v) % Endlosschleife mit maximaler Länge (wird vorher abgebrochen)
  if isnan(I_offen(jj))
    break;
  end
  
  % Suche Elemente, die Segment I_offen(jj) als Vorgänger haben
  I_vi = find( ((v) == I_offen(jj)) );
  
  if isempty(I_vi)
    % Keine Nachfolger. Ende
    continue
  end
  
  % Füge diese Elemente zur Nachfolgerliste hinzu
  n( kk:(kk+length(I_vi)-1) ) = I_vi;
  kk = kk + length(I_vi);
  
  % Durchsuche die gefundenen Nachfolger auch nach Nachfolgern.
  % Setze sie auf die Warteliste
  I_offen( ll:(ll+length(I_vi)-1) ) = I_vi;
  ll = ll + length(I_vi);
end

% Kürze NaN in Ausgabevariable
n = n(1:kk-1);
