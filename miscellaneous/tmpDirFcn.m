% Generate a Temporary Directory
% 
% Input:
% erschaffen [1x1] bool 
%   Create the generated directory
%   Default: 1
% wechseln [1x1] bool
%   switch to this directory
%   Default: 0
% gesamtpfad [1x1] bool
%   add this directory to the Matlab Path
%   Default: 0
% 
% Output:
%   Path of the generated temporary directory

% Moritz Schappler, schappler@irt.uni-hannover.de, 2014-09
% (c) Institut für Regelungstechnik, Universität Hannover

function tmpDir = tmpDirFcn(erschaffen, wechseln, gesamtpfad)
if nargin<3
    gesamtpfad=0;
end
if nargin<2
    wechseln = 0;
end
if nargin<1
    erschaffen = 1;
end

%% Generate Name of Directory
TempPfad = fullfile(tempdir() , 'Matlab');
SET = char(['A':'Z' 'a':'z' '0':'9']) ;
NSET = length(SET) ;
N = 5 ; % pick N numbers
i = ceil(NSET*rand(1,N)) ; % with repeat
R = SET(i) ; 
tmpDir = fullfile(TempPfad, [datestr(now,'yyyymmdd_HHMMSS_FFF_'), R]);

%% Create/ Switch directory

if erschaffen
    mkdir(tmpDir);
end

if wechseln
    cd(tmpDir);
end

if gesamtpfad
    addpath(tmpDir);
end