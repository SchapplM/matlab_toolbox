% Vergleiche zwei Strukturen und gebe die Differenz als Text aus
% 
% Eingabe:
% Set1, Set2
%   Beliebige struct-Variablen mit gleichen Feldern
% verbose (Optional, logical)
%   Textausgabe aktivieren
% 
% Ausgabe:
% isequal
%   logical; true wenn beide Strukturen identische Werte haben und in Set2
%   keine Felder fehlen
% debugstr
%   Log-Ausgabe für Grund der Nicht-Gleichheit

% Moritz Schappler, moritz.schappler@imes.uni-hannover.de, 2023-06
% (C) Institut für Mechatronische Systeme, Leibniz Universität Hannover

function [isequal, debugstr] = compare_structs(Set1, Set2, verbose)
  if nargin < 3
    verbose = false;
  end
  % Rekursiver Aufruf des Vergleichs (für kaskadierte Strukturen)
  [isequal, debugstr] = compare_struct_fcn(Set1, Set2, 'Set1', verbose);
end
function [isequal, debugstr] = compare_struct_fcn(Set1, Set2, prefix, verbose)
% 
% Eingabe:
% Set1, Set2
%   Beliebige struct-Variablen mit gleichen Feldern
% prefix
%   Name des Feldes innerhalb der Gesamt-Struktur
% verbose
%   Siehe oben
% 
% Ausgabe:
% isequal, debugstr
%   Siehe oben
if nargin < 3, prefix=''; end
if nargin < 4, verbose = false; end
debugstr = '';
isequal = true;
  for fcell = fields(Set1)'
    f = fcell{1}; % Feldname
    v1 = Set1.(f); 
    if ~isfield(Set2, f)
      debugstr_i = sprintf('%s: Feld %s fehlt in zweiter Struktur', prefix, f);
      if verbose, disp(debugstr_i); end
      debugstr = [debugstr, newline(), debugstr_i]; %#ok<AGROW>
      isequal = false;
      continue
    end
    v2 = Set2.(f); % Wert
    if isa(Set1.(f), 'struct') % Rekursion
      [isequal_i, debugstr_i] = compare_struct_fcn(v1, v2, [prefix, '.', f], verbose);
      isequal = isequal&isequal_i;
      debugstr = [debugstr, newline(), debugstr_i]; %#ok<AGROW>
    else
      if isa(v1, 'double') || isa(v1, 'logical') || isa(v1, 'uint8')
        str1 = disp_array(v1(:)', '%g');
        str2 = disp_array(v2(:)', '%g');
      elseif isa(v1, 'cell')
        str1 = ['{',disp_array(v1, '%s'),'}'];
        str2 = ['{',disp_array(v2, '%s'),'}'];
      elseif isa(v1, 'char')
        str1 = v1;
        str2 = v2;
      else
        error('Nicht definiert: %s', f);
      end
      if ~strcmp(str1, str2)
        debugstr_i = sprintf('%s.%s: "%s" vs "%s"', prefix, f, str1, str2);
        if verbose, disp(debugstr_i); end
        debugstr = [debugstr, newline(), debugstr_i]; %#ok<AGROW>
        isequal = false;
      end
    end
  end
end