clear all;
clc;

hdc;


numActivities = 17;
D = [10000];
MAXL = 30;
compareAngle = 0.5;

for maxCounter = 1:length(D)
    avgPrecision = 0;
    avgRecall = 0;
    
    % (1,2) --> 4
    trainfoldernames = ['data1';'data2'];
    [CiM,iMjoints,iMaxis] = initItemMemories (D(maxCounter), MAXL);
    %disp('initItemMemories done');
    AM = hdcTrain(trainfoldernames,CiM,iMjoints,iMaxis,MAXL,D(maxCounter),numActivities);
    %disp('hdc training done');

    testfoldernames = ['data4'];
    %disp(testfoldernames);
    [precision,recall] = hdcResult(AM,testfoldernames,CiM,iMjoints,iMaxis,MAXL,D(maxCounter),compareAngle);

    counter = 0;
    tmp = 0;
    for i = 1:length(precision)
        if((i == 1 || i == 2 || i == 3 || i == 4 || i == 5 || i == 6 || i == 9 || i == 10 || i == 11 || i == 12 || i == 16) && isnan(precision(:,i)) == 0)
            counter = counter+1;
            tmp = tmp + precision(:,i);
        end
    end
    avgPrecision = avgPrecision + tmp/counter;

    counter = 0;
    tmp = 0;
    for i = 1:length(recall)
        if((i == 1 || i == 2 || i == 3 || i == 4 || i == 5 || i == 6 || i == 9 || i == 10 || i == 11 || i == 12 || i == 16) && isnan(precision(:,i)) == 0)
            counter = counter+1;
            tmp = tmp + recall(:,i);
        end
    end
    avgRecall = avgRecall + tmp/counter;
    disp('One done');
    
    % Display
    disp(['Precision for ',num2str(D(maxCounter)),' is ',num2str(avgPrecision)]);
    disp(['Recall for ',num2str(D(maxCounter)),' is ',num2str(avgRecall)]);
    
%     avgPrecision = 0;
%     avgRecall = 0;
%     
%     % (1,4) --> 2
%     trainfoldernames = ['data1';'data4'];
%     [CiM,iMjoints,iMaxis] = initItemMemories (D(maxCounter), MAXL);
%     %disp('initItemMemories done');
%     AM = hdcTrain(trainfoldernames,CiM,iMjoints,iMaxis,MAXL,D(maxCounter),numActivities);
%     %disp('hdc training done');
% 
%     testfoldernames = ['data2'];
%     %disp(testfoldernames);
%     
%     [precision,recall] = hdcResult(AM,testfoldernames,CiM,iMjoints,iMaxis,MAXL,D(maxCounter),compareAngle);
% 
%     counter = 0;
%     tmp = 0;
%     for i = 1:length(precision)
%         if((i == 1 || i == 2 || i == 3 || i == 4 || i == 5 || i == 6 || i == 9 || i == 10 || i == 11 || i == 12 || i == 16) && isnan(precision(:,i)) == 0)
%             counter = counter+1;
%             tmp = tmp + precision(:,i);
%         end
%     end
%     avgPrecision = avgPrecision + tmp/counter;
% 
%     counter = 0;
%     tmp = 0;
%     for i = 1:length(recall)
%         if((i == 1 || i == 2 || i == 3 || i == 4 || i == 5 || i == 6 || i == 9 || i == 10 || i == 11 || i == 12 || i == 16) && isnan(precision(:,i)) == 0)
%             counter = counter+1;
%             tmp = tmp + recall(:,i);
%         end
%     end
%     avgRecall = avgRecall + tmp/counter;
%     disp('Two done');
%     
%     % Display
%     disp(['Precision for ',num2str(D(maxCounter)),' is ',num2str(avgPrecision)]);
%     disp(['Recall for ',num2str(D(maxCounter)),' is ',num2str(avgRecall)]);
%     
%     avgPrecision = 0;
%     avgRecall = 0;
%     
%     % (2,4) --> 1
%     trainfoldernames = ['data2';'data4'];
%     [CiM,iMjoints,iMaxis] = initItemMemories (D(maxCounter), MAXL);
%     %disp('initItemMemories done');
%     AM = hdcTrain(trainfoldernames,CiM,iMjoints,iMaxis,MAXL,D(maxCounter),numActivities);
%     %disp('hdc training done');
% 
%     testfoldernames = ['data1'];
%     %disp(testfoldernames);
%     
%     [precision,recall] = hdcResult(AM,testfoldernames,CiM,iMjoints,iMaxis,MAXL,D(maxCounter),compareAngle);
%     
% 
%     counter = 0;
%     tmp = 0;
%     for i = 1:length(precision)
%         if((i == 1 || i == 2 || i == 3 || i == 4 || i == 5 || i == 6 || i == 9 || i == 10 || i == 11 || i == 12 || i == 16) && isnan(precision(:,i)) == 0)
%             counter = counter+1;
%             tmp = tmp + precision(:,i);
%         end
%     end
%     avgPrecision = avgPrecision + tmp/counter;
% 
%     counter = 0;
%     tmp = 0;
%     for i = 1:length(recall)
%         if((i == 1 || i == 2 || i == 3 || i == 4 || i == 5 || i == 6 || i == 9 || i == 10 || i == 11 || i == 12 || i == 16) && isnan(precision(:,i)) == 0)
%             counter = counter+1;
%             tmp = tmp + recall(:,i);
%         end
%     end
%     avgRecall = avgRecall + tmp/counter;
%     disp('Three done');
%     
%     % Display
%     disp(['Precision for ',num2str(D(maxCounter)),' is ',num2str(avgPrecision)]);
%     disp(['Recall for ',num2str(D(maxCounter)),' is ',num2str(avgRecall)]);
    
end

% % Display
% avgRecall = avgRecall + tmp/counter;
% disp('precision is:')
% avgPrecision/15
% disp('recall is:')
% avgRecall/15