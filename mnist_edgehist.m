function edgehist = mnist_edgehist(image)
% EE6850 HW3, Content-Based Image Retrieval
% CBIR_edgehist() -- edge histogram calculation
% input:
%   MxNx3 image data, in RGB
%   or MxN luminance channel
% output:
%   1x5 edgehistogram <== global 5 bins (0, 45, 90, 135, no-oreintation)
% roughly as the MPEG-7 edge histogram descriptor
% [Ref] Manjunath, B.S.; Ohm, J.-R.; Vasudevan, V.V.; Yamada, A., "Color and texture descriptors" 
% IEEE Trans. CSVT, Volume: 11 Issue: 6 , Page(s): 703 -715, June 2001 (section III.B)
% 
% 10-19-2001, xlx@ee.columbia.edu

DEBUG = 0;
% % check input
% if length(size(rgb)) == 2
%     % take as luminance directly
%     lum = rgb;
% elseif size(rgb,3) == 3
%     % convert to luminance
%     lum = rgb2ycbcr(rgb);
%     lum = lum(:,:,1);
% end

imgsize = size(image);
% get rid of irrelevant boundaries
i0=round(0.05*imgsize(1));  i1=round(0.95*imgsize(1));
j0=round(0.05*imgsize(2));  j1=round(0.95*imgsize(2));
lum = image(i0:i1, j0:j1) * 255;
imgsize = lum;
if DEBUG
    subplot(231);
    imshow(lum);
    imshow(lum); title(' lum.');
end
edgemask(:,:,1) = [1 -1; 1 -1];
edgemask(:,:,4) = [1 1; -1 -1];
edgemask(:,:,2) = [sqrt(2) 0; 0 -sqrt(2)];
edgemask(:,:,3) = [0 sqrt(2); -sqrt(2) 0];
edgemask(:,:,5) = [2 -2; -2 2];

TH = 100*ones(1,5);
edgedir = [{'0^o'} {'45^o'} {'-45^o'} {'90^o'} {'iso'}];
for i = 1:5
    gradient = filter2(edgemask(:,:,i), lum, 'same');
    edgehist(i) = sum(abs(gradient(:))>TH(i));
    if DEBUG
        subplot(2,3,i+1);            
        imshow(abs(gradient)>TH(i));
        title([edgedir{i} ' edge #: ' num2str(edgehist(i))]);
    end    
end

edgehist = edgehist/numel(imgsize);