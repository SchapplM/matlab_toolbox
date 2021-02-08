% Bilder gemäß Vorgaben für IEEE-Konferenz formatieren
% 
% Eingabe:
% hdl
%   handles von axis- oder figure-Objekten (optional)

% Moritz Schappler, schappler@irt.uni-hannover.de, 2015-06
% (c) Institut für Regelungstechnik, Leibniz Universität Hannover

function figure_format_publication(hdl)
axhdl = [];
if nargin == 0
  fighdl = gcf;
elseif strcmp(get(hdl,'Type'), 'figure')
  fighdl = hdl;
elseif strcmp(get(hdl,'Type'), 'axes')
  fighdl = gcf;
  axhdl = hdl;
else
  error('undefined input');
end

if isempty(axhdl)
  fch = get(fighdl, 'children');
  axhdl = fch(strcmp(get(fch,'Type'),'axes'));
end

for i = 1:length(axhdl(:))
  axes(axhdl(i)); %#ok<LAXES>

  % Ticklabels formatieren
  set(gca, 'FontSize', 8);
  set(gca, 'FontName', 'times');
  % Achsenbeschriftung formatieren
  for label = {'XLABEL', 'YLABEL', 'ZLABEL', 'TITLE'}
    h = get(gca, cell2str(label));
    % 8pt Times new roman
    set(h, 'FontSize', 8);
    set(h, 'FontName', 'times');
  end
  
  % Achsen-Einteilungsbeschriftung formatieren
  % ??

  % Rand vollständig zeichnen
  set(gca, 'Box', 'on');

  % Legende formatieren

  set(gca, 'FontName', 'times', 'FontSize', 8);
  
  % Textfelder
  ch = get(gca,'children');
  for j = 1:length(ch)
    if strcmp(get(ch(j), 'type'), 'text')
      set(ch(j), 'FontName', 'times');
    end
  end
end

% Weißer Hintergrund
set(gcf,'color','w');

% sgtitle formatieren
txthdl = fch(strcmp(get(fch,'Type'),'subplottext'));
set(txthdl, 'FontName', 'Times');
