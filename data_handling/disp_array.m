% Ausgabe von Matrizen wie die Matlab-Eingabe
% Dient zum schnellen Ausgeben von Ergebnissen
% 
% Beispiele:
% ['[',disp_array((1:5), '%1.1f'),']']
% ['[',disp_array((10:-1:3)', '%1.0f'),']']

% Moritz Schappler, schappler@imes.uni-hannover.de, 2018-03
% (C) Institut für Mechatronische Systeme, Leibniz Universität Hannover

function s = disp_array(x, format)
s = '';
for i = 1:size(x, 1)
    if i>1
        s = [s, newline()]; %#ok<AGROW>
    end   
    for j = 1:size(x, 2)
        if j>1
            s = [s, ', ']; %#ok<AGROW>
        end
        % Prüfe, ob Variable symbolisch, cell-array oder Zahl ist.
        % Bei Cell wird angenommen, dass der Inhalt ein String ist.
        if isa(x(i, j), 'sym') || nargin == 1
            s = [s, char(x(i, j))]; %#ok<AGROW>
        elseif isa(x(i, j), 'cell')
            s = [s, '''', x{i, j}, '''']; %#ok<AGROW>
        else
            s = [s, sprintf(format, x(i, j))]; %#ok<AGROW>
        end
    end
    if size(x, 1) > 1 && i ~= size(x, 1)
        s = [s, sprintf('; ...')]; %#ok<AGROW>
    end       
end
