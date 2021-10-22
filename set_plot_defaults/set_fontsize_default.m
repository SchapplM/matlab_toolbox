function set_fontsize_default(fontsize)
% SET_FONTSIZE_DEFAULT(FONTSIZE) Changes Matlab default values for all(!)
% font sizes in graphic objects.
%
% Author: Max Bartholdt (max.bartholdt[at]imes.uni-hannover.de)
% Copyright(c)2021 Institut fuer Mechatronische Systeme

list_factory = fieldnames(get(groot,'factory'));
ind_font_size = find(contains(list_factory,'FontSize'));
disp('Changing font sizes:')

for i = 1:length(ind_font_size)
    factory_name = list_factory{ind_font_size(i)};
    default_name = strrep(factory_name,'factory','default');
    
    if all(size(get(groot,default_name)) == [1,1]) && ~contains(factory_name,'Multiplier')
        disp([factory_name,':', num2str(get(groot,factory_name)), ' to'])
        set(groot, default_name,fontsize);
        disp([default_name,':', num2str(get(groot,default_name))])
        disp('---')
    end
end
show_current_default
end