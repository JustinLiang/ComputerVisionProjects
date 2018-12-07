% Extract the laser ring of a specific color form an image
function ExtractColorByHSV()
    color = 'red';
    close all;  % Close figures

    % Change the current folder to the folder of this m-file.
    % Courtesy of Brett Shoelson
    if(~isdeployed)
      cd(fileparts(which(mfilename)));
    end
        
    im = imread('Test_Photos\color_wheel.jpg');
    
    hsvIm = rgb2hsv(im);    % Convert RGB to HSV
    hIm = hsvIm(:,:,1); % Get the hue
    sIm = hsvIm(:,:,2); % Get the saturation
    vIm = hsvIm(:,:,3); % Get the value
    
    % Plot original image
    subplot(3,3,1);
    imshow(im);
    title('Original Image');
    
    % Plot the HSV images
    subplot(3,3,4);
    imshow(hIm);
    title('Hue Image');
    subplot(3,3,5);
    imshow(sIm);
    title('Saturation Image');
    subplot(3,3,6);
    imshow(vIm);
    title('Value Image');
    
    % Plot the HSV values
    subplot(3,3,7);
    imhist(hIm);
    title('Hue Dist');
    subplot(3,3,8);
    imhist(sIm);
    title('Saturation Dist');
    subplot(3,3,9);
    imhist(vIm);
    title('Value Dist');
    
    mask = ApplyHsvThresholds(hIm,sIm,vIm,color);
    
    % Plot original image
    subplot(3,3,2);
    imshow(mask);
    title('Processed Image');
    
    imwrite(mask, 'processed_image.jpg');
end


function mask = ApplyHsvThresholds(hIm,sIm,vIm,color)
    % Get h, s, v masks
    [hLow, hHigh, sLow, sHigh, ...
        vLow, vHigh] = GetThresholds(color);

    mask = ((sIm > sLow) & (sIm < sHigh))...
        & ((vIm > vLow) & (vIm < vHigh));
    % Apply masks (use bitwise AND if continuous or bitwise OR if discontinuous)
    if (hLow>hHigh)
        mask = mask & ((hIm > hLow) | (hIm < hHigh));
    else
        mask = mask & ((hIm > hLow) & (hIm < hHigh));
    end
end

% GetThresholdValues - Gets the threshold values for the different colors
function [hThresholdLow, hThresholdHigh, sThresholdLow, sThresholdHigh, ... 
        vThresholdLow, vThresholdHigh]  = GetThresholds(color)

    % Hue, saturation, value thresholds
    switch color
        case 'red' % Red is discontinuous, swap low and high thresholds
            hThresholdLow = 350/360; % Cool red
            hThresholdHigh = 19/360; % Warm red
			sThresholdLow = 0.05;
			sThresholdHigh = 1;
			vThresholdLow = 0;    
			vThresholdHigh = 1;   
        case 'green'
            hThresholdLow = 70/360;
			hThresholdHigh = 180/360;
			sThresholdLow = 0.4;
			sThresholdHigh = 1;
			vThresholdLow = 0.3;    % 30%
			vThresholdHigh = 0.6;   % 60%
        otherwise  
            warndlg('Invalid color');
    end
    
end