function T = loadData(databasePath, isDatabase)
%loadData - Load data from database
%
% Syntax: loadData(databasePath)
% databasePath: A directory contains \sketches and
% \photos.
    if nargin == 1
        isDatabase = true;
    end

    if isDatabase
        sketchPath = fullfile(databasePath, 'sketches');
        galleryPath = fullfile(databasePath, 'photos');
        galleryFiles = dir(fullfile(galleryPath,'*.jpg'));
        garlleryExample = imread(fullfile(galleryPath, galleryFiles(1).name));
        sketchExample = imread(fullfile(sketchPath, ganame2skname(galleryFiles(1).name)));
        datasize = length(galleryFiles);

        galleryset = uint8(zeros(size(garlleryExample, 1), ...
                            size(garlleryExample, 2), ...
                            datasize));
        sketchset = uint8(zeros(size(sketchExample, 1), ...
                    size(sketchExample, 2), ...
                    datasize));

        for i = 1 : datasize
            filename = galleryFiles(i).name;
            galleryset(:,:,i) = rgb2gray(imread(fullfile(galleryPath,filename)));

            sketchimg = imread(fullfile(sketchPath,ganame2skname(filename)));
            if size(sketchimg, 3) ~= 1
                sketchset(:,:,i) = rgb2gray(sketchimg);
            else
                sketchset(:,:,i) = sketchimg;
            end
        end

        T = uint8(zeros(250,200,datasize * 2));

        T(:,:,1:2:end) = sketchset;
        T(:,:,2:2:end) = galleryset;

        return;
    end
    
    if ~isDatabase
        galleryFiles = dir(fullfile(databasePath,'*.jpg'));
        garlleryExample = imread(fullfile(databasePath, galleryFiles(1).name));
        datasize = length(galleryFiles);
        
        T = uint8(zeros(size(garlleryExample, 1), ...
                            size(garlleryExample, 2), ...
                            datasize));
                        
        for k = 1 : datasize
            filename = galleryFiles(k).name;
            
            fileimg = imread(fullfile(databasePath,filename));
            if size(fileimg, 3) ~= 1
                T(:,:, k) = rgb2gray(fileimg);
            else
                T(:,:,k) = fileimg;
            end
        end
    end
end

%----------------------Subfunctions------------------%

function filename = ganame2skname(galleryFileName)
    % [~,filename,~] = fileparts(galleryFileName);
    % filename = strcat(filename, '-sz1.jpg');
    filename = galleryFileName;
end