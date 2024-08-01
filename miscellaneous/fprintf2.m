% Write text to file and screen with fprintf-like inputs
% 
% Input:
% fid - file identifier to append the text
% text - string written to file and screen
% varargin - additional inputs for fprints to format the string
% 
% See also https://de.mathworks.com/matlabcentral/answers/521738-fprintf-to-print-to-both-file-and-command-window#answer_429191

% Moritz Schappler, moritz.schappler@imes.uni-hannover.de, 2024.08
% (C) Institut für Mechatronische Systeme, Leibniz Universität Hannover

function fprintf2(fid, text, varargin)

fprintf(fid, text, varargin{:});
fprintf(text, varargin{:});