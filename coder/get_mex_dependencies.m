% Suche Aufrufe von mex-Funktionen in einem Matlab-Skript (nicht rekursiv)
% 
% Eingabe:
% mfile_pfad
%   Pfad zu einem Matlab-Skript
% 
% Ausgabe:
% fList [nx1] cell
%   Cell-Array mit Namen von mex-Funktionen, die aufgerufen werden (Keine
%   Unterscheidung zwischen Funktionsnamen und indizierten Variablennamen!)
% error
%   Fehlercode
%   0   i.O.
%   1   Datei nicht gefunden

% Moritz Schappler, schappler@irt.uni-hannover.de, 2016-09
% (c) Institut für Regelungstechnik, Universität Hannover


function [fList, error] = get_mex_dependencies(mfile_pfad)

error = 0;

% Datei öffnen und lesen
% TODO: Prüfe, ob textdatei (nicht binär) und ob nicht zu lang
% TODO: Wenn in mfile_pfad keine Endung enthalten ist, wird die existenz
% trotzdem erkannt und die Datei später falsch geladen.
if exist(mfile_pfad, 'file') ~= 2
  fList = {};
  error = 1;
  return
end
Dateiinhalt = fileread(mfile_pfad);
% TODO: mit ... getrennte Zeilen wieder zusammenfügen

% Suchbegriff erstellen
expression = '([\w\d]+)_mex\(';
[startIndex, endIndex] = regexp(Dateiinhalt,expression, 'start', 'end');
fList = cell(length(startIndex), 1);
for ii = 1:length(startIndex)
  fList{ii} = Dateiinhalt(startIndex(ii):(endIndex(ii)-1));
end
    
end
    
