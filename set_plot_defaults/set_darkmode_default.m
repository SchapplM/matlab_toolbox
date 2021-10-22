function set_darkmode_default
% SET_DARKMODE_DEFAULT
%
% This script changes the default groot setting. Figure and axes will
% appear in darkmode which are perfect for dark ppt-slides. It is needless
% to point out, that dark mode plots are not appropiate for printed media.
%
% Author: Max Bartholdt (max.bartholdt[at]imes.uni-hannover.de)
% Copyright(c)2021 Institut fuer Mechatronische Systeme

list_factory = fieldnames(get(groot,'factory'));
ind_color = find(contains(list_factory,'Color'));
list_factory_color = list_factory(ind_color);

ind_color_text = find(contains(list_factory_color,'Text'));
ind_color_figure = find(contains(list_factory_color,'Figure'));
ind_color_axes = find(contains(list_factory_color,'Axes'));
ind_color_label = find(contains(list_factory_color,'Label'));
ind_color_order = find(contains(list_factory_color,'Order'));


disp('Changing figure color:')

for i = 1:length(ind_color_figure)
    factory_name = list_factory_color{ind_color_figure(i)};
    default_name = strrep(factory_name,'factory','default');
    
    if all(size(get(groot,default_name)) == [1,3]) && ~contains(default_name,'map')
        disp([factory_name,':', num2str(get(groot,factory_name)), ' to'])
        
        try
            set(groot, default_name,[0 0 0]);
        catch except
            warning(except.message)
        end
        disp([default_name,':', num2str(get(groot,default_name))])
        disp('---')
        
    end
end


disp('Changing axes color:')

for i = 1:length(ind_color_axes)
    factory_name = list_factory_color{ind_color_axes(i)};
    default_name = strrep(factory_name,'factory','default');
    
    if all(size(get(groot,default_name)) == [1,3]) && strcmp('factoryAxesColor',factory_name)
        disp([factory_name,':', num2str(get(groot,factory_name)), ' to'])
        
        try
            set(groot, default_name,[0 0 0]);
        catch except
            warning(except.message)
        end
        disp([default_name,':', num2str(get(groot,default_name))])
        disp('---')
        
    elseif all(size(get(groot,default_name)) == [1,3])
        disp([factory_name,':', num2str(get(groot,factory_name)), ' to'])
        
        try
            set(groot, default_name,[1 1 1]);
        catch except
            warning(except.message)
        end
        disp([default_name,':', num2str(get(groot,default_name))])
        disp('---')
        
    elseif strcmp('factoryAxesColorOrder',factory_name)
        newcolors =[1.0 0.0 0.0;
            0.0 0.4 0.0;
            0 0.5 1.0];
        set(groot, default_name,newcolors);
    end
end

disp('Changing text colors:')

for i = 1:length(ind_color_text)
    factory_name = list_factory_color{ind_color_text(i)};
    default_name = strrep(factory_name,'factory','default');
    
    if all(size(get(groot,default_name)) == [1,3])
        disp([factory_name,':', num2str(get(groot,factory_name)), ' to'])
        
        try
            set(groot, default_name,[1 1 1]);
        catch except
            warning(except.message)
        end
        disp([default_name,':', num2str(get(groot,default_name))])
        disp('---')
    end
end

disp('Changing label colors:')

for i = 1:length(ind_color_label)
    factory_name = list_factory_color{ind_color_label(i)};
    default_name = strrep(factory_name,'factory','default');
    
    if all(size(get(groot,default_name)) == [1,3])
        disp([factory_name,':', num2str(get(groot,factory_name)), ' to'])
        
        try
            set(groot, default_name,[1 1 1]);
        catch except
            warning(except.message)
        end
        disp([default_name,':', num2str(get(groot,default_name))])
        disp('---')
    end
end
show_current_default
end

