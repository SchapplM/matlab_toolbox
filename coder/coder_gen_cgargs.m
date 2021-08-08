% Lese die cgargs-Zeile aus Matlab-Funktionen aus. Hilfsfunktion.
% Siehe matlabfcn2mex

% Moritz Schappler, moritz.schappler@imes.uni-hannover.de, 2021-08
% (C) Institut für Mechatronische Systeme, Leibniz Universität Hannover

function cga_line = coder_gen_cgargs(filename)
fid = fopen(filename,'r');
tline = fgetl(fid);
cga_found = false;
cga_line = '';
while ischar(tline)
  if contains(tline, '%$cgargs')
    if ~cga_found % erstes Vorkommnis
      cga_line = tline(9:end);
      cga_found = true;
    else % mehrzeilig
      cga_line = [cga_line, tline(9:end)]; %#ok<AGROW>
    end
  elseif cga_found
    % Der (mehrzeilige) Kommentar ist vorbei
    break;
  end
  tline = fgetl(fid);
end
fclose(fid);