close all;
clear;
clc;

% Create a variable for the data file
dataFile = 'Data\ques_4_15_90.data';
samplingRate = 960;

% Get all the data first
data = getData(dataFile, [0 0]);
% Figure how much data we have
dataLength = size(data,1);
display(['Data length: ' num2str(dataLength) ' data points']);
display(['             ' num2str(dataLength/samplingRate) ' seconds']);

% Put raw data through a band pass filter
data = filterData(data, 20, 250);
% Plot all of the data
figure;
plot(data(:,2),data(:,1));
title('EMG signal during fatigue');
xlabel('Time (s)');
ylabel('Amplitude (\muV)');
xlim([0 max(data(:,2))]);
yMax = max(data(:,1));
ylim([-yMax yMax]);

% Epoch length
epochLength = 5;
% Determine number of epochs
segments = floor((dataLength/samplingRate)/epochLength);
display(['Data separated into ' num2str(segments) ' '...
    num2str(epochLength) 's epochs']);

% Set range of data
startTime = 0;
endTime = epochLength;

% Initialize centroid frequency vector
centFreq = zeros(segments,1);

% Do some processing
for i=1:segments
    % Get the data
    rawData = getData(dataFile, [startTime endTime]);

    % Put raw data through a band pass filter
    data = filterData(rawData, 20, 250);
    
    % Calculate the power spectrum
    % Using default values for everything except the sampling frequency
    [pSpec, f] = pwelch(data,[],[],[],960);
    
    % Calculate the centroid frequency
    centFreq(i,1) = sum(f.*pSpec)/sum(pSpec);
    
    % Plot data files
    figure;
    subplot(1,2,1);
    plot(data(:,2),data(:,1));
    xlim([0 max(data(:,2))]);
%     ylim([0 3000]);
    title('Fatigue - Raw EMG');
    ylabel('Amplitude (\muV)');
    xlabel('Time (s)');
    
    subplot(1,2,2);
    plot(f, pSpec);
    title('Power Spectrum');
    ylabel('Power (power/Hz)');
    xlabel('Frequency (Hz)');
    xlim([0 250]);
    ylim([0 1500]);
    text(2/5*250, 5/6*1500, {'Centroid Frequency: '; ...
        ['  ' num2str(centFreq(i,1)) 'Hz']});
    
    % Set range of data
    startTime = endTime;
    endTime = startTime + epochLength;
end

figure;
plot(centFreq);
title('Effects of Fatigue');
ylabel('Centroid Frequency (Hz)');
xlabel([num2str(epochLength) 's Epochs']);