% Die Schriftart und Schriftgröße für alle Plots und Subplots ändern

% Alexander Tödtheide toedtheide@irt.uni-hannover.de, 2015-06
% (C) Institut für Regelungstechnik, Leibniz Universität Hannover

function set_font_fontsize(fig_handle,FontName,FontSize)

ha1 = findobj(fig_handle,'Type','axes');
for i = 1:length(ha1)   
    set(ha1(i), 'FontName', FontName);
    set(ha1(i), 'FontSize', FontSize);
    try
    set(ha1(i), 'LabelFontSizeMultiplier', 1)
    end
end



end