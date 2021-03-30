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
else
  % Es ist kein Figure-Handle gegeben, also kein Kind-Elemente bestimmbar
  fch = [];
end

for i = 1:length(axhdl(:))
  axes(axhdl(i)); %#ok<LAXES>

  % Ticklabels formatieren
  set(axhdl(i), 'FontSize', 8);
  set(axhdl(i), 'FontName', 'times');
  % Achsenbeschriftung formatieren
  for label = {'XLABEL', 'YLABEL', 'ZLABEL', 'TITLE'}
    h = get(axhdl(i), cell2str(label));
    % 8pt Times new roman
    set(h, 'FontSize', 8);
    set(h, 'FontName', 'times');
  end
  % Achsenbeschriftung bei Box-Plots
  axch = get(axhdl(i), 'children');
  axchch = get(axch, 'children');
  for kk = 1:length(axchch)
    if ~isa(axchch(kk), 'cell') && strcmp(get(axchch(kk), 'Type'), 'text')
      hh = axchch(kk);
      set(hh, 'FontSize', 8);
      set(hh, 'FontName', 'times');
    end
  end
  % Achsen-Einteilungsbeschriftung formatieren
  % ??

  % Rand vollständig zeichnen
  set(axhdl(i), 'Box', 'on');

  % Legende formatieren

  set(axhdl(i), 'FontName', 'times', 'FontSize', 8);
  
  % Textfelder
  ch = get(axhdl(i),'children');
  for j = 1:length(ch)
    if strcmp(get(ch(j), 'type'), 'text')
      set(ch(j), 'FontName', 'times');
    end
  end
end

% Weißer Hintergrund
set(fighdl,'color','w');

% sgtitle formatieren
if ~isempty(fch)
  txthdl = fch(strcmp(get(fch,'Type'),'subplottext'));
  set(txthdl, 'FontName', 'Times');
end