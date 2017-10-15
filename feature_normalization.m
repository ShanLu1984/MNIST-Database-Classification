function [ output_feature ] = feature_normalization( input_feature )

input_max = max(max(input_feature));
input_min = min(min(input_feature));

feature_length = input_max - input_min;

output_feature = (input_feature - input_min) / feature_length;


end

