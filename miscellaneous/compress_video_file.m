% Convert a video file into a different format (currently avi->mp4)
% Useful to compress results of the Matlab Video Writer
% Using mp4 directly in the video writer may lead to problems
% 
% Prerequisites:
% On Linux: Install ffmpeg. If your distribution contains avconv instead
% (like Ubuntu 16.04), create a symbolic link
% On Windows: Install ffmpeg and add it to the (windows) path. Some
% programs already do this (e.g. ImageMagick).
% 
% input:
% videofile_avi
%   path to avi file to be compressed (into an mp4 file with same name)
% delete_on_success [1x1 logical]
%   Delete the input file after (and only after) successful conversion
% verbosity [1x1]
%   degree of verbosity
%   0=no output
%   1=only important
%   2=all

% Moritz Schappler, moritz.schappler@imes.uni-hannover.de, 2019-08
% (C) Institut für Mechatronische Systeme, Leibniz Universität Hannover

function compress_video_file(videofile_avi, delete_on_success, verbosity)

if ~exist(videofile_avi, 'file')
  warning('File %s does not exist', videofile_avi);
  return
end
if nargin < 2
  delete_on_success = true;
end
if nargin < 3
  verbosity = 1;
end

%% Read the Video file to determine the cropping borders
% Cropping with ffmpeg is possible, but only works for black borders.
% http://ffmpeg.org/ffmpeg-filters.html#cropdetect
% Matlab videos usually have white borders around the axes
vidObj = VideoReader(videofile_avi);
FrameMask = false(vidObj.Height, vidObj.Width); % pixels to select have a 1
while hasFrame(vidObj) % read video frame by frame
  vF = readFrame(vidObj);
  % Get non-white pixels and add them to the mask
  pxlNonWhite = ~(vF(:,:,1)==255 & vF(:,:,2)==255 & vF(:,:,3)==255);
  FrameMask = FrameMask | pxlNonWhite;
end
% Determine the cropping borders from the Mask
firstX = find(any(FrameMask), 1, 'first');
lastX = find(any(FrameMask), 1, 'last');
firstY = find(any(FrameMask'), 1, 'first');
lastY = find(any(FrameMask'), 1, 'last');
% Determine rectangle of the content to keep
cr_orig = [lastX-firstX, lastY-firstY];
cr = ceil(cr_orig/32)*32; %  (enlarge to fit mod32)
% Determine point coordinates (top left corner of the rectangle)
rp_orig = [firstX,firstY];
% Move to top left to account for rounding the rectangle to mod32
rp = rp_orig - round((cr-cr_orig)/2);
% Check validity (avoid negative values from rounding)
rp = [max(rp(1),1), max(rp(2),1)];
% Check validity for a rectangle that exceeds the right border of the frame
I_exc_right_border = rp+cr>[vidObj.Width,vidObj.Height];
rp(I_exc_right_border) = 1; % set coordinate to avoid exceeding the border
% Set up string according to ffmpeg documentation.
cropoptions = sprintf('crop=%d:%d:%d:%d,', cr(1), cr(2), rp(1), rp(2));
fprintf('Automatic detection of cropping area: use %dx%d starting from %d,%d (res. %dx%d; i.e. use %1.1f/%1.1f%% of the width/height)\n', ...
  cr(1), cr(2), rp(1), rp(2), vidObj.Width, vidObj.Height, 100*cr(1)/vidObj.Width, 100*cr(2)/vidObj.Height);
clear vidObj
% AV settings, see ffmpeg documentation. The colour format is non-standard
% and comes from the settings of the Matlab figures.
% The video setting (h264, ...) is suited for integration in PowerPoint.
avsettings = sprintf(' -vf %sformat=yuv420p -c:v libx264 -preset slower -profile:v high -level 51 -an', cropoptions);
[d,f,~] = fileparts(videofile_avi);
videofile_mp4 = fullfile(d, [f, '.mp4']);
% Always use ffmpeg (do not try to look for avconv or check availability)
cmd = sprintf('ffmpeg -y -i "%s" %s "%s"', videofile_avi, avsettings, videofile_mp4);
if verbosity < 2
  % Disable ffmpeg progress output
  cmd = [cmd, ' -loglevel 0'];
end
% Run ffmpeg with arguments
res = system(cmd);
if res == 0
  % successful conversion without errors
  if verbosity >= 1
    finfotmp_mp4 = dir(videofile_mp4);
    finfotmp_avi = dir(videofile_avi);
    fprintf('successfully compressed video file %s. (%1.1f MB avi-> %1.1f MB mp4).\n', ...
      finfotmp_mp4(1).name, finfotmp_avi(1).bytes/1e6, finfotmp_mp4(1).bytes/1e6);
  end
  if delete_on_success
    delete(videofile_avi);
    if verbosity >= 1
      fprintf('deleted old avi file %s\n', videofile_avi);
    end
  end
else
  warning('Error compressing file %s', videofile_avi);
end
