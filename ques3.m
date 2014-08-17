close all;
clear;
clc;

% Create an array with the data files
dataFileArray = {
    'Data\ques_3_5.data' [0 0];
    };

% Determine how many data files we have
dataFiles = size(dataFileArray,1);

% Do some processing
for i=1:dataFiles
    % Get the data
    rawData = getData(dataFileArray{i,1}, dataFileArray{i,2});
    
    % Put raw data through a band pass filter
    data = filterData(rawData, 20, 250);
    % For a proper comparison put the raw data through a low pass
    rawData = filterData(rawData, 0, 250);
    
    % Calculate the power spectrum
    % Using default values for everything except the sampling frequency
    [pSpec, f] = pwelch(data,[],[],[],960);
    [pSpecRaw, fRaw] = pwelch(rawData,[],[],[],960);
    
    centFreq = sum(f.*pSpec)/sum(pSpec);
    centFreqRaw = sum(fRaw.*pSpecRaw)/sum(pSpecRaw);
    display(['Centroid Freq (Filtered): ' num2str(centFreq)]);
    display(['Centroid Freq (Raw): ' num2str(centFreqRaw)]);
    
    % Plot data files
    figure;
    yMax = max([max(abs(data(:,1))) max(abs(rawData(:,1)))]);
    
    subplot(2,1,1);
    plot(rawData(:,2),rawData(:,1));
    xlim([0 max(rawData(:,2))]);
    ylim([-yMax yMax]);
    title('Motion artefacts - Raw EMG');
    ylabel('Amplitude (\muV)');
    xlabel('Time (s)');
    
    subplot(2,1,2);
    plot(data(:,2),data(:,1));
    xlim([0 max(data(:,2))]);
    ylim([-yMax yMax]);
    title('Motion artefacts - Filtered EMG');
    ylabel('Amplitude (\muV)');
    xlabel('Time (s)');
    
    figure;
    yMax = 1500;%max([max(pSpec) max(pSpecRaw)]);
    
    subplot(2,1,1);
    plot(fRaw, pSpecRaw);
    title('Power Spectrum - Raw EMG');
    ylabel('Power (power/Hz)');
    xlabel('Frequency (Hz)');
    xlim([0 250]);
    ylim([0 yMax]);
    text(3/5*250, 2/3*yMax, {'Centroid Frequency: '; ...
        ['  ' num2str(centFreqRaw) 'Hz']});
    
    subplot(2,1,2);
    plot(f, pSpec);
    title('Power Spectrum - Filtered EMG');
    ylabel('Power (power/Hz)');
    xlabel('Frequency (Hz)');
    xlim([0 250]);
    ylim([0 yMax]);
    text(3/5*250, 2/3*yMax, {'Centroid Frequency: '; ...
        ['  ' num2str(centFreq) 'Hz']});
end