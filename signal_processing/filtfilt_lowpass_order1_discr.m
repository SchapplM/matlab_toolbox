% Filterung von Eingangsdaten mit einem Tiefpassfilter 1. Ordnung mit filtfilt
% 
% Eingabe:
% Y [nt x ns]
%   Zeitreihe von ns Signalen mit nt Zeitschritten
% f [1x1]
%   Frequenz [Hz] des Tiefpassfilters
% Ts [1x1]
%   Abtastrate der Eingangssignale
% 
% Ausgabe:
% Y_filt [nt x ns]
%   Gefiltertes Eingangssignal

% Alexander Tödtheide, toedtheide@irt.uni-hannover.de, 2016-04
% Moritz Schappler, schappler@irt.uni-hannover.de, 2017-03
% (c) Institut für Regelungstechnik, Universität Hannover

function Y_filt = filtfilt_lowpass_order1_discr(Y, f, Ts)

Y_filt = Y;
if isinf(f)
  % Keine Filterung (Frequenz unendlich)
  return
end
% Tiefpassfilter zeitkontinuierlich
omega = f * 2 * pi; 
constants = tf(omega,[1 omega]);
% Umwandlung Zeitdiskret
constants_z=c2d(constants,Ts);
% Filterung mit filtfilt
[num_z,den_z]=tfdata(constants_z);
b_filt = num_z{1};
d_filt = den_z{1};
for jj = 1:size(Y,2)
  Y_filt(:,jj) = filtfilt(b_filt,d_filt,Y(:,jj));
end