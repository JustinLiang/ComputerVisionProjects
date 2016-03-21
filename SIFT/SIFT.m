% Perform edge detection with interpolation during non maximum suppression
function CannyEdgeDetector()
    close all;  % Close figures
    OCTAVES = 3;
    
    % Change the current folder to the folder of this m-file.
    % Courtesy of Brett Shoelson
    if(~isdeployed)
      cd(fileparts(which(mfilename)));
    end
    
    im = imread('Test_Photos\box.jpg');
    figure; imshow(im);
    title('Original Image');
    
    pyramid = MakePyramid(im,OCTAVES);
    ShowPyramid(pyramid);
    
    pyramid = ComputeDifferenceOfGaussian(pyramid);
    ShowPyramid(pyramid);
    
    localExtrema = DetectLocalExtrema(pyramid);
    test = 5;
end
