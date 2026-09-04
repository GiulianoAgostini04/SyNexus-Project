%% Neccesary script to convert the OpenBCI trial files into a usable version for EEGLAB

% Opening of the .txt file that contains the RAW data recorded with
% OpenBCI GUI
[fileName, fileDirectory] = uigetfile({'*.txt','Text Files (*.txt)'; '*.*','All Files (*.*)'});

% Saving the Directory of the .txt file
directoryElements = strsplit(string(fileDirectory),'\');
currentAnalysedTrial = directoryElements{end-1};
analisedTrialElements = strsplit(currentAnalysedTrial,'_');

% Saving the subject code and general info
subject = analisedTrialElements{2};
numberOfTrial = analisedTrialElements{3};

% Creation of variables that contain the table values
dataMatrix = readmatrix(fullfile(fileDirectory, fileName));

% Reading the .xlsx file that contains the info about the specifc Trial
infoFileName = strcat(subject,'_',numberOfTrial,'_InfoTrial.xlsx');
infoFilePath = fullfile(fileDirectory, infoFileName);
infoTable = readtable(infoFilePath, 'ReadVariableNames', false);
infoMatrix = readcell(infoFilePath);
dimInfoMatrix = size(infoMatrix);

% Reading the content of the .xlsx file and saving the info for the
% next processing process
channelVector = zeros(dimInfoMatrix(1),1);
for rowInfoMatrix = 1:dimInfoMatrix(1)
    if strcmp(infoTable{rowInfoMatrix, 2},'ON')
        channelVector(rowInfoMatrix) = 1;
    end
end

% Extracting the valid measurement vector from the data table based on
% the active channels
validDataMatrix = [];
for channel = 1:length(channelVector)
    if channelVector(channel) == 1
        currentValidVector = dataMatrix(:,channel+1);
        validDataMatrix = [validDataMatrix, currentValidVector];
    end
end

eegData = validDataMatrix';

eeglab
