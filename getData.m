function data = getData(dataFile, timeRange)
%getData Functions gets EMG data from the dataFile
% getData(dataFile) returns a [N,2] matrix with the EMG data contained in
% dataFile. The first column contains the Raw EMG amplitude. The second
% column contains the time data points. 
% timeRange is specified as [startTime endTime] which specifies the 
% range of data to return in seconds. The range includes startTime but does 
% not include endTime. To get all the data, set startTime and endTime to 0

% Sampling rate in Hz
samplingRate = 960;
% Determine how much data to return
startTime = timeRange(1,1);
endTime = timeRange(1,2);

% Check the parameters
if(endTime <= startTime)
    if(endTime ~= 0 && startTime ~= 0) 
        display('Bad time range:');
        display(['\tStart time: ' num2str(startTime)]);
        display(['\tEnd time: ' num2str(endTime)]);
        return;
    end
end

% Check if the dataFile is in a cell array
if(iscellstr(dataFile))
    dataFile = char(dataFile);
    display(['Should not be a cell array!! Importing ' dataFile]);
else
    display(['Importing ' dataFile]);
end
% Import the data file
data = importdata(dataFile);
% Remove the columns of data we don't need
data = data(:,1);

% Remove the first second (960 samples) because of some weird flat line at
% 600 ms
data(1:1*samplingRate) = [];

% Determine the data length
dataLength = size(data,1);

% Check if we want all of the data
if(endTime ~= 0) 
    % Check if we have enough data to return
    if(endTime*samplingRate > dataLength)
        display('Not enough data:');
        display(['\tEnd time: ' num2str(endTime)]);
        display(['\tData length: ' num2str(dataLength/samplingRate)]);
        return;
    end
    if(startTime ~= 0)
        % Remove the first bit of data that's not needed
        data(1:samplingRate*startTime) = [];
        % Recalculate the data length
        dataLength = size(data,1);
    end
    % Remove the stuff at the end
    data(samplingRate*(endTime-startTime)+1:dataLength) = [];
    % Recalculate the data length
    dataLength = size(data,1);
end
% Otherwise do nothing

% Create a column vector with the appropriate time data and add it to the
% data vector
data(:,2) = 0:(1/samplingRate):((dataLength-1)/samplingRate);

% plot(data(:,2),data(:,1));
end