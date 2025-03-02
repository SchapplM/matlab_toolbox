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
% xthresh, ythresh
%   Thresholds for removing markers.
%   For logarithmic axes the threshold should be >1 as the ratio and not
%   the difference of two values is considered for reduction
% logscales [2x1]
%   true, if the x or y axis is scaled logarithmically
% 
% Output:
% I [N x 1 logical]
%   Binary index for values that exceed the distance to the previously chosen

% Moritz Schappler, moritz.schappler@imes.uni-hannover.de, 2022-02
% (C) Institut für Mechatronische Systeme, Leibniz Universität Hannover

function I = select_plot_indices_downsample_nonuniform(x, y, xthresh, ...
  ythresh, logscales)
if nargin < 5
  logscales = false(2,1);
end
if size(x,2) == 1 % time plot
  I = false(length(x),1);
  last_x = inf;
  last_y = inf(1,size(y,2));
  for kk = 1:size(y,1)-1
    if ~logscales(1), I_x_exc = abs(x(kk)-last_x) > xthresh;
    else,             I_x_exc = isinf(last_x) || abs(x(kk)/last_x) > xthresh;
    end
    if ~logscales(2), I_y_exc = any(abs(y(kk,:)-last_y)>ythresh);
    else,             I_y_exc = isinf(last_y) || any(abs(y(kk,:)/last_y)>ythresh);
    end
    if I_x_exc || I_y_exc... % x or y threshold exceeded
      % Change in data is high enough. Plot next point.
      I(kk) = true;
      last_x = x(kk);
      last_y = y(kk,:);
    end
  end
  I(end) = true; % always keep last value to not cut the line length
elseif size(x,2) == 2 % xy plot
  % for all data points check distance to next point
  I = true(size(x,1),1); % start with all markers active
  % Sort all markers according to both dimensions
  [~, I_sortx] = sort(x(:,1));
  [~, I_sorty] = sort(x(:,2));
  % Loop over different search directions
  for jdim = 1:4
    switch jdim
      case 1 % go right
        Isort = I_sortx;
      case 2 % go left
        Isort = flipud(I_sortx);
      case 3 % go up
        Isort = I_sorty;
      case 4 % go down
        Isort = flipud(I_sorty);
    end
    for kk = Isort(I)'
      if ~I(kk), continue; end % marker already disabled. Skip.
      % Select all markers in a specific search direction. Look in
      % direction that is not the processing direction to avoid deleting
      % the markers one after the other
      switch jdim
        case 1 % look left-down
          I_prev = x(:,1) <= x(kk,1) & x(:,2) <= x(kk,2);
        case 2 % look right up
          I_prev = x(:,1) >= x(kk,1) & x(:,2) >= x(kk,2);
        case 3 % look right down
          I_prev = x(:,1) >= x(kk,1) & x(:,2) <= x(kk,2);
        case 4 % look left up
          I_prev = x(:,1) <= x(kk,1) & x(:,2) >= x(kk,2);
      end
      if ~any(I_prev)
        I(kk) = false; % disable current marker
        continue
      end
      % Distance of all existing markers relative in search direction. If this
      % one is within the threshold distance to an existing one, delete it.
      I_check = I & I_prev;
      % Index for current point kk (to exclude from distance measurement)
      I_check(kk) = false;
      I_in_thr = abs(x(I_check,1)-x(kk,1))<xthresh & ...
                 abs(x(I_check,2)-x(kk,2))<ythresh;
      if any(I_in_thr)
        I(kk) = false; % disable current marker
      else
        % marker is set as enabled. Disable all other markers around this
        I_all_in_thr = abs(x(:,1)-x(kk,1))<xthresh & ...
                       abs(x(:,2)-x(kk,2))<ythresh;
        I_all_in_thr(kk) = false; % not this one
        I(I_all_in_thr) = false;
      end
    end
  end
else
  error('Case not implemented yet');
end
assert(any(I), 'No plot marker was selected. Logic error');
