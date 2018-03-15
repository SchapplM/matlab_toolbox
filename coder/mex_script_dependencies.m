% Kompiliere alle mex-Abhängigkeiten eines Skriptes
% Durchsucht ein Skript nach aufgerufenen mex-Funktionen und prüft, ob
% diese (neu) kompiliert werden müssen.
% Die Prüfung erfolgt bei Bedarf nur einmal pro Matlab-Sitzung
% 
% Eingabe:
% script_filepath [char]
%   Pfad zum aufrufenden Skript (voller absoluter Pfad mit Dateiendung)
% check_everytime [1x1 logical]
%   Falls true, werden die Abhängigkeiten jedes Mal geprüft.
% false [1x1] logical
%   Neukompilieren erzwingen (auch ohne erkannte Änderungen)
% 
% Beispielaufruf:
%   mex_script_dependencies(mfilename('fullpath'), false)
% 
% Siehe auch: matlabfcn2mex

% Moritz Schappler, schappler@irt.uni-hannover.de, 2016-09
% (c) Institut für Regelungstechnik, Universität Hannover

function mex_script_dependencies(script_filepath, check_everytime, force)

%% Init
% Liste mit Skripten, für die die Funktion ausgeführt wurde.
persistent exec_script_list % kann nur mit `clear all` zurückgesetzt werden.

% Funktioniert nur, wenn Name des Skriptes bekannt ist
if isempty(script_filepath)
  return
end
% Hänge Dateiendung an, falls notwendig. Wenn die Dateiendung aus
% irgendeinem Grund leer ist, treten später Fehler auf, da die Existenz
% nicht korrekt geprüft wird.
[~,~,e] = fileparts(script_filepath);
if strcmp(e, '')
  script_filepath = [script_filepath, '.m'];
end

if exist(script_filepath, 'file') ~= 2
  error('mex_script_dependencies: Datei existiert nicht: %s', script_filepath);
end
if nargin < 2
  check_everytime = false;
end
if nargin < 3
  force = false;
end
%% Prüfen, ob Aufruf notwendig
firstexec_forscript = true;
% Prüfe, ob die Funktion bereits für dieses Skript ausgeführt wurde
for i = 1:length(exec_script_list)
  if strcmp(script_filepath, exec_script_list{i})
    % Die Funktion wurde für dieses Skript bereits ausgeführt
    firstexec_forscript = false;
  end
end

if isempty(exec_script_list)
  % Erster Aufruf
  exec_script_list = {script_filepath};
elseif firstexec_forscript
  % Nehme Skript in die Liste auf
  exec_script_list = {exec_script_list{:}, script_filepath}; %#ok<CCAT>
end

if ~firstexec_forscript && ~check_everytime && ~force
  fprintf('mex_script_dependencies: Abhängigkeiten für %s wurden bereits geprüft.\n', script_filepath);
  return
end

%% Kompilieren
% Abhängigkeiten dieses Skriptes suchen (findet nur Funktionen, die auch
% vorhanden sind. Nicht Aufrufe zu nicht existenten Funktionen)
try
  fList = matlab.codetools.requiredFilesAndProducts( script_filepath );
catch
  % Bei zu langen Funktionen kann die Suche nach Abhängigkeiten
  % versagen (Fehler in Matlab 2015a)
  fList = {script_filepath};
end
% Das Skript selbst nicht anhängen (ist bereits drin);

mex_list = {};
% Prüfe ob Abhängigkeit eine Mex-Funktion ist
for i = 1:length(fList)
  [~, fname] = fileparts(fList{i});
  
  if length(fname) > 4 && strcmp(fname(end-3:end), '_mex')
    % Diese Abhängigkeit anhängen, da es selbst eine mex-Funktion ist
    % mex-Funktionen aus `matlabfcn2mex` enden immer auf `_mex`
    mex_list = {mex_list{:}, fname(1:(end-4))}; %#ok<CCAT>
  else
    % mex-Abhängigkeiten in dieser Funktion/Skript suchen (auch nicht existente
    % Funktionen finden)
    mex_list_tmp = get_mex_dependencies(fList{i});
    if isempty(mex_list_tmp)
      continue
    end

    % Entferne die Endung _mex aus dem Namen (s.o.)
    for jj = 1:length(mex_list_tmp)
      mf_jj = mex_list_tmp{jj};
      mex_list_tmp{jj} = mf_jj(1:(end-4)); 
    end
    % Duplikate entfernen und an Gesamt-mex-Liste anhängen
    mex_list = unique({mex_list{:}, mex_list_tmp{:}}); %#ok<CCAT>
  end
end

fprintf('mex_script_dependencies: Skript %s hat %d mex-Abhängigkeiten.\n', ...
  script_filepath, length(mex_list));

% Kompilieren
if ~isempty(mex_list)
  matlabfcn2mex(mex_list, false, true, force);
end
