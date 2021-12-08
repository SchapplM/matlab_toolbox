function set_color_order_rgb_default
%% SET_COLOR_ORDER_RGB_DEFAULT changes the Matlab default colors in plots.
% In physics the RGB convention is typical for XYZ - Coordinates. This
% function changes the default order to RGB.
%
% Author: Max Bartholdt (max.bartholdt[at]imes.uni-hannover.de)
% Copyright(c)2021 Institut fuer Mechatronische Systeme
list_factory = fieldnames(get(groot,'factory'));
ind_color = find(contains(list_factory,'Color'));
list_factory_color = list_factory(ind_color);
ind_color_order = find(contains(list_factory_color,'Order'));

newcolors =[1.0 0.0 0.0; % Red
    0.0 0.4 0.0; % Green
    0 0.5 1.0]; % Blue

for i = 1:length(ind_color_order)
    factory_name = list_factory_color{ind_color_order(i)};
    default_name = strrep(factory_name,'factory','default');
    
    disp([factory_name,':'])
    disp(num2str(get(groot,factory_name)))
    disp(['to'])
    
    try
        set(groot, default_name,newcolors);
    catch except
        warning(except.message)
    end
    disp([default_name,':'])
        
    disp(num2str(get(groot,default_name)))
    disp('---')
end
show_current_default
end
