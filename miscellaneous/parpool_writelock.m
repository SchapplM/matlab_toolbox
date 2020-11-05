% Set or unset the writing protection of the Matlab parpool
% This prevents parallel instances of Matlab to start a parallel pool at
% the same time. This may produce a file conflict in the Matlab preferences
% directory (e.g. ~/.matlab/R2020a), where the parpool data is stored.
% 
% This should be implemented as a bracket around the parpool command:
%   parpool_writelock('lock');
%   parpool();
%   parpool_writelock('free');
% The same goes for closing the pool:
%   parpool_writelock('lock');
%   delete(gcp('nocreate'));
%   parpool_writelock('free');
% 
% Input:
% mode: 'free', 'lock'
% patience
%   Duration until the writing protection is getting ignored and the
%   parpool is started anyway. This may be beneficial, if the locking
%   process has crashed. This relates to the time of the last lock.
% verbosity: true gives text output for debugging
% 
% See also:
% https://mathworks.com/matlabcentral/answers/539059-not-able-to-start-parpool-in-multiple-different-matlab-instances-simultaneously-in-a-single-machine

% Moritz Schappler, moritz.schappler@imes.uni-hannover.de, 2020-11
% (C) Institut fuer Mechatronische Systeme, Leibniz Universitaet Hannover

function parpool_writelock(mode, patience, verbosity)

if nargin < 2
  patience = inf; % Wait infinite time for the ressource to become free (bad in case of previous crash)
else
  % Always add up to 20% time on the waiting time. If multiple instances
  % start in parallel, all parallel instances will otherwise wait the exact
  % amount of time and give up waiting at the same time. Therefore random.
  patience = patience + 0.2*patience*rand(1,1);
end
if nargin < 3
  verbosity = false;
end
%% Initialisation
lockfile = fullfile(prefdir(),'matlab_parpool.lock');
%% Release the lock
if strcmp(mode, 'free')
  if verbosity
    fprintf('ParPool is free (again).\n');
  end
  delete(lockfile);
  return
end
%% Check lock
t_start = tic();
while true
  fid=fopen(lockfile, 'r');
  if fid == -1
    break; % lock file does not exist. ParPool is free
  end
  % Read when the lock has been set at last
  try
    l = textscan(fid, '%d-%d-%d %d:%d:%d');
    locktime = datenum(sprintf('%04d-%02d-%02d %02d:%02d:%02d',...
      l{1},l{2},l{3},l{4},l{5},l{6}));
  catch
    % Error: Cause is either unexpected content or vanishing of the
    % previously existing lockfile
    warning('Error reading the lockfile %s', lockfile);
    locktime = now()+1; % This will increase waiting
  end
  fclose(fid);
  % Lock file exists. Wait until lock time is over
  if (now()-locktime)*24*3600 > patience
    if verbosity
      fprintf(['Waiting on the ParPool for %1.1fs. ', ...
        'Ignore the lockfile with timestamp %s.\n'], ...
        toc(t_start), datestr(locktime,'yyyy-mm-dd HH:MM:SS'));
    end
    break;
  elseif verbosity
    fprintf(['ParPool is locked (timestamp %s). Wait until it becomes ', ...
      'free.\n'], datestr(locktime,'yyyy-mm-dd HH:MM:SS'));
  end
   % Waiting time until next check. Make random to prevent parallel
   % instances doing the same thing at the exact same time.
  pause(2+10*rand(1,1));
end

%% Create new Lockfile
% Let's hope that in the meantime no other parallel process did the same
% thing. This is not a clean synchronisation yet.
fid = fopen(lockfile, 'w');
if fid == -1
  warning('Was not able to write lockfile %s.', lockfile);
  return
end
locktime = datestr(now,'yyyy-mm-dd HH:MM:SS');
fprintf(fid, '%s', locktime);
fclose(fid);
if verbosity
  fprintf('ParPool was locked (timestamp %s).\n', locktime);
end