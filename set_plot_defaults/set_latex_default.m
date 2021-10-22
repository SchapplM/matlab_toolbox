function set_latex_default
% SET_LATEX_DEFAULT
%
% Changes all (!) default interpreters within Matlab to 'latex'.
%
% Author: Max Bartholdt (max.bartholdt[at]imes.uni-hannover.de)
% Copyright(c)2021 Institut fuer Mechatronische Systeme
list_factory = fieldnames(get(groot,'factory'));
ind_interpreter = find(contains(list_factory,'Interpreter'));

for i = 1:length(ind_interpreter)
    default_name = strrep(list_factory{ind_interpreter(i)},'factory','default');
    set(groot, default_name,'latex');
end

show_current_default
end