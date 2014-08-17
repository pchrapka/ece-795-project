clear;
clc;
close all;

dataFileArray = {
    'Data\ques_1_5_60.data' [0 0]; %1
    'Data\ques_1_5_90.data' [0 0]; %2
    'Data\ques_1_5_120.data' [0 0]; %3
    'Data\ques_1_5_135.data' [0 0];  %4
    'Data\ques_1_5_150.data' [0 0];  %5
    'Data\ques_2_5_125.data' [0 0]; %6
    'Data\ques_2_5_15.data' [0 0];  %7
    'Data\ques_2_5_175.data' [0 0]; %8
    'Data\ques_2_5_2.data' [0 0];   %9
    'Data\ques_2_5_25.data' [0 0];  %10
    'Data\ques_3_5.data' [0 0];     %11
    'Data\ques_3_5_fast.data' [0 0];%12
    'Data\ques_4_15_90.data' [0 0]  %13
    };

% showFileNo = [6 7 8 9 10];
% showFileNo = [1 2 3 4 5];
showFileNo = [13];
files = size(showFileNo,2);

for i=1:files
    rawData = getData(dataFileArray{showFileNo(1,i),1}, dataFileArray{showFileNo(1,i),2});
    data = filterData(rawData, 20, 250);
    figure;
    subplot(2,1,1);
    plot(data(:,2),data(:,1));
    title([dataFileArray{showFileNo(1,i),1} ' Filtered']);
%     ylim([-500 500]);
    subplot(2,1,2);
    plot(rawData(:,2),rawData(:,1));
    title([dataFileArray{showFileNo(1,i),1} ' Raw']);
%     ylim([-500 500]);
end