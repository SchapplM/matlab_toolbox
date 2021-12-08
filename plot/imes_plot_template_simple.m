function f = imes_plot_template_simple(xData, XLabel, yData, YLabel, DataStyle, DataColors, DataName, LegendPos)

% Erstellt nach vorgabe des imes-Template
%
% Die Fuktion gibt das figureObj zurück
%
% xData         Datenreihen für die x-Achse
%               Übergabe entweder als matrix aus Spaltenvektoren oder cell 
%               aus Spaltenvektoren, wenn die Datenreihen unterschiedlich
%               lang sind
%
% XLabel        Label der x-Achse als string
%
% yData         Datenreihen für die y-Achse
%               Übergabe entweder als matrix aus Spaltenvektoren oder cell 
%               aus Spaltenvektoren, wenn die Datenreihen unterschiedlich
%               lang sind
%
% YLabel        Label der y-Achse als string
%
% DataSyle      Stil der Datenreihe
%               Übergabe als array aus strings. Die strings entsprechen der
%               üblichen Matlab-Formatierung, also '-', '--' usw.
%
% DataColors    Farben der Datenreihen
%               Übergabe als cell aus RGB array
%
% DataName      Namen der Datenreihen für die Legende
%               Übergabe als cell array aus strings. Wenn keine Legende
%               erstellt werden soll, muss eine leer cell {} übergeben
%               werden.
%
% LegendPos     Position der Legende im plot
%               Übergabe als nach Matlab-Konvention für LegendPosition()
% 
% Björn Volkmann, bjoern.volkmann@uni-hannover.de
% Institut für mechatronische Systeme, Universität Hannover

% Schriftart und -größe setzen
schrift.art     = 'Times'; %um die Schriftart zu ändern muss der string des Texts in z.B. \texfsf{...} geschrieben werden
schrift.groesse = 11;

% Figuregröße und Offsets für Ränder bzw. Abstand zwischen den Plots setzen
laengen.breite_fig           = 12;
laengen.hoehe_fig            = 8;

laengen.offset_breite_links  = 2;
laengen.offset_breite_rechts = 0.5;
laengen.offset_oben          = 1.5;
laengen.Abstand_plots        = 0.1;
laengen.hoehe_label          = 1.2;
% Figure aufrufen
f = figure(1);
clf(1);

set(f,'DefaultAxesUnit','centimeters')
set(f,'DefaultAxesFontName',schrift.art)
set(f,'DefaultAxesFontSize',schrift.groesse)
set(f,'DefaultAxesTickLabelInterpreter', 'latex')
set(f,'DefaultLegendInterpreter', 'latex')
set(f,'defaultTextInterpreter','latex')
set(f,'DefaultTextFontSize',schrift.groesse)


f.Units             = 'centimeters';
f.OuterPosition  	= [30 5 laengen.breite_fig laengen.hoehe_fig];
f.Color             = [1 1 1];
f.PaperSize         = [laengen.breite_fig laengen.hoehe_fig];
f.PaperPosition     = [0 0 0 0];
f.PaperPositionMode = 'auto';
f.ToolBar           = 'none';
f.MenuBar           = 'none';


%Anzahl der Zeilen
n=1;

%Anzahl labels in x 
m=1;

%Figureposition setzen
laengen.breite_axes    = laengen.breite_fig - (laengen.offset_breite_links+laengen.offset_breite_rechts);
laengen.hoehe_axes     = (laengen.hoehe_fig-laengen.offset_oben-(n-1)*laengen.Abstand_plots-m*laengen.hoehe_label)/n;

positionen(1).pos      = [laengen.offset_breite_links   laengen.hoehe_fig-(laengen.offset_oben + laengen.hoehe_axes)  laengen.breite_axes     laengen.hoehe_axes];

%% Plot 1

achsen.a = axes;
achsen.a.Position   = positionen(1).pos; 


for i = 1:size(yData, 2)
    
    if iscell(xData)
        plot(xData{i}, yData{i}, "LineStyle", DataStyle(i), "LineWidth", 1.5, "Color", DataColors{i})
        hold on
    else
        plot(xData(:,i), yData(:,i), "LineStyle", DataStyle(i), "LineWidth", 1.5, "Color", DataColors{i})
        hold on
    end
    
end
hold off

space = max(yData, [],'all') - min(yData, [],'all');
limits.ymin            = min(yData, [],'all') - space * 0.1;
limits.ymax            = max(yData, [],'all') + space * 0.1;    
limits.xmin            = min(xData, [],'all');
limits.xmax            = max(xData, [],'all');

achsen.a.XLim        = [limits.xmin limits.xmax];
achsen.a.YLim        = [limits.ymin limits.ymax];
achsen.a.XGrid       = 'on';
achsen.a.YGrid       = 'on';

label.y              = ylabel(YLabel);
label.x              = xlabel(XLabel);

if ~isempty(DataName)
legenden.l            = legend(DataName);
legenden.l.Units      = 'centimeters';
legenden.l.Position   = [10.2 1.8 0 0];
legenden.l.Location   = LegendPos;

legenden.l.Box        = 'off';
end


