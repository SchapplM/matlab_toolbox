function mkdirs(directory)

if ~isfolder(directory)
  mkdir(directory);
end