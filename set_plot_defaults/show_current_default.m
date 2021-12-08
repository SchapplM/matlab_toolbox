function show_current_default
% SHOW_CURRENT_DEFAULT
%
% What have I done?!
%
% Shows a plot with current default settings.
disp(get(groot,'default'))
% Example plot
fig = figure;
ax = axes;
in = [0:0.01:6];
plot(in,10*exp(-in))
hold on 
plot(in,cos(in))
plot(in,in)
grid on
title('Your new default look')
ylabel('Motivation')
xlabel('Time in months')
xlim([min(in),max(in)])
legend({'You','Me','Everyone else'})
end