function print_current_figure(fig,name)
%% PRINT_CURRENT_FIGURE(FIG, NAME) creates pdf from fig with filename/path
% defined in name
fig.Renderer = 'painters';
set(fig,'InvertHardCopy','Off');
saveas(fig,name,'pdf')
end



