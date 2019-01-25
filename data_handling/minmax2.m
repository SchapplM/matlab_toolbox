% Gebe Minimal- und Maximalwerte eines Vektors zurück
% Gleiches Verhalten wie Funktion minmax aus der Deep Learning Toolbox.
% Hier Benennung mit "minmax2", damit Matlab-eigene Funktion noch aufrufbar
% 
% Eingabe:
% V [Nx1] Vektor oder NxM Matrix
% 
% Ausgabe:
% mm [Nx2]
%   Zeilenweise Minimum und Maximum der Matrix oder des Vektors
%   Für Min/Max von Vektoren sollte der Vektor als 1xM übergeben werden.

% Test-Code:
% A=rand(5,3);
% amm = minmax(A)
% Amm2 = minmax2(A)
% v = rand(10,1);
% vmm = minmax(v)
% vmm2 = minmax2(v)
% vT = v';
% vTmm = minmax(vT)
% vTmm2 = minmax2(vT)

% Moritz Schappler, moritz.schappler@imes.uni-hannover.de, 2019-01
% (C) Institut für Mechatronische Systeme, Universität Hannover

function mm = minmax2(v)

vmin = min(v,[],2);
vmax = max(v,[],2);
mm = [vmin, vmax];