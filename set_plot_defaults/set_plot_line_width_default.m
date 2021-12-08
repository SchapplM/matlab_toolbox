function set_plot_line_width_default(l_width)
% SET_PLOT_LINE_WIDTH_DEFAULT(L_WIDTH) Changes the default width of all 
% line plot created with 'plot'.
%
% Author: Max Bartholdt (max.bartholdt[at]imes.uni-hannover.de)
% Copyright(c)2021 Institut fuer Mechatronische Systeme
list_factory = fieldnames(get(groot,'factory'));
ind_line_width = find(contains(list_factory,'LineLineWidth'));

disp('Changing default line width:')

for i = 1:length(ind_line_width)
    factory_name = list_factory{ind_line_width(i)};
    default_name = strrep(factory_name,'factory','default');
    
    if all(size(get(groot,default_name)) == [1,1])
        disp([factory_name,':', num2str(get(groot,factory_name)), ' to'])
        set(groot, default_name,l_width);
        disp([default_name,':', num2str(get(groot,default_name))])
        disp('---')
    end
end
show_current_default
end
