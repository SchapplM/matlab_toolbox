% FFT-Subplot basierend auf vorhandenen Zeit-Subplots hinzufügen
% 
% Berechnet wird die FFT eines plots im Zeitbereich
% Die Zeitbereichs-Plots werden über die Handle-Matrix srcdata_hdl gelesen.
% Abtastrate und y-Daten werden damit bestimmt.
% Wenn srcdata_hdl ein N-D-Array ist, werden D FFT Verläufe berechnet und
% in die zugehörigen Koordinatensysteme (axes) in ax_f eingezeichnet
% Vor der FFT-Berechnung wird der Mittelwert des Signals abgezogen.
% Wenn in das Zeit-Signal der axes-Objekte in ax_t gezoomt wird, wird
% automatisch für diesen Bereich die FFT berechnet.
% 
% ax_t      Handles zu Achs-Systemen (subplot), die bei Zoom und
%           Verschieben den FFT-Bereich anpassen sollen
% ax_f      Handle für FFT-Subplot
% srcdata_hdl  
%           handle der plot-Objekte, zu denen die FFT berechnet wird.
%           Zeilen: Subplots
%           Spalten: Datenreihen (plot)

% MA Moritz Schappler, schapplm@stud.uni-hannover.de, 2014-02
% Institut für mechatronische Systeme, Leibniz Universität Hannover
% Betreuer: Daniel Beckmann, Daniel.Beckmann@imes.uni-hannover.de

function plot_fft(ax_t, ax_f, srcdata_hdl)
    if size(srcdata_hdl,1) ~= length(ax_f)
        error('Jeder Zeile aus srcdata_hdl muss ein subplot aus ax_f entsprechen.');
    end

    % FFT erstmalig berechnen und Handles speichern
    calc_fft([0 Inf], ax_f, srcdata_hdl);
    
    %set(h,'ActionPreCallback',@myprecallback);
    % anonyme Funktion erzeugen, damit zusätzliche Argumente an
    % Callback-Funktion übergeben werden können
    tmpfcn = @(obj,evd) (mypostcallback(obj,evd,ax_t, ax_f, srcdata_hdl));
    % Callback-Funktion für zoomen erzeugen
    fignumber = get(ax_t(1), 'Parent');
    h=zoom(fignumber);
    set(h,'ActionPostCallback',tmpfcn);
    % Callback-Funktion für Verschieben erzeugen
    h=pan(fignumber);
    set(h,'ActionPostCallback',tmpfcn); 
    
end

function hdl_plot=calc_fft(newLim,ax_f,srcdata_hdl)
    for ii = 1:size(srcdata_hdl,1)
        axes(ax_f(ii));cla;hold on;
        % alle plot-handles durchgehen und daraus fft berechnen
        for srchdl=srcdata_hdl(ii,:)
            if ~ishandle(srchdl) || srchdl==0
                continue; % Linie wurde wohl gelöscht
            end
            % x-, y-Daten holen und Abtastrate berechnen
            xdata = get(srchdl, 'XDATA')';
            s_rate = 1/mean(diff(xdata));
            ydata = get(srchdl, 'YDATA')';
            ystyle = get(srchdl);

            if isinf(newLim(2))
                newLim(2) = xdata(end);
            end
            % Indizes von Anfang und Ende berechnen
            [~, idx1] = min(abs(xdata - newLim(1)));
            [~, idx2] = min(abs(xdata - newLim(2)));
            % Bereich für FFT auswählen
            L = idx2-idx1+1;   
            hamming_source = hamming(L); % Hamming-Fenster
            N = 2^nextpow2(L);    

            % Alle Datenreihen durchgehen
            fft_source = ydata(idx1:idx2);
            % Mittelwert abziehen
            fft_source2 = fft_source - mean(fft_source);
            % Hamming-Fenster anwenden
            fft_source2 = fft_source2.*hamming_source; 
            % FFT durchführen
            fft_data = fft(fft_source2,N)/L;
            % Frequenz-Schritte berechnen
            f = (s_rate/2*linspace(0,1,N/2+1))';
            % Amplitude der FFT-Daten extrahieren
            abs_fft_data = 2*abs(fft_data(1:N/2+1));

            % Linien-Stil von Ursprungsdaten übernehmen
            hdl_plot=plot(f, abs_fft_data, ystyle.LineStyle);
            set(hdl_plot, 'Color', ystyle.Color);
        end
        if ii == 1
            title(['FFT Plot ', num2str((idx1-1)/s_rate), 's - ', ...
                num2str((idx2-1)/s_rate) ' s. \Delta f = ' num2str(mean(diff(f))), ' Hz'])
        end
    end
end


% Callback-Funktion
function mypostcallback(~,evd, ax_t, ax_f,srcdata_hdl)
    if any(evd.Axes == ax_t)
        newLim = get(evd.Axes,'XLim');
        %msgbox(sprintf('The new X-Limits are [%.2f %.2f].',newLim));
        calc_fft(newLim, ax_f, srcdata_hdl);
    end
end
