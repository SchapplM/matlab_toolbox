% Outputfunction für genetischen Algorithmus
% Speichert Alle Zwischenpopulationen als .mat-Dateien
% 
% Input:
% options,state,flag
%   Standard-Übergabeparameter
% 
% Output:
% state, options,optchanged
%   
% Globale Variablen:
% save_path
%   Zielpfad für gespeicherte mat-Dateien
% filename_prototype
%   String zur Erstellung des Dateinamens. Muss "%d" enthalten (als
%   Generationsnummer)
% ga_generation_index
%   Laufende Nummer der aktuellen Generation (bezogen auf Gesamt-GA).
% ga_individuum_index
%   Laufende Nummer des aktuellen Individuums

% Moritz Schappler, schappler@irt.uni-hannover.de, 2016-01
% (c) Institut für Regelungstechnik, Universität Hannover

function [state, options,optchanged] = ga_output_save_population(options,state,flag)
global save_path
global filename_prototype

global ga_generation_index
global ga_individuum_index

optchanged = false;
switch flag
    case {'init', 'iter','interrupt'}
        save(fullfile(save_path, sprintf(filename_prototype, state.Generation)));
        fprintf('Generation %d: Saved Output\n', state.Generation);
        % Speichern der Generationsnummer für die kommende Generation.
        % Diese Funktion wird nach dem Berechnen einer Generation
        % ausgeführt. state.Generation ist daher die vergangene Gen.
        ga_generation_index = state.Generation+1;
        ga_individuum_index = 1;
    case 'done'
        return
end
