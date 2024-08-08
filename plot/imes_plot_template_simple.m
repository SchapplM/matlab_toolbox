function f = imes_plot_template_simple(f)

% Diese Funktion nimmt einen Plot f und wended auf diesen die imes
% Formatvorlage an. Dabei werden die Größe des Fensters, die Achsen die
% Legende entsprechend formatiert. Farben und Textinhalt bleiben
% unverändert.
%
% f         Figure Handle
%
% Björn Volkmann, bjoern.volkmann@uni-hannover.de
% Institut für mechatronische Systeme, Universität Hannover

% Schriftart und -größe setzen
schrift.art     = 'Times'; %um die Schriftart zu ändern muss der string des Texts in z.B. \texfsf{...} geschrieben werden
schrift.groesse = 11;

% Figuregröße und Offsets für Ränder bzw. Abstand zwischen den Plots setzen
laengen.breite_fig           = 12;
laengen.hoehe_fig            = 8;

laengen.offset_breite_links  = 1.5;
laengen.offset_breite_rechts = 0.8;
laengen.offset_oben          = 1.5;
laengen.Abstand_plots        = 0.1;
laengen.hoehe_label          = 1.2;

% Figure aufrufen
% set(1, 'CurrentFigure', f)

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

%% Axen

a = findobj(f,'type','axes');
a.Units = 'centimeters';
a.Position   = positionen(1).pos; 

a.XGrid       = 'on';
a.YGrid       = 'on';

l            = findobj(f,'type','legend');
l.Box        = 'off';


