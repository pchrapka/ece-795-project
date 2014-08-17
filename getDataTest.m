clear;
clc;
close all;

dataFileArray = {
    'Data\ques_3_5.data' [0 0]; 
    'Data\ques_2_5_15.data' [0 0];
    'Data\ques_2_5_175.data' [0 5]
    };
%dataFileArray{3,2}

showFileNo = 1;

data = getData(dataFileArray{showFileNo,1}, dataFileArray{showFileNo,2});
figure;
plot(data(:,2),data(:,1));

% data = getData(dataFileArray{1,1}, [0 0]);
% figure;
% plot(data(:,2),data(:,1));