% Umwandlung des Excel-Zellenformates Zeile/Spalte in
% SpaltenBuchstabe/Zeile (R1Z1 -> A1)

% Moritz Schappler, schappler@irt.uni-hannover.de, 2012-08
% (c) Institut für Regelungstechnik, Universität Hannover

function A1_String = xls_R1C12A1(ZeileNr, SpalteNr)
A1_String = sprintf('%s%d', xlscol(SpalteNr), ZeileNr);