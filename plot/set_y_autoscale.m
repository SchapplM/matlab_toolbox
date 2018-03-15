% Set axis limits according to minimal and maximal values of the data
% use current x range and not all available data
% 
% Input:
% obj_handle
%   handle to figure or axis
% scale
%   scaling factor to extend the axis limits. relative to the distance
%   between maximum and minimum values
%   [1x1]: Same limit on both sides
%   [2x1]: Limit for lower and upper side
% enable_round [optional]
%   swich for enabling rounding on the first digit after decimal point

% Alexander Tödtheide toedtheide@irt.uni-hannover.de, 2015-06
% (C) Institut für Regelungstechnik, Leibniz Universität Hannover

function set_YAutoscale(obj_handle, scale, enable_round)


if strcmp(get(obj_handle, 'type'), 'figure')
  % apply yautoscale to all axes elements
  ha1 = findobj(obj_handle,'Type','axes');
elseif strcmp(get(obj_handle, 'type'), 'axes')
  ha1 = obj_handle(:);
else
  warning('given handle is neither figure, nor axes.');
  return;
end
for i = 1:length(ha1)
     
    % line_handles = get(gca,'children')
    Lines = get(ha1(i),'children');
    y_min_values = NaN(length(Lines), 1);
    y_max_values = NaN(length(Lines), 1);
    % get
    for j = 1:length(Lines)
        xdata = get(Lines(j),'xdata');
        ydata = get(Lines(j),'ydata');
      
        % only take ydata into account, that lies within the current xdata
        % range
        I = true(1, length(xdata)); % indizes of data to take into account
        xlimits = get(ha1(i), 'xlim');
        I = I & (xdata > xlimits(1)); 
        I = I & (xdata < xlimits(2));
        
        % do not take NaN data (wherever this may come from
        I = I & (~isnan(ydata));

        % get minmax values
        if any(I)
          y_max_values(j) = max(ydata(I) );
          y_min_values(j) = min(ydata(I) );
        end
    end
    
    diff_max_min = max(y_max_values) - min(y_min_values);
    if length(scale) == 1
      y_max = max(y_max_values)+abs(diff_max_min)*scale;
      y_min = min(y_min_values)-abs(diff_max_min)*scale;
    elseif length(scale) == 2
      y_max = max(y_max_values)+abs(diff_max_min)*scale(2);
      y_min = min(y_min_values)-abs(diff_max_min)*scale(1);
    else
      error('Nicht definiert');
    end
    % round for first digit after comma
    if nargin < 3 || enable_round
      y_max=round(y_max.*10)/10;
      y_min=round(y_min.*10)/10;
    end
    set(ha1(i),'Ylim',[y_min y_max]);
end

end