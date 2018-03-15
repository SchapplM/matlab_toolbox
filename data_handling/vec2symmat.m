% Konvertiere einen Vektor in eine symmetrische Matrix
% 
% Eingabe:
% M_vec: [N*(N+1)/2 x 1]
%   Vektor mit unterem linken Teil einer symmetrischen Matrix (Zeilenweise)
% A [1x1 logical]
%   true für antisymmetrische Matrix (Standard: false)
% 
% Ausgabe:
% M_symmat [N x N]
%   Symmetrische Matrix

% Quelle:
% http://de.mathworks.com/matlabcentral/newsreader/view_thread/169455

% Moritz Schappler, schappler@irt.uni-hannover.de, 2016-03
% (c) Institut für Regelungstechnik, Universität Hannover

function M_symmat = vec2symmat(M_vec, A)

% Dimension der (quadratischen) Matrix festlegen
N = floor(sqrt(2*length(M_vec)));

if nargin < 2
  A = false;
end

M_symmat = NaN(N,N);
for i = 1:N
  for j = 1:N
    if j > i
      % tausche Zeilen und Spaltenindex (oberer rechter Teil)
      k = j*(j-1)/2 + i;
    else
      k = i*(i-1)/2 + j;
    end
    M_symmat(i,j) = M_vec(k);
    % Vertausche das Vorzeichen des oberen rechten Teils
    if A && j > i
      M_symmat(i,j) = -M_symmat(i,j);
    end
  end
end