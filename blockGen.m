%==================================================
% Generate image blocks for feature computing
%==================================================

function [ inputBlock ] = blockGen(inputImage,block_start,block_length)

for i = 1:size(block_start,2)
    inputBlock(i).image = inputImage(block_start(1,i):block_start(1,i)+block_length-1,block_start(2,i):block_start(2,i)+block_length-1); 
end
