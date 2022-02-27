% Downsample data for plotting by selecting indices in the data
% Select a new datapoint if a threshold relative to the last selected is exceeded
% Used for x-y data like time series
% Can be used to reduce the filesize of vector graphics exported from Matlab
% 
% Input:
% x [N x 1] or [N x 2]
%   case 1: one reference coordinate (e.g. time)
%   case 2: two reference coordinates (xy plot)
% y [N x M]
%   signal values
% 
% Output:
% I [N x 1 logical]
%   Binary index for values that exceed the distance to the previously chosen

% Moritz Schappler, moritz.schappler@imes.uni-hannover.de, 2022-02
% (C) Institut für Mechatronische Systeme, Leibniz Universität Hannover

function I = select_plot_indices_downsample_nonuniform(x, y, xthresh, ythresh)

if size(x,2) == 1 % time plot
  I = false(length(x),1);
  last_x = inf;
  last_y = inf(1,size(y,2));
  for kk = 1:size(y,1)-1
    if abs(x(kk)-last_x) > xthresh || ... % x threshold exceeded
        any(abs(y(kk,:)-last_y)>ythresh) % any of the y thresholds exceeded
      % Change in data is high enough. Plot next point.
      I(kk) = true;
      last_x = x(kk);
      last_y = y(kk,:);
    end
  end
  I(end) = true; % always keep last value to not cut the line length
elseif size(x,2) == 2 % xy plot
  % for all data points check distance to next point to the left and down
  I = true(length(x),1); % start with all markers active
  % Sort all markers to start from the bottom left and go top right by mean
  % of distance to that corner (weighted by the thresholds)
  [~, I_sortx] = sort( ((x(:,1)-min(x(:,1)))/xthresh).^2 + ...
                       ((x(:,2)-min(x(:,2)))/ythresh).^2);
  for kk = I_sortx'
    % Index for current point kk (to exclude from distance measurement)
    I_self = false(length(x),1); I_self(kk) = true;
    % Select all left and downward markers
    I_left = x(:,1) <= x(kk,1);
    I_down = x(:,2) <= x(kk,2);
    % Distance of all existing markers left and down to this one. If this
    % one is within the threshold distance to an existing one, delete it.
    I_check = I & I_left & I_down & ~I_self;
    I_in_thr = abs(x(I_check,1)-x(kk,1))<xthresh & ...
               abs(x(I_check,2)-x(kk,2))<ythresh;
    if any(I_in_thr)
      I(kk) = false; % disable current marker
    end
  end
else
  error('Case not implemented yet');
end
assert(any(I), 'No plot marker was selected. Logic error');