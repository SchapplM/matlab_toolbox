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
%   Liste mit Vorgänger-Elementen zu i
% TODO: Indizes klären (Verschiebung +-1)
%       Die Indizes sollen eher mathematisch formuliert sein und nicht auf
%       MDH-Notation bezogen

% Moritz Schappler, schappler@irt.uni-hannover.de, 2016-09
% (c) Institut für Regelungstechnik, Universität Hannover

function cl = get_parents_from_parent_list(v,i)

assert(all(size(i) == [1 1]), ...
  'get_parents_from_parent_list: i has to be [1x1]');

cl = NaN(length(v),1);
j = i;
tt = 0; % Laufindex für Ergebnisvariable
for tmp = 1:length(v)
  tt = tt + 1;
  % Vorgänger-Index
  k = v(j-1); % j-1
  
  j = k+1;
  
  cl(tt) = j;
  
  if j == 1 %0 % 1
    % An erstem angekommen
    break;
  end
end

cl = cl(1:tt);