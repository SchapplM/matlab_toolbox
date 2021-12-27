% Beispiel für FFT-Filterung eines geplotteten Signals

% Anleitung:
% Zoomen in oberem Fenster und Verschieben des Bereichs aktualisiert das
% FFT-Diagramm

% Alexander Tödtheide, toedtheide@irt.uni-hannover.de, 2015-06
% Moritz Schappler, moritz.schappler@imes.uni-hannover.de, 2018-03
% (C) Institut für mechatronische Systeme, Universität Hannover

clear; close all; clc
if isempty(which('hamming'))
  warning('Signal Processing Toolbox nicht installiert. Test nicht durchführbar');
  return
end
%% Generate data

t_smpl = 1e-3;
t = 0:t_smpl:10;
y1 = sin(2*pi*5*t);
y2 = sin(2*pi*100*t);

I = (t>4 & t<7)';
y3 = sin(2*pi*200*t(I));

y = y1+y2; % Grundsignal
y(I) = y(I)+y3; % zusätzliche kurzzeitige Störung 

%% Plot vorbereiten
figure(1);clf;
axhdl = NaN(2,1);
axhdl(1) = subplot(2,1,1);hold on;
linhdl = NaN(1,1);
linhdl(1,1) = plot(t, y);
grid on;

axhdl(2) = subplot(2,1,2);hold on;
grid on;

%% FFT hinzufügen
plot_fft(axhdl(1), axhdl(2), linhdl);
