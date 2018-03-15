% Mittelwert aus Strukturen von zeitbasierten Daten bilden
% 
% Eingabe:
% GesStruct
%   Struktur mit Unter-Strukturen für alle Zeitstrukturen, aus denen der
%   Mittelwert gebildet werden soll
%   Bsp.:
%     GesStruct.tmp1 (Felder: t, data1, data2)
%     GesStruct.tmp2 (Felder: t, data1, data2)
%     ...
%   Es muss ein Feld 't' für die Zeit vorliegen.
%   Die Zeitdaten der Eingangsdaten sollten die gleiche Abtastrate haben,
%   müssen aber nicht identisch sein. Es wird für alle Signale die
%   vorliegen der Mittelwert gebildet.
% 
% Ausgabe:
% ResStruct
%   Struktur mit dem Mittelwert aller Felder in der Eingabestruktur zum
%   gleichen Zeitpunkt

% Moritz Schappler, schappler@irt.uni-hannover.de, 2017-03
% (c) Institut für Regelungstechnik, Universität Hannover

function ResStruct = timestruct_mean(GesStruct)

t_ges = []; % Zeitschritte in der Ergebnisstruktur
enable_debug = false;

%% Zeitbasis und Dimensionen der Felder bestimmen
% Bestimme, zu welchem Zeitpunkt wie viele Daten vorliegen
% Alle Teilstrukturen durchgehen
i = 0;
for fn = fieldnames(GesStruct)'
  i = i + 1;
  % Zeitbasis der Teilstruktur
  t_i = GesStruct.(fn{1}).t;
  if i == 1 % Erste Teilstruktur: Felder erstellen
    t_ges = t_i;
    ResStructDim = GesStruct.(fn{1});
    % Speichere für jedes Feld aller Teilstrukturen die Dimension ab (prüfe
    % daraus später, wie die Dimension der Daten unabhängig von der Zeit ist)
    for fn3 = fieldnames(ResStructDim)'
      [d1, d2, d3] = size(ResStructDim.(fn3{1}));
      ResStructDim.(fn3{1}) = [d1 d2 d3];
    end
    continue
  end
  % Nicht die erste Teilstruktur, Dimensionen aller Felder anhängen
  for fn3 = fieldnames(GesStruct.(fn{1}))'
    [d1, d2, d3] = size(GesStruct.(fn{1}).(fn3{1}));
    ResStructDim.(fn3{1}) = [ResStructDim.(fn3{1}); [d1 d2 d3]];
  end
  % Gesamt-Zeitbasis bilden
  t_ges = unique([t_i; t_ges]);
end

% Anzahl der verfügbaren Daten für jeden Zeitpunkt: Enthält eine 1, wenn
% nur ein Datenpunkt aus einer Teilstuktur vorliegt.
n_t_ges = zeros(length(t_ges),1); 

% Anzahl der verfügbaren Daten zu jedem Zeitpunkt zählen
Iges = zeros(length(t_ges), length(fieldnames(GesStruct))); % Merke, welcher Zeitpunkt in den einzelnen Datensätzen der Gesamtzeit zugeordnet ist
i = 0;
for fn = fieldnames(GesStruct)'
  i = i + 1;
  t_i = GesStruct.(fn{1}).t;
  for it = 1:length(t_i)
    II = t_i(it) == t_ges;
    I = find(II); % Indes dieses Zeitpunktes der lokalen Daten in t_ges
    Iges(I,i) = it; % Zeile: Zeit-Index in Gesamtstruktur, Spalte: Nummer der Teilstruktur, Wert: Zeit-Index in Teilstruktur
    n_t_ges(I) = n_t_ges(I) + 1;
  end
end
if enable_debug
  save('debug_timestruct_mean_1.mat');
end

%% Erstelle Rückgabestruktur
ResStruct = struct('t', t_ges); % Ausgabestruktur initialisieren
for fn2 = fieldnames(ResStructDim)'
  if strcmp(fn2{1}, 't')
    continue; 
  end
  % Bestimme Dimension
  Dtmp = ResStructDim.(fn2{1});
  if all(Dtmp(:,3) == 1)
    % Gestapelte Vektoren (oder Skalare)
    D2tmp = unique(Dtmp(:,2));
    if length(D2tmp) > 1
      error('Feld %s hat keine einheitliche Dimension', fn2{1});
    end
    ResStruct.(fn2{1}) = zeros(length(t_ges), D2tmp);
  else
    % Gestapelte Matrizen
    D1tmp = unique(Dtmp(:,1));
    D2tmp = unique(Dtmp(:,2));
    if length(D1tmp) > 1 || length(D2tmp) > 1
      error('Feld %s hat keine einheitliche Dimension', fn2{1});
    end
    ResStruct.(fn2{1}) = zeros(D1tmp, D2tmp, length(t_ges));
  end
end

%% Bilde den Mittelwert der Daten
% Gehe alle Felder in der Ergebnis-Struktur durch
for fn2 = fieldnames(ResStruct)'
  if strcmp(fn2{1}, 't')
    continue; 
  end
  
  % Eintrag für die Zeit nicht betrachten
  if strcmp(fn2{1}, 't'), continue; end
  [d1, d2, d3] = size(ResStruct.(fn2{1}));
  tmp_res = ResStruct.(fn2{1}); % Arbeitsvariable für aktuelles Feld

  i = 0;
  % Alle Teil-Strukturen durchgehen
  for fn = fieldnames(GesStruct)'
    i = i+1;
    % Aktuelles Feld in der Teilstruktur
    tmp2 = GesStruct.(fn{1}).(fn2{1});
    % Indizes für die aktuelle Teilstruktur
    II_t = Iges(Iges(:,i)~=0,i); % In der Teilstruktur
    II_g = find(Iges(:,i)~=0); % In den Gesamtdaten
    if d3 == 1 % Gestapelte Vektoren (oder Skalare)
      % Addiere gewichtete Daten aus der aktuellen Teilstruktur zur
      % Gesamtstruktur
      tmp_res(II_g,:) = tmp_res(II_g,:) + repmat(1./n_t_ges(II_g),1,d2) .* tmp2(II_t,:);
    else % Gestapelte Matrizen
      tmp2r = reshape(tmp2, size(tmp2,3), d1*d2);
      tmp_add = repmat(1./n_t_ges(II_g),1,d1*d2) .* tmp2r(II_t,:);
      tmp_add3 = reshape(tmp_add, d1, d2, size(tmp2,3));
      tmp_res(:,:,II_g) = tmp_res(:,:,II_g) + tmp_add3;
    end
  end
  % Ergebnis mit Mittelwert aller verfügbarer Daten wieder
  % zurück in Ausgabestruktur schreiben
  ResStruct.(fn2{1}) = tmp_res;
end

if enable_debug
  save('debug_timestruct_mean_2.mat');
end
