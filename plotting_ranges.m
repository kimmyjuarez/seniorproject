load('label4_ranges.txt')
load('dishwasher_power.txt')
writematrix(label4_ranges, "label4_ranges.txt")

plot_similar_patterns(label4_ranges, dishwasher_power);

function plot_similar_patterns(ranges, dishwasher_power)
    figure;

    for i = 1:(length(ranges) / 2)
        if ranges(2*i-1) == 0
            break
        end

        upper = ranges(2*i);
        lower = ranges(2*i-1);

        disp(['Plotting range ', num2str(lower), '-', num2str(upper)]);

        plot(dishwasher_power(lower:upper), 'DisplayName', sprintf('Range %d-%d', lower, upper));
        
        pause();

        % Mark the range on the plot using text
        text(lower, dishwasher_power(lower), sprintf('Start %d', lower), 'VerticalAlignment', 'top', 'HorizontalAlignment', 'right');
        text(upper, dishwasher_power(upper), sprintf('End %d', upper), 'VerticalAlignment', 'top', 'HorizontalAlignment', 'right');
    end
    
    hold off;

    xlabel('Time');
    ylabel('Power Consumption');
    title('Dishwasher Power Consumption');
    legend('show');
end
