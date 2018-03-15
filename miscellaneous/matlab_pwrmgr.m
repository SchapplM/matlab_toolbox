% Power Management with Matlab
% Use this to send the computer to stand-by or hibernation mode after a
% calculation
% 
% In Linux, the user has to be added to sudoers file to have the permission
% to perform hibernate or shutdown from terminal
%   http://wiki.ubuntuusers.de/sudo/Konfiguration
% 
% Input:
% mode
%   'hibernate', 'shutdown'
% 
% TODO: Add Timer for Shutdown so the user can cancel it


% Moritz Schappler, schappler@irt.uni-hannover.de, 2014-09
% (c) Institut für Regelungstechnik, Universität Hannover

function matlab_pwrmgr(mode)

%% Determine Operating System
WINDOWS = 1;
LINUX = 2;
OS = 0;

if ~isempty(strfind(computer, 'GLNX'))
  OS = LINUX;
elseif ~isempty(strfind(computer, 'WIN'))
  OS = WINDOWS;
else
  error('could not determine the operating system');
end


%% Execute Power Management command
if strcmp(mode, 'hibernate')
  if OS == LINUX
    system('sudo pm-hibernate now');
  elseif OS == WINDOWS
    system('shutdown -h')
  end
elseif strcmp(mode, 'shutdown')  
  if OS == LINUX
    system('sudo shutdown now');
  elseif OS == WINDOWS
    system('shutdown -s')
  end
else
  error('Mode %s not implemented.', mode);
end
