% Gebe minimale und maximale Werte aller Datenreihen aus gegebenen
% axes-Objekten zurück
% 
% Eingabe:
% axhdl
%   [mxn] handle zu Axes-Objekten
% axstring
%   'x', 'y', 'z'
% 
% Ausgabe
% minmax_total
%   [1x2] Minimal- und Maximalwert aller enthaltener Datenreihen
%   (Line-Objekte)
% minmax_all
%   [m*n x 2] Minimal- und Maximalwert für jede enthaltene Datenreihe
%   getrennt

% Moritz Schappler, schappler@irt.uni-hannover.de, 2016-03
% (c) Institut für Regelungstechnik, Universität Hannover


function [minmax_total, minmax_all] = axes_get_minmax_data(axhdl, axstring)

minmax_all = NaN(length(axhdl(:)), 2);

for i = 1:length(axhdl)
  Lines = get(axhdl(i),'children');
  for j = 1:length(Lines)
    data = get(Lines(j),sprintf('%sdata', axstring));
    if any(isnan(data))
      continue
    end
    if j == 1
      minmax_all(i,:) = minmax2(data);
    else
      minmax_all(i,:) = minmax2([data, minmax_all(i,:)]);
    end
    
  end
end

minmax_total = minmax2(minmax_all(:)');