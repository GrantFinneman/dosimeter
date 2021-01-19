%adds a constant to each channel in each run to make the smallest value zero

clear
numrun = 22;
runarray = cell(2,numrun);
runmin = zeros(1,44);
rectifier = importdata('C:\Users\User1\Documents\MATLAB\data from ohio\rectifier_lists\rectifiers.txt');

for i = 1:numrun % this puts all the runs in a single array with each run array in one cell    
    formatspec = 'R%d.txt';    
    filename = sprintf(formatspec,i);  % sprintf makes a character vector or string more efficiently than eval
    %disp(filename);
    a = importdata(filename); 
    b = a.data(:,6:end-1); % importing just the important number information
    runarray{2,2*i-1} = b; % assigning an entire run's worth of channel data to odd cells of runarray
    runarray{1,2*i-1}= sprintf('R%d',i); %naming the first row of runarray the name of the run
    formatspec = 'R%d.1.txt'; % this delineates the suffix of the filename to be R runnumber .1.txt as alex just put .1 after the number
    filename = sprintf(formatspec,i);
    %disp(filename);
    a = importdata(filename);
    b = a.data(:,6:end-1); % importing the relevant numbers
    runarray{2,2*i} = b; % assigning the run.#.1 variants to the even cells
    runarray{1,2*i} = sprintf('R%d.1',i); % naming the even cells in row one the name of the run
end
%=====================================================================================================================================
figurearray = cell(1,45);  % length(runarray)-2);
figurearray2 = figurearray;
normalized_runarray = runarray; % normalized_runarray is equal to runarray execpt for the last two entries as they are empty
%===========================================================================================================================================
for i = 1:length(runarray)-2 % the minus two is here becuse the last two runs 22 and 22.1 are both empty
    runarray{2,i} = runarray{2,i}-min(min(runarray{2,i})); % takes the matrix in each cell of runarray, finds the minimum value of the entire matrix and adds the positive to the entire matrix
    for k = 1:64
        normalized_runarray{2,i}(:,k) = (runarray{2,i}(:,k))*rectifier(k,1);
    end    
    figurearray{1,i} = reshape(mean(normalized_runarray{2,i}),8,8); % makes the Normalized Runs eight by eights
    figurearray2{1,i} = reshape(mean(runarray{2,i}),8,8); % makes the Translated Runs eight by eights
end
%======================================================================================================================================
% this is the figure generation section
runarray{2,end+1} = 0; % these serve to keep from throwing an error down the line while making three by three figure groups
runarray{2,end+2} = 0;
%gg = 4;
%if gg < 5;
index = 1;
%for q = 1:9

    %figure('name','Normalized Runs');
    for f = 1:length(figurearray)-1
    %figure('name','Normalized Runs'); % this names the figure according to their file name
        %for p = 1:9 %do not make it generate more than a handful of 3d barplots of millions of points each
            
            subplot(3,3,index) % makes a subplot grid of three by three and places the current plot on "square p"
            bar3(figurearray{1,f});
            title(runarray{1,f})
            colorbar
            
            
            if index == 9
                index = 0;
                figure('name','Normalized Runs');
            end
            index = index + 1;
        %end
        %saveas(gcf,sprintf('C:/Users/User1/Documents/MATLAB/data from ohio/run_figures/Normalized Runs %d',f),'svg');
        %savefig(sprintf('C:/Users/User1/Documents/MATLAB/data from ohio/run_figures/Normalized Runs %d',f));
    end
%end

index = 1;
    
% this is for making the six groups of figures with the unnormalized versions
for f = 1:length(figurearray2)
    %figure('name','Translated Runs');
        %for p = 1:9 %do not make it generate more than a handful 3d barplots of millions of points each
         subplot(3,3,index)
         bar3(figurearray2{1,f})
         title(runarray{1,f})
         colorbar
         
         if index == 9
                index = 0;
                figure('name','Translated Runs');
         end
            index = index + 1;
         
        %end
    %savefig(sprintf('C:/Users/User1/Documents/MATLAB/data from ohio/run_figures/Translated Runs %d',f));
    %saveas(gcf,sprintf('C:/Users/User1/Documents/MATLAB/data from ohio/run_figures/Translated Runs %d',f),'svg');
end


%end