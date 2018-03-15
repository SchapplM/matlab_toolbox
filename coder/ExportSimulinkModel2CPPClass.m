% Function for generating cpp code for a class from a simulink block or model.
% The generated class is named
% <name_of_block(until_31st_character)>ModelClass. In the default config
% (useDefaultConfig = true), struct types are decleared for the following groups
% of variables: tunable (mask) Parameters:
% P_<name_of_block(until_27th_character)_T, block signals:
% B_<name_of_block(until_27th_character)>_T, inputs:
% ExtU_<name_of_block(until_24th_character)>_T, outputs:
% ExtY_<name_of_block(until_24th_character)>_T, internal states:
% DW_<name_of_block(until_26th_character)>_T. Furthermore, with the
% DefaultConfiguration, the ModelClass has the void initialize(), void step(),
% void terminate(), const P_..._T & getBlockParameters() const, void
% setBlockParameters(const P_..._T*), const B_..._T & getBlockSignals() const,
% void setBlockParameters(const B_..._T*), const DW_..._T & getDWork() const,
% void setDWork(const DW_..._T*), void setExternalInputs(const ExtU_..._T*),
% const ExtY_..._T & getExternalOutputs() const methods to access these structs
% as well as initialize, calculate and terminate the model. Some generic
% functions to get and set the simulink real-time model are generated as well.
% In order to use the generated code, the code generated for each block should
% be compiled in a sepreate shared library (*.so) to avoid naming conflicts. The
% shared libraries have to be linked into the main program and the main include
% file for each block named <name_of_block(until_31st_character)>.h must be
% included. An example for the code generation and correct use of the generated
% code in ac amke example program can be found in the
% irt_matlab_toolbox/examples/code_export_from_simulink_block_to_cpp_class. 
% 
% Input:
% model [string]
%   Name of Simulink model containing the block
% block [string]
%   Name of block/subsystem with a leading "/" or empty string, when the full
%   model shall be exported
% goal [string]
%   path to where the code shall be exported, two directories "src" and
%   "include/<model(1:31)>" will be generated at the destination and the .cpp
%   and .h files are moved there respectively after generation
% deleteGenerationFiles [bool]
%   If true, all temporary files created during code generation will be deleted
%   afterwards, including the code generation report
% useDefaultCondigSet [bool]
%   If true, the model config of the Code Generation/Interface section is
%   overwritten by defaults resulting in a class, where parameters, inputs,
%   internal states and outputs can be accessed by strucure-based functions and
%   the class has a void step() function as well as a terminate() function and a
%   destructor
% 
% Output:
%   none

% Jonathan Vorndamme, vorndamme@irt.uni-hannover.de, 2017-07
% (c) Institut für Regelungstechnik, Leibniz Universität Hannover

function ExportSimulinkModel2CPPClass(model, block, goal, deleteGenerationFiles, useDefaultConfigSet)
  if nargin == 3
    deleteGenerationFiles = true;
    useDefaultConfigSet = true;
  end
  if nargin == 4
    useDefaultConfigSet = true;
  end
  openModels = find_system('SearchDepth', 0);
  modelLoaded = strfind(openModels, model);
  if ~isempty(modelLoaded) && sum(modelLoaded{:})
    answer = questdlg(['Warning: the model which you want to export code for is'...
                      ' opened or loaded and will be closed when you proceed. '...
                      'Do you want to save pending changes?']);
    if strcmp(answer,'Yes')
      close_system(model, true);
    elseif strcmp(answer,'No')
      close_system(model, false);
    else
      return;
    end
  end
  path = cd; %#ok<*MCCD>
  addpath(path); %#ok<*MCAP>
  try
    cd(goal);
    if ~exist('tmp', 'dir')
      mkdir('tmp');
    end
    if ~exist('src', 'dir')
      mkdir('src');
    end
    if ~exist('include', 'dir')
      mkdir('include');
    end
    cd('tmp');
    load_system(model);
    % get old config:
    oldcfg = getActiveConfigSet(model); % to save use: h.saveAs('name');
    % generate config for cpp class code export, attach to model and make active
    newcfg = copy(oldcfg);
    attachConfigSet(model,newcfg,true);
    setActiveConfigSet(model,newcfg.Name);
  catch error
    rmpath(path);
    throw(error);
  end
  try
    %% Select ert.tlc as the System Target File for the model
    set_param(model,'SystemTargetFile','ert.tlc')
    %% Select C++ as the target language for the model
    set_param(model,'TargetLang','C++')
    %% Select C++ class as the code interface packaging for the model
    set_param(model,'CodeInterfacePackaging','C++ class')
    if useDefaultConfigSet
      set_param(model,'SimCompilerOptimization','on')
      set_param(model,'InternalMemberVisibility','private')
      set_param(model,'ParameterMemberVisibility','private')
      set_param(model,'GenerateParameterAccessMethods','Method')
      set_param(model,'GenerateInternalMemberAccessMethods','Method')
      set_param(model,'GenerateExternalIOAccessMethods','Structure-based method')
      set_param(model,'GenerateDestructor','on')
      set_param(model,'IncludeMdlTerminateFcn','on')
      set_param(model,'GenerateSampleERTMain','off')
    end
    % code generation
    rtwbuild([model block]);
  catch error
    setActiveConfigSet(model,oldcfg.Name);
    detachConfigSet(model,newcfg.Name);
    close_system(model,false);
    if deleteGenerationFiles
      rmdir([goal '/tmp'], 's');
    end
    cd(path);
    rmpath(path);
    throw(error);
  end
  % deploy code to goal
  cd(goal);
  if isempty(block)
    if length(model)>31
      copyfile([goal '/tmp/' model(1:31) '_ert_rtw/*.h'], [goal '/include']);
      copyfile([goal '/tmp/' model(1:31) '_ert_rtw/*.cpp'], [goal '/src']);
    else
      copyfile([goal '/tmp/' model '_ert_rtw/*.h'], [goal '/include']);
      copyfile([goal '/tmp/' model '_ert_rtw/*.cpp'], [goal '/src']);
    end
  else
    if length(block)>32
      copyfile([goal '/tmp/' block(2:32) '_ert_rtw/*.h'], [goal '/include']);
      copyfile([goal '/tmp/' block(2:32) '_ert_rtw/*.cpp'], [goal '/src']);
    else
      copyfile([goal '/tmp/' block(2:end) '_ert_rtw/*.h'], [goal '/include']);
      copyfile([goal '/tmp/' block(2:end) '_ert_rtw/*.cpp'], [goal '/src']);
    end
  end
  % clean up
  setActiveConfigSet(model,oldcfg.Name);
  detachConfigSet(model,newcfg.Name);
  close_system(model,false);
  if deleteGenerationFiles
    rmdir([goal '/tmp'], 's');
  end
  cd(path);
  rmpath(path);
end