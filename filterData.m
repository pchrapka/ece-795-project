function [ data ] = filterData( rawData, lowerCutoff, upperCutoff )
%filterData Puts the raw EMG data through a band pass filter
%   Returns a filtered EMG signal. The band pass filter ranges from 
%   lowerCutoff Hz to upperCutoff Hz. rawData must be in the format 
%   returned from getData

samplingRate = 960; %Hz
% lowerCutoff = 20; %Hz
% upperCutoff = 250; %Hz

numCoefs = 60;
rollOff = 100; %dB

if(lowerCutoff == 0)
    % Low pass
    Wn = upperCutoff/(samplingRate/2);
    filterCoefs = fir1(numCoefs, Wn, 'low', chebwin(numCoefs+1,rollOff));
else
    % Band pass
    Wn = [lowerCutoff/(samplingRate/2) upperCutoff/(samplingRate/2)];
    filterCoefs = fir1(numCoefs, Wn, chebwin(numCoefs+1,rollOff));
end

data(:,1) = filter(filterCoefs,1,rawData(:,1));
data(:,2) = rawData(:,2);

end

