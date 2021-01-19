% this will read and display each run with and without calibration coefficients
clear;
fileID = 'R4.txt';
a = importdata(fileID);
colhead = a.colheaders;

chdata = a.data(:,6:69);
%b = length(data(:,1));
chavg = zeros(1,64);

for i = 1:64
    a = chdata(:,i);
    chavg(1,i) = mean(a);
end

fileID = 'rectifiers.txt';
t = importdata(fileID);
rec = reshape(t,8,8);


b = reshape(chavg,8,8);

bar3(b.*rec)
%bar3(data(1:end,25:40))