function set_FontFontsize(fig_handle,FontName,FontSize)

% Die Schriftart und Schriftgröße für alle Plots und Subplots ändern

% Alexander Tödtheide toedtheide@irt.uni-hannover.de, 2015-06
% (c) Institut für Regelungstechnik, Leibniz Universität Hannover
% shape = [4,2];

ha1 = findobj(fig_handle,'Type','axes');
for i = 1:length(ha1)   
    set(ha1(i), 'FontName', FontName);
    set(ha1(i), 'FontSize', FontSize);
    try
    set(ha1(i), 'LabelFontSizeMultiplier', 1)
    end
end



end