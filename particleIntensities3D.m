function [output] = particleIntensities3D()
% Imports single ND2 file containing either 4 channels (Channel 1 = GFP, 
% Channel 2 = cmHALO(JF646), Channel 3 = Blank, Channel 4 = POM121-HALO(JF549). 
% Tif stack created for each channel. User will define channels using GUI. 
% User will manually identify each particle and the program will automatically
% extract pixel intensity values for each channel.
%
% If necessary, user can identify specific site number to be analyzed.
% Files with multiple time points can also be analyzed.


%Identify and import ND2 file
uiwait(msgbox('Please select ND2 file'));
[fileName,filePath] = uigetfile('*.nd2');
[~,BaseFilename] = fileparts(fileName);
cd(filePath);
mkdir(BaseFilename);

%BioFormats to import .nd2 files
OBJ = BioformatsImage(fileName);
numSlices = OBJ.sizeZ;
numTimePoints = OBJ.sizeT;

prompt={'Enter the POM121-HALO channel (1 - 4):',...
    'Enter primary channel for virus (e.g., GFP-CA) (1 - 4)','Enter secondary channel for virus (e.g., cmHALO) (1 - 4)','Enter the site number'};
name='';
numlines=1;
defaultanswer={'4','1','2','1'};
answer = inputdlg(prompt,name,numlines,defaultanswer);
nucleusChannel = str2double(answer{1,1});
particleChannelNumber = str2double(answer{2,1});
secondaryParticleChannelNumber = str2double(answer{3,1});
siteNumber = str2double(answer{4,1});

%Create separate tif stacks for each nd2 image
CH1tifStack = [BaseFilename,'\',BaseFilename,'Channel1.tif']; %Primary particle
CH2tifStack = [BaseFilename,'\',BaseFilename,'Channel2.tif']; %POM121-HALO
CH3tifStack = [BaseFilename,'\',BaseFilename,'Channel3.tif']; %Secondary particle

if exist(CH1tifStack,'file')
    delete(CH1tifStack);
end
if exist(CH2tifStack,'file')
    delete(CH2tifStack);
end
if exist(CH3tifStack,'file')
    delete(CH3tifStack);
end

for timei = 1:numTimePoints
    for slicei = 1:numSlices
        %I = GETPLANE(OBJ, ZPLANE, CHANNEL, TIME, SERIES)
        currentImage = getPlane(OBJ, slicei, particleChannelNumber, timei, siteNumber);
        imwrite(currentImage,[BaseFilename,'\',BaseFilename,'Channel1.tif'],'WriteMode','append','Compression','none');
        currentImage = getPlane(OBJ, slicei, nucleusChannel, timei, siteNumber);
        imwrite(currentImage,[BaseFilename,'\',BaseFilename,'Channel2.tif'],'WriteMode','append','Compression','none');
        currentImage = getPlane(OBJ, slicei, secondaryParticleChannelNumber, timei, siteNumber);
        imwrite(currentImage,[BaseFilename,'\',BaseFilename,'Channel3.tif'],'WriteMode','append','Compression','none');
    end
end
nucleusChannelTif = 2;
%pass nuclear speckles and primary particle channels to GUI
[output] = quantifyParticleIntensityGUI_App(nucleusChannelTif,numSlices,CH1tifStack,CH2tifStack,numTimePoints,CH3tifStack);
end

 