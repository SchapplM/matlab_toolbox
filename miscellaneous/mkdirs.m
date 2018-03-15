function mkdirs(directory)

if ~exist(directory, 'file')
  mkdir(directory);
end