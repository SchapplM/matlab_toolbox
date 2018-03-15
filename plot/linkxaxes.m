% Connect the x-Axis of all subplots of the figure

function linkxaxes(figures)
if nargin == 0
    figlist = gcf;
elseif isa(figures, 'double')
    figlist = figures;
elseif strcmp(figures, 'all')
    figlist=findobj('type','figure');
else
    error('Wrong Input');
end
for i=1:numel(figlist)
    all_ha = findobj( figlist(i), 'type', 'axes', 'tag', '' ); %#ok<AGROW>
    linkaxes( all_ha, 'x' );
end