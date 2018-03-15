% append one entry to the current legend of the figure
% 
% Tested for Matlab 2014b
% For earlier Versions, see
% http://www.mathworks.de/support/solutions/en/data/1-181SJ/?solution=1-181SJ

% Moritz Schappler, schappler@irt.uni-hannover.de, 2015-01
% (c) Institut für Regelungstechnik, Leibniz Universität Hannover

function legend_append(hnew, text_new, interpreter)

% Initialize
str_gesamt = {};
hdl_gesamt = [];

% Get all Lines which have names (=Legend entries)
hdl_ch = get(gca, 'Children');
for i = length(hdl_ch):-1:1 % order of entries should stay the same
  if ~isempty(get(hdl_ch(i), 'DisplayName'))
    hdl_gesamt = [hdl_gesamt; hdl_ch(i)]; %#ok<*AGROW>
    str_gesamt = {str_gesamt{:}, get(hdl_ch(i), 'DisplayName')};
  end
end

% append legend for new line
hdl_gesamt = [hdl_gesamt; hnew];
str_gesamt = {str_gesamt{:}, text_new};
    
% Set new legend
legend(hdl_gesamt, str_gesamt);

% Get Legend handle
LEGH = legend;

if ~isempty(LEGH)
    interpreter_alt = get(LEGH, 'interpreter');
else
    interpreter_alt = 'tex';
end

% Interpreter setzen
if nargin == 3
    interpreter_neu = interpreter;
else
    interpreter_neu = interpreter_alt;
end
set(LEGH, 'interpreter', interpreter_neu);
