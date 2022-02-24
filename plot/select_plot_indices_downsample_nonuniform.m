% Downsample data for plotting by selecting indices in the data
% Select a new datapoint if a threshold relative to the last selected is exceeded
% Used for x-y data like time series
% Can be used to reduce the filesize of vector graphics exported from Matlab
% 
% Input:
% x [N x 1]
%   reference coordinate (e.g. time)
% y [N x M]
%   signal values
% 
% Output:
% I [N x 1 logical]
%   Binary index for values that exceed the distance to the previously chosen

% Moritz Schappler, moritz.schappler@imes.uni-hannover.de, 2022-02
% (C) Institut für Mechatronische Systeme, Leibniz Universität Hannover

function I = select_plot_indices_downsample_nonuniform(x, y, xthres, ythresh)

I = false(length(x),1);
last_x = inf;
last_y = inf(1,size(y,2));
for kk = 1:size(y,1)-1
  if abs(x(kk)-last_x) > xthres || ... % x threshold exceeded
      any(abs(y(kk,:)-last_y)>ythresh) % any of the y thresholds exceeded
    % Change in data is high enough. Plot next point.
    I(kk) = true;
    last_x = x(kk);
    last_y = y(kk,:);
  end
end
I(end) = true; % always keep last value to not cut the line length