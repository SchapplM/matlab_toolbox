% Erzeugen eines gültigen Dateinamen aus einem String
% http://www.mathworks.de/matlabcentral/newsreader/view_thread/49594

function newfilename = str2filename(oldfilename)
% entferne alle Zeichen die nicht der folgenden Liste entsprechen
% (ersetzen durch leeres Zeichen)
newfilename=regexprep(oldfilename, ...
'[^\d\w~!@#$%^&()_\-{}\s.]*',''); 

