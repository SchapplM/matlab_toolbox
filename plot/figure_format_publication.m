% Bilder gemäß Vorgaben für IEEE-Konferenz formatieren
% 
% Eingabe:
% axhdl
%   handles zu den axis-Elementen des aktuellen figure

% Moritz Schappler, schappler@irt.uni-hannover.de, 2015-06
% (c) Institut für Regelungstechnik, Leibniz Universität Hannover

function figure_format_publication(axhdl)

if nargin == 0
  axhdl = gca;
end

for i = 1:length(axhdl(:))
  
  axes(axhdl(i)); %#ok<LAXES>

  % Ticklabels formatieren
  set(gca, 'FontSize', 8);
  set(gca, 'FontName', 'times');
  % Achsenbeschriftung formatieren
  for label = {'XLABEL', 'YLABEL', 'ZLABEL'}
    h = get(gca, cell2str(label));
    % 8pt Times new roman
    set(h, 'FontSize', 8);
    set(h, 'FontName', 'times');
  end

  % Achsen-Einteilungsbeschriftung formatieren
  % ??

  % Rand vollständig zeichnen
  set(gca, 'Box', 'on')

end

% Legende formatieren
ch = get(gcf,'children');
set(ch(1), 'FontName', 'times', 'FontSize', 8);

% Weißer Hintergrund
set(gcf,'color','w');
