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

% AV settings, see ffmpeg documentation. The colour format is non-standard
% and comes from the settings of the Matlab figures.
% The video setting (h264, ...) is suited for integration in PowerPoint)
avsettings = '-c:v libx264 -preset slower -profile:v high -level 51 -an -vf "format=yuv420p"';
[d,f,~] = fileparts(videofile_avi);
videofile_mp4 = fullfile(d, [f, '.mp4']);
% Always use ffmpeg (do not try to look for avconv or check availability)
avtool = 'ffmpeg';
cmd = sprintf('%s -y -i "%s" %s "%s"', avtool, videofile_avi, avsettings, videofile_mp4);
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
