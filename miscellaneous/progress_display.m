% Progress bar with optional time to completion calculation for use in for
% loops. Use like this:
% h=[];
% for <index>=<index_range>
%   h=progress_display(<index_range>,<index>,gui,show_ttc,h[,text]);
%   <loop-code>...
% end
%
% Input:
% index_range [1xn double]
%   Same array that index are taken from (s.o.)
% index [1x1 double]
%   loop index variable
% gui [1x1 bool]
%   true if gui progressbar should be used, false for terminal output
% show_ttc [1x1 bool]
%   true if time to completion shall be displayed
% 
% Output:
% h [struct]
%   struct containing data and handles needed to calculate progress and time to
%   completion

% Jonathan Vorndamme, vorndamme@irt.uni-hannover.de, 2017-10
% (c) Institut für Regelungstechnik, Leibniz Universität Hannover

function h = progress_display(index_range, index, gui, show_ttc, h, text)
  tmp = fix(100*find(abs(index_range-index) == min(abs(index_range-index))) / length(index_range))/100;
  if nargin == 5
    text = 'Please wait...';
  end
  if isempty(h)
    h.last_step = tmp;
    if gui
      h.h = waitbar(tmp,'','Name',text);
      if show_ttc
        waitbar(tmp,h.h,sprintf([num2str(tmp*100) '%% [time required xs]']))
      else
        waitbar(tmp,h.h,[num2str(tmp*100) '%'])
      end
    else
      if show_ttc
        h.tmp = sprintf('%s%.0f%%. [time required xs] (type ctrl-C to stop)\n', text, tmp*100);
      else
        h.tmp = sprintf('%s%.0f%%. (type ctrl-C to stop)\n', text, tmp*100);
      end
      fprintf('%s',h.tmp);
    end
    if show_ttc
      h.t1 = tic;
    end
  end
  if tmp>h.last_step
    h.last_step = tmp;
    if gui
      if show_ttc
        waitbar(tmp,h.h,sprintf([num2str(tmp*100) '%% [time required %ds]'], fix(toc(h.t1)*(1-tmp)/tmp)))
      else
        waitbar(tmp,h.h,[num2str(tmp*100) '%'])
      end
      if tmp == 1
        try
          close(h.h)
        end
      end
    else
      if show_ttc
        fprintf('%s',char(sign(h.tmp)*8))
        h.tmp = sprintf('%s%.0f%%. [time required %ds] (type ctrl-C to stop)\n', text, tmp*100, fix(toc(h.t1)*(1-tmp)/tmp));
        fprintf('%s',h.tmp);
      else
        fprintf('%s',char(sign(h.tmp)*8))
        h.tmp = sprintf('%s%.0f%%. (type ctrl-C to stop)\n', text, tmp*100);
        fprintf('%s',h.tmp);
      end
    end
  end
end