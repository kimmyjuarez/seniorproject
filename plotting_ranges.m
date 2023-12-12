% writematrix(label1_ranges, "label1_ranges.txt")
% writematrix(label2_ranges, "label2_ranges.txt")
% writematrix(label3_ranges, "label3_ranges.txt")
% writematrix(label4_ranges, "label4_ranges.txt")

plot_similar_patterns(label1_ranges, dishwasher_power)

function plot_similar_patterns(ranges, dishwasher_power)

    for i = 1:(length(ranges) / 2)
        if ranges(2*i-1) == 0
            break
        end
        plot(dishwasher_power(ranges(2*i-1):ranges(2*i)))
        fprintf('%d, %d', ranges(2*i-1),ranges(2*i))
        pause()
        clc
        % hold on
    end
 
end