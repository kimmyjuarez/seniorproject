load('dishwasher_power.txt')
load('embedding_decimal_value.txt')
load('t_embedding_decimal_value.csv')

% Get the embeddings for each label (1-4)
unique_embeddings = unique(embedding_decimal_value(:,1));
similar_patterns = [];

label1 = [];
label2 = [];
label3 = [];
label4 = [];

for i = 1:length(unique_embeddings)
    retrieved_ranges = locateRanges(unique_embeddings(i), t_embedding_decimal_value);
    l = 2;
    similar_patterns(i, 1) = unique_embeddings(i);

    for j = 1:161
        if similar_patterns(i,1) == embedding_decimal_value(j,1)
            if embedding_decimal_value(j,2) == 1
                label1(length(label1) + 1) = i;
                break
            elseif embedding_decimal_value(j,2) == 2
                label2(length(label2) + 1) = i;
                break
            elseif embedding_decimal_value(j,2) == 3
                label3(length(label3) + 1) = i;
                break
            else 
                label4(length(label4) + 1) = i;
                break
            end
        end
    end
    
    for k = 1:length(retrieved_ranges)
        similar_patterns(i,l) = retrieved_ranges(k);
        l = l + 1;
    end 
end

% Get the number of instances from the test data from each label (overlapping)
% label1_count = find_counts(label1, similar_patterns); 1630
% label2_count = find_counts(label2, similar_patterns); 3529
% label3_count = find_counts(label3, similar_patterns); 207
% label4_count = find_counts(label4, similar_patterns); 2376

% -----------------------------------------------------------------------------------------------------
% Getting non overlapping ranges for each label with their counts
label1_ranges = find_non_overlapping_ranges(label1, similar_patterns);
label2_ranges = find_non_overlapping_ranges(label2, similar_patterns);
label3_ranges = find_non_overlapping_ranges(label3, similar_patterns);
label4_ranges = find_non_overlapping_ranges(label4, similar_patterns);

label1_count = length(label1_ranges)/2;
label2_count = length(label2_ranges)/2;
label3_count = length(label3_ranges)/2;
label4_count = length(label4_ranges)/2;
% ----------------------------------------------------------------------------------------------------

% Just to see number of instances to split work
function count = find_counts(labels, similar_patterns)
    count = 0;
    for j = 1:length(labels)
        ranges = similar_patterns(labels(j), 2:length(similar_patterns));
    
        for i = 1:(length(ranges) / 2)
            if ranges(2*i-1) == 0
                break
            end
            count=count+1;
        end
    end
end

% Getting the ranges for each pattern
function ranges = locateRanges(decimal_value, t_embedding_decimal_value)
   temp_ranges = [];
   j = 1;
   for i = 1:199817
      if decimal_value == t_embedding_decimal_value(i)
         if j == 1
            temp_ranges(j) = i + 45000;
            j = j + 1;
            temp_ranges(j) = i + 45338;
            j = j + 1;  
         elseif (i + 45000) > (temp_ranges(j-1))
            temp_ranges(j) = i + 45000;
            j = j + 1;
            temp_ranges(j) = i + 45338;
            j = j + 1;   
         end
      end
   end

   ranges = temp_ranges;
end

% Find non-overlapping ranges for single pattern
function non_overlapping_ranges = find_non_overlapping_ranges(label, similar_patterns)
    non_overlapping_ranges = [];

    for i = 1:length(label)
        ranges = similar_patterns(label(i), 2:length(similar_patterns));

        for j = 1:(length(ranges) / 2)
            if ranges(2*j-1) == 0
                break
            elseif ~isempty(non_overlapping_ranges)
                addRange = true;
                for k = 1:(length(non_overlapping_ranges)/2)
                    if ranges(2*j-1) > non_overlapping_ranges(2*k-1) & ranges(2*j-1) < non_overlapping_ranges(2*k)
                        addRange = false;
                        break
                    elseif ranges(2*j) > non_overlapping_ranges(2*k-1) & ranges(2*j) < non_overlapping_ranges(2*k)
                        addRange = false;
                        break
                    elseif ranges(2*j-1) > non_overlapping_ranges(2*k) & 2*k == length(non_overlapping_ranges)
                        break
                    else
                        continue
                    end
                end
                if addRange
                    non_overlapping_ranges(length(non_overlapping_ranges)+1) = ranges(2*j-1);
                    non_overlapping_ranges(length(non_overlapping_ranges)+1) = ranges(2*j);
                end
            else 
                non_overlapping_ranges(length(non_overlapping_ranges)+1) = ranges(2*j-1);
                non_overlapping_ranges(length(non_overlapping_ranges)+1) = ranges(2*j);
            end
        end
    end
end