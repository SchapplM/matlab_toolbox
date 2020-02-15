% Speichere alle Figures
% Argument 1: Pfad
% Argument 2: Cell mit Formaten, in denen die Bilder gespeichert werden.
% Argument 3: Anfangsteil des Dateinamens

% (C) Moritz Schappler, moritz.schappler@imes.uni-hannover.de, 2012

function save_figures(Pfad, Formate, praefix)

%     if ~isempty(varargin)
%         Pfad = varargin{1};
%     else
%         Pfad = pwd;
%     end
%     if length(varargin) >= 2 
%         Formate = varargin{2};
%     else
%         Formate = {'fig', 'tiff'};
%     end
    figHandles = findobj('Type','figure');
    for i = 1:length(figHandles)
        hdl = figure(figHandles(i));
        %% Suche ersten Titel
        FileName = get(hdl, 'FileName');
        if strcmp(FileName, '')
            % Der Titel steht im Subplot, dieser ist Kind-Klasse
            hdl_children = get(hdl, 'Children');
            % Nehme Namen des Figures
            Titel = get(figHandles(i), 'Name');
            % Nehme den Namen
            if isempty(Titel)
                Titel = get(hdl, 'Name');
            end
            % Nehme den ersten Titel
            if isempty(Titel)
              for j = 1:length(hdl_children)
                  try
                      hdl_Title = get(hdl_children(j), 'Title');
                  catch
                      continue;
                  end
                  Titel = get(hdl_Title, 'String');
                  if ~isempty(Titel)
                      break;
                  end
              end
            end
            if isempty(Titel)
                Titel = sprintf('fig%d', get(hdl, 'Number'));
            end
        else
            [~, Titel, ~] = fileparts(FileName);
        end
        %% Speichere
        dateiname = str2filename(sprintf('%s%s', praefix, Titel));
        
        for j=1:length(Formate)
            saveas(hdl, fullfile(Pfad, [dateiname, '.', Formate{j}]), Formate{j});
        end
        fprintf('figure %3d (%s) nach %s gespeichert\n', hdl.Number, hdl.Name, fullfile(Pfad, dateiname));
    end