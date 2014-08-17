clear;
clc;
close all;

% Sampling rate in Hz
samplingRate = 960;

% Import the data file
data = importdata('Data\ques_2_5_25.data');
% Remove the data we don't need
data = data(:,1);

% Determine the data length
dataLength = size(data,1);

% Create a column vector with the appropriate times and add it to the data
% vector
data(:,2) = 0:(1/samplingRate):((dataLength-1)/samplingRate);

plot(data(:,2),data(:,1));