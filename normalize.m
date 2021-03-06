function imgSet = normalize(I, overlap, varargin)
    % Parse input arguments
    p = inputParser;
    p.CaseSensitive = false;
    addParameter(p,'iscut',true);
    parse(p,varargin{:});
    iscut = p.Results.iscut;


    %default parameters
    if nargin == 1
        overlap = 16;
    end
    
    if iscut
        imgSet = uint8(zeros(224,192));
    else
        imgSet = uint8(zeros(250,200));
    end
    
    for index = 1 : size(I, 3)
        img = I(:,:,index);
                
        if (size(img, 1) ~= 250 || size(img, 2) ~= 200)
            %% Rotate the image
            eyePosition = eyeDetection(I);
            
            dy = eyePosition(4) - eyePosition(2);
            dx = eyePosition(3) - eyePosition(1);
            angle = atan(dy/dx);
            rotateCenter = [(eyePosition(1)+eyePosition(3))/2,...
            (eyePosition(2) + eyePosition(4))/2];

            img = rotateAround(I, rotateCenter(1), rotateCenter(2), rad2deg(angle));

            %% Scaling the image
            eyePosition = eyeDetection(img);
            dy = eyePosition(4) - eyePosition(2);
            dx = eyePosition(3) - eyePosition(1);

            distance = sqrt(dx^2 + dy^2);
            scale= 75 / distance;
            img = imresize(img, scale);

            %% Cropping the image
            eyePosition = eyeDetection(img);
            eyeCenter = [(eyePosition(1)+eyePosition(3))/2,...
            (eyePosition(2) + eyePosition(4))/2];
            corner = [eyeCenter(1)-100,eyeCenter(2) - 115];
            img = imcrop(img, [corner(1), corner(2), 199, 249]);
        end
        %% Cut the image
        if iscut
            xmod = mod(size(img,1),2*overlap);
            ymod = mod(size(img,2),2*overlap);
            img = img(1:size(img,1)-xmod,1:size(img,2)-ymod);
        end
        imgSet(:,:,index) = img;
    end   
    
    

end