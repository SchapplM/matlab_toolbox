% Starte eine Simulink-Simulation und führe sie bei einem Fehler nochmal
% bis zum Auftreten des Fehlers aus
% Eingabe: Argumente der Matlab-Funktion "sim"
% Diese Funktion wird anstelle von "sim" benutzt, falls ein Abbruch der
% Simulation nicht zum Abbruch des aufrufenden Skriptes führen soll.

% Moritz Schappler, schappler@irt.uni-hannover.de, 2016-07
% (c) Institut für Regelungstechnik, Universität Hannover

function SimOut = sim_repeatonerror(varargin)

try
  SimOut = sim(varargin{:});
  return;
catch err
  % Hole Zeitpunkt der Singularität aus Fehlermeldung
  tmp=regexp(err.message, 'time ([\d.])+ is', 'match');
  if isempty(tmp)
    % Keine Zeit in Fehlermeldung enthalten. Wiederholung sinnlos, da
    % Fehler wahrscheinlich nicht durch Singularität bedingt.
    throw(err);
  end
  warning(err.message);
  configSet = getActiveConfigSet(varargin{1});
  T_str=get_param(configSet, 'FixedStep');
  T = str2double(T_str);
  if isnan(T) % Die Abtastzeit ist eine Variable
    % Lese Variable aus dem Basis-Workspace
    T = evalin('base',T_str);
  end
  t_End_tmp = str2double(tmp{1}(6:end-3)) - T; % Schneide Zahl aus "time ... is"
  
  % Ändere den Endzeitpunkt oder füge ihn hinzu
  endzeit_akt = false;
  for i = 1:length(varargin)
    % Prüfe, ob die Simulationszeit ein Argument ist
    if strcmp(varargin{i}, 'StopTime')
      varargin{i+1} = sprintf('%e', t_End_tmp);
      break;
    end
  end
  if ~endzeit_akt
    varargin = {varargin{:}, 'StopTime', sprintf('%e', t_End_tmp)};
  end
  
  % Wiederhole die Simulation bis kurz davor
  SimOut = sim(varargin{:});
  return;
end