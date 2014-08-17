close all;
clear;
clc;

endTime = 10;

% Create an array with the data files
dataFileArray = {
    'Data\ques_1_5_60.data' [0 endTime] 60;
    'Data\ques_1_5_90.data' [0 endTime] 90;
    'Data\ques_1_5_120.data' [0 endTime] 120;
    'Data\ques_1_5_135.data' [0 endTime] 135;
    'Data\ques_1_5_150.data' [0 endTime] 150
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
    title(['EMG - Joint Angle: ' num2str(dataFileArray{i,3}) '{\circ}']);
    ylabel('Amplitude (\muV)');
    xlabel('Time (s)');
    
    subplot(1,2,2);
    plot(f, pSpec);
    ylabel('Power (power/Hz)');
    xlabel('Frequency (Hz)');
    title('Power spectrum');
    xlim([0 250]);
    ylim([0 200]);
end

figure;

subplot(1,2,1);
plot(rms(:,2), rms(:,1),'-s','MarkerSize',10);
title('RMS vs Joint Angle');
xlabel('Joint Angle (\circ)');
ylabel('RMS Amplitude');

subplot(1,2,2);
plot(centFreq(:,2), centFreq(:,1),'-s','MarkerSize',10);
title('Centroid Frequency vs Joint Angle');
xlabel('Joint Angle (\circ)');
ylabel('Centroid Frequency (Hz)');