function set_factory_default
% SET_FACTORY_DEFAULT sets all groot defaults to factory. Excluded are those who
% cannot be written or read as well as any struct type settings.
%
% Author: Max Bartholdt (max.bartholdt[at]imes.uni-hannover.de)
% Copyright(c)2021 Institut fuer Mechatronische Systeme

list_default = fieldnames(get(groot,'default'));

for i = 1:length(list_default)
    default_name = list_default{i};
    factory_name = strrep(default_name,'default','factory');
    
    try
        % structs cannot be handled yet
        if ~isa(get(groot,factory_name),'struct') && ~isempty(get(groot,factory_name))
            set(groot,default_name,get(groot,factory_name));
        end
        
    catch except
        
        switch except.identifier
            case 'MATLAB:hg:DefaultCannotBeSetGet'
                warning(except.message)
            case 'MATLAB:class:SetProhibited'
                warning(except.message)
            otherwise
                throw(except)
        end
    end
end

show_current_default
end