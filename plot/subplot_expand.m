% Expandiere alle subplots in einem figure, so dass die Achsen verbunden
% sind, und m�glichst wenig Platz zwischen den Koordinatensysteme ist
% 
% fighdl    figure-Handle
% nrows     Anzahl der Subplot-Zeilen
% ncols     Anzahl der Subplot-Spalten
% sphdls    Handles zu existierenden subplots

% MA Moritz Schappler, schapplm@stud.uni-hannover.de, 2013-12
% Institut f�r mechatronische Systeme, Universit�t Hannover
% Betreuer: Daniel Beckmann, Daniel.Beckmann@imes.uni-hannover.de

function sphdls = subplot_expand(fighdl, nrows, ncols, sphdls)
figure(fighdl);

if nargin == 3
  sphdls = zeros(nrows, ncols);
  for i = 1:nrows
    for j = 1:ncols
      sphdls(i,j) = subplot(nrows, ncols, ncols*(i-1)+j);
    end
  end
else
  % nrows = length(sphdls);
end
  
if ncols == 1
  for sp = nrows:-1:1 % R�ckw�rts durchgehen, damit die 10er-Potenz der Achsenbeschriftung im Vordergrund ist
%     hdls(sp) = subplot(nrows, ncols, sp);
    % Position: von links, von unten, Breite, H�he
    set(sphdls(sp), 'Position', [0.05, 0.90*(nrows-sp)/(nrows)+0.05, ...
        0.925, 1/(nrows)*0.85]);
         
    % zu erledigen: ylabel befestigen
%     ylhdl = get(sphdls(sp), 'ylabel');
%     set(ylhdl, 'Position')
    ZOrderSet(sphdls(sp), -sp);
  end
  linkaxes(sphdls, 'x' );
elseif ncols == 2
  for i = 1:nrows
    for j = 1:ncols
      if isnan(sphdls(i,j))
        continue
      end
      if j == 1
        set(sphdls(i,j), 'Position', [0.10, 0.90*(nrows-i)/(nrows)+0.05, ...
            0.4, 1/(nrows)*0.85]);
      else
        set(sphdls(i,j), 'Position', [0.55, 0.90*(nrows-i)/(nrows)+0.05, ...
            0.4, 1/(nrows)*0.85]);
      end
   
      % die unteren subplots weiter in den Vordergrund holen
      ZOrderSet(sphdls(i,j), -i*2+j);
    end
  end
  linkaxes(sphdls(:), 'x' );
elseif ncols == 3
  for i = 1:nrows
    for j = 1:ncols
      if isnan(sphdls(i,j))
        continue
      end
      if j == 1
        set(sphdls(i,j), 'Position', [0.10, 0.90*(nrows-i)/(nrows)+0.05, ...
            0.23, 1/(nrows)*0.85]);
      elseif j == 2
        set(sphdls(i,j), 'Position', [0.40, 0.90*(nrows-i)/(nrows)+0.05, ...
            0.23, 1/(nrows)*0.85]);
      else
        set(sphdls(i,j), 'Position', [0.70, 0.90*(nrows-i)/(nrows)+0.05, ...
            0.23, 1/(nrows)*0.85]);
      end
      % die unteren subplots weiter in den Vordergrund holen
      ZOrderSet(sphdls(i,j), -i*2+j);
    end
  end
else
  warning('F�r mehr als 2 Spalten noch nicht implementiert.');
end
% Beschriftungen der oberen x-Achsen entfernen
remove_inner_labels(sphdls,1); 