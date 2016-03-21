% This function makes a pyramid of images
% Minsize dictates the minimum height or width of the smallest image
% in the template
function[pyramid] = MakePyramid(im, octaves)
    SCALE = 1.6;
    SCALES_PER_OCTAVE = 4;
    K = sqrt(2);
    RATIO = 0.5;

    im = imgaussfilt(im,0.5);   % Blur the image before doubling the size
    im = imresize(im, 2);   % Double the size of the image
    
    pyramid = {};    % Initialize cell array
        
    % Make a pyramid with a specified octave number
    for i=1:octaves
        for j=1:SCALES_PER_OCTAVE
            pyramid{i}{j} = imgaussfilt(im,SCALE*(K^(i-1+j)));
        end
        im = imresize(im, RATIO);
    end
end