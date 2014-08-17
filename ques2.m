close all;
clear;
clc;

gripLength = 2.4;

% Create an array with the data files
dataFileArray = {
    'Data\ques_2_5_125.data' [0 5] 1.25*gripLength;
    'Data\ques_2_5_15.data' [0 5] 1.5*gripLength;
    'Data\ques_2_5_175.data' [1 6] 1.75*gripLength;
    'Data\ques_2_5_2.data' [0 5] 2*gripLength;
    'Data\ques_2_5_25.data' [1 6] 2.5*gripLength
    };

% Determine how many data files we have
dataFiles = size(dataFileArray,1);

% Initialize centroid frequency and rms vector
centFreq = zeros(dataFiles,2);
rms = zeros(dataFiles,2);

% Do some processing
for i=1:dataFiles
    % Get the data
    rawData = getData(dataFileArray{i,1}, dataFileArray{i,2});

    % Put raw data through a band pass filter
    data = filterData(rawData, 20, 250);

    % Calculate the RMS value
    dataLength = size(data,1);
    rms(i,1) = norm(data)/sqrt(dataLength);
    rms(i,2) = dataFileArray{i,3};
    display(['RMS: ' num2str(rms(i,1))]);
    
    % Calculate the power spectrum
    % Using default values for everything except the sampling frequency
    [pSpec, f] = pwelch(data,[],[],[],960);
    
    % Calculate the centroid frequency
    centFreq(i,1) = sum(f.*pSpec)/sum(pSpec);
    centFreq(i,2) = dataFileArray{i,3};
    display(['Centroid Freq: ' num2str(centFreq(i,1))]);
    
    % Plot data files
    figure;
    
    subplot(1,2,1);
    plot(data(:,2),data(:,1));
    ylim([-700 700]);
    xlim([0 max(data(:,2))]);
    title(['EMG - Electrode Distance: ' num2str(dataFileArray{i,3}) ' mm']);
    ylabel('Amplitude (\muV)');
    xlabel('Time (s)');
    
    subplot(1,2,2);
    plot(f, pSpec);
    title('Power Spectrum');
    ylabel('Power (power/Hz)');
    xlabel('Frequency (Hz)');
    xlim([0 250]);
    ylim([0 500]);
end

figure;

subplot(1,2,1);
plot(rms(:,2), rms(:,1),'-s','MarkerSize',10);
title('RMS vs Electrode Distance');
xlabel('Electrode Distance (mm)');
ylabel('RMS Amplitude');

subplot(1,2,2);
plot(centFreq(:,2), centFreq(:,1),'-s','MarkerSize',10);
title('Centroid Frequency vs Electrode Distance');
xlabel('Electrode Distance (mm)');
ylabel('Centroid Frequency (Hz)');

