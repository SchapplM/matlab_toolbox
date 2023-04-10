% Beispiele für die Formatierung eines Plots

% Alexander Tödtheide, toedtheide@irt.uni-hannover.de, 2015-06
% Moritz Schappler, moritz.schappler@imes.uni-hannover.de, 2018-03
% (C) Institut für mechatronische Systeme, Universität Hannover

clc; close all; clear
%% Beispieldaten
t = (0:1e-3:5)';

f1 = 0.5;
f2 = 1.5;
y1 = sin(t*2*pi*f1);
y2 = cos(t*2*pi*f1);
y3 = sin(t*2*pi*f2);
y4 = cos(t*2*pi*f2);


fig_handle = figure(1);clf;
axhdl=NaN(2,2);
axhdl(1,1)=subplot(2,2,1);
plot(t,y1); hold on; plot(t,y2); legend('a','b');
xlabel('Time [s]'); ylabel('Angle [rad]');
xlim([0 5]);
axhdl(1,2)=subplot(2,2,2);
plot(t,y3); hold on; plot(t,y4); legend('c','d'); 
xlabel('Time [s]'); ylabel('Angle [rad]');
xlim([0 5]);
axhdl(2,1)=subplot(2,2,3);
plot(t,y1); hold on; plot(t,y2); legend('e','f');
xlabel('Time [s]'); ylabel('Angle [rad]');
xlim([0 5]);
axhdl(2,2)=subplot(2,2,4);
plot(t,y3); hold on; plot(t,y4); legend('g','h'); 
xlabel('Time [s]'); ylabel('Angle [rad]');
xlim([0 5]);


%% Beispiel-Plot 1

shape = [2,2];  
n_cols = shape(2);
nc_rows = shape(1);

bl = 0.13;          % left border,  [0-1]
br = 0.055;         % right border, [0-1]
hu = 0.05;          % upper border, [0-1]
hd = 0.14;          % lower border, [0-1]
bdx = 0.05;         % gap between plots in x, [0-1]
bdy = 0.05;         % gap between plots in y, [0-1]
fig_width = 8.6;    % figure width in cm
fig_height = 7;     % figure height in cm

remove_inner_labels(axhdl,1);
remove_inner_labels(axhdl,2);
set_size_plot_subplot(fig_handle,fig_width,fig_height,axhdl,bl,br,hu,hd,bdx,bdy);
figure_format_publication(axhdl)

figure_save_path = fullfile(fileparts(which('matlab_tools_path_init.m')), 'examples_tests', 'plot_examples');
mkdirs(figure_save_path);
export_fig(fullfile(figure_save_path, 'example_out_1.pdf'));

%% Beispiel-Plot 2
% Verschiedene Formate für die einzelnen Subplots
format{1} = {'r',  '', '-', 0; ...
             'k', 'd', '-', 8};
format{2} = {'k', 'o', '-', 7; ...
             'c', 's', '-', 12};
format{3} = {'b', 'v', '-', 7; ...
             'k', 's', '--', 12};
format{4} = {'g', 'v', '-', 7; ...
             'k', '^', '--', 9};
Names = {{'a','b'},{'c','d'},{'e','f'},{'g','h'},};
for i = 1:length(axhdl(:))
  axes(axhdl(i)); %#ok<LAXES>
  linhdl = get(axhdl(i), 'Children');
  leghdl = line_format_publication(linhdl, format{i}, Names{i});
  legend(leghdl, Names{i});
end
export_fig(fig_handle, fullfile(figure_save_path, 'example_out_2_expfig.pdf'));
exportgraphics(fig_handle, fullfile(figure_save_path, 'example_out_2_expgraph.pdf'),...
  'ContentType','vector');
exportgraphics(fig_handle, fullfile(figure_save_path, 'example_out_2_r300.png'), 'Resolution', 300);