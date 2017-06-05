function message = hdc
  assignin('base','initItemMemories', @initItemMemories);
  assignin('base','genRandomHV', @genRandomHV);
  assignin('base','cosAngle', @cosAngle);
  assignin('base','getActivity', @getActivity);
  assignin('base','binarizeHV', @binarizeHV);
  assignin('base','hdcTrain', @hdcTrain);
  assignin('base','hdcPredict', @hdcPredict);
  assignin('base','hdcResult', @hdcResult);
  message='Importing all HD computing functions to workspace is done';
end

function [CiM, iMjoints, iMaxis] = initItemMemories (D, MAXL)
%
% DESCRIPTION   : initialize the item Memory  
%
% INPUTS:
%   D           : Dimension of vectors
%   MAXL        : Levels of discretization
% OUTPUTS:
%   iMjoints    : item memory for 14 joints
%   iMaxis      : item memory for 3 axis
%   CiM         : continious item memory for data from each joint and axis 
% MAXL = 30;

	CiM = containers.Map ('KeyType','double','ValueType','any');
	iMjoints  = containers.Map ('KeyType','double','ValueType','any');
    iMaxis  = containers.Map ('KeyType','double','ValueType','any');
    rng('default');
    rng(1);
        
	%init 14 orthogonal vectors for the 14 joints
	iMjoints(1) = genRandomHV (D);
	iMjoints(2) = genRandomHV (D);
	iMjoints(3) = genRandomHV (D);
	iMjoints(4) = genRandomHV (D);
    iMjoints(5) = genRandomHV (D);
    iMjoints(6) = genRandomHV (D);
    iMjoints(7) = genRandomHV (D);
    iMjoints(8) = genRandomHV (D);
    iMjoints(9) = genRandomHV (D);
    iMjoints(10) = genRandomHV (D);
    iMjoints(11) = genRandomHV (D);
    iMjoints(12) = genRandomHV (D);
    iMjoints(13) = genRandomHV (D);
    iMjoints(14) = genRandomHV (D);
    
    %init 3 orthogonal vectors for the 3 axis
    iMaxis(1) = genRandomHV (D);
	iMaxis(2) = genRandomHV (D);
	iMaxis(3) = genRandomHV (D);
    
    initHV = genRandomHV (D);
	currentHV = initHV;
	randomIndex = randperm (D);
	
    for i = 1:1:MAXL
        CiM(i) = currentHV;
		%D / 2 / MAXL = 166
        SP = floor(D/2/MAXL);
		startInx = (i*SP) + 1;
		endInx = ((i+1)*SP) + 1;
		currentHV (randomIndex(startInx : endInx)) = currentHV (randomIndex(startInx: endInx)) * -1;
    end
end

function randomHV = genRandomHV(D)
%
% DESCRIPTION   : generate a random vector with zero mean 
%
% INPUTS:
%   D           : Dimension of vectors
% OUTPUTS:
%   randomHV    : generated random vector

    if mod(D,2)
        disp ('Dimension is odd!!');
    else
        randomIndex = randperm (D);
        randomHV (randomIndex(1 : D/2)) = 1;
        randomHV (randomIndex(D/2+1 : D)) = -1;
    end
end

function cosAngle = cosAngle (u, v)
    cosAngle = dot(u,v)/(norm(u)*norm(v));
end

function [activityIDS,activityStrings] = getActivity(foldername)
%
% DESCRIPTION   : initialize the item Memory  
%
% INPUTS:
%   foldername        : 'data1' or 'data2' or 'data3' or 'data4'
% OUTPUTS:
%   activityIDS       : ['051017....';'051016....';...]
%   activityStrings   : ['still';'talking on the phone',...]
    try
        cd(foldername);
        flag = 1;
    catch
        %disp('some error in cd ');
        flag = 2;
    end
    [~,~,raw] = xlsread('activityLabel.csv');
    activityIDS = string(raw(1:length(raw)-1,1));
    activityStrings = string(raw(1:length(raw)-1,2));
    if flag == 1
        cd ..;
    else
        flag = -1;
        %disp('no need for cd ..');
    end
end

function v = binarizeHV (v)
	threshold = 0;
	for i = 1 : 1 : length (v)
		if v (i) > threshold
			v (i) = 1;
		else
			v (i) = -1;
		end
	end
end

function AM = hdcTrain(foldernames,CiM,iMjoints,iMaxis,MAXL,D,numActivities)
%
% DESCRIPTION   : initialize the item Memory  
%
% INPUTS:
% foldernames   : ['data1','data2',...]
%   CiM         : continious item memory for data from each joint and axis 
%   iMjoints    : item memory for 14 joints
%   iMaxis      : item memory for 3 axis
%   MAXL        : Levels of discretization
%   D           : Dimension of vectors
% numActivities : number of training activities
% OUTPUTS:
%   AM          : auto associative memory to store training hypervectors
    AM = containers.Map ('KeyType','double','ValueType','any');
    i = 1;
    while i <= numActivities
        tmp = zeros(1,D);
        for j = 1:length(foldernames(:,1))
            cd(foldernames(j,:));
            [activityIDS, ~] = getActivity(foldernames(j,:));
            filename = '0'+activityIDS(i) + '_features.csv';
            %disp(filename);
            M = csvread(filename);
            M = discretize(M,MAXL);
            for k = 1:length(M)
                for n = 1:length(M(1,:))
                    jointHDC = iMjoints(ceil(n/3));
                    if mod(n,3) == 0
                        axisHDC = iMaxis(3);
                    else
                        axisHDC = iMaxis(mod(n,3));
                    end
                    valueHDC = CiM(M(k,n));
                    tmp = tmp + (jointHDC.*axisHDC).*valueHDC;
                end
            end
            cd ..;
        end
        AM(i) = binarizeHV(tmp);
        i = i+1;
    end
end

function accuracy = hdcPredict(AM,foldernames,activityName,CiM,iMjoints,iMaxis,MAXL,D,similarActivityID)
    tmp = zeros(1,D);
    correct = 0;
    total = 0;
    for j = 1:length(foldernames(:,1))
        cd(foldernames(j,:));
        [activityIDS, activityStrings] = getActivity(foldernames(j,:));
        id = find(activityStrings == activityName);
        if(length(id) > 1)
            id = id(similarActivityID);
        end
        filename = '0'+activityIDS(id) + '_features.csv';
        disp(filename);
        M = csvread(filename);
        M = discretize(M,MAXL);
        for k = 1:length(M)
            %tmp = zeros(1,D);
            for n = 1:length(M(1,:))
                jointHDC = iMjoints(ceil(n/3));
                if mod(n,3) == 0
                    axisHDC = iMaxis(3);
                else
                    axisHDC = iMaxis(mod(n,3));
                end
                valueHDC = CiM(M(k,n));
                tmp = tmp + (jointHDC.*axisHDC).*valueHDC;
            end
            maxAngle = -1;
            predictedLabel = -1;
            for b = 1:length(AM)
                angle = cosAngle (AM(b), binarizeHV(tmp));
                if (angle > maxAngle)
                    maxAngle = angle;
                    predictedLabel = b;
                    if predictedLabel == id
                        correct = correct + 1;
                    end
                end
            end
        end
        total = total+length(M);
        cd ..;
    end
    accuracy = (correct/total)*100;
end

function [precision,recall] = hdcResult(AM,foldernames,CiM,iMjoints,iMaxis,MAXL,D,compareAngle)
    %predictedActivityCounter = zeros(1,17);
    %correctCounter = zeros(1,17);
    %totalCounter = zeros(1,17);
    TP = zeros(1,17);
    FN = zeros(1,17);
    FP = zeros(1,17);
    %tmp = zeros(1,D);
    for j = 1:length(foldernames(:,1))
        cd(foldernames(j,:));
        [activityIDS, ~] = getActivity(foldernames(j,:));
        for i = 1:length(activityIDS)
            disp(['Activity ID ',num2str(i)])
            disp('true positives')
            disp(TP)
            disp('false positives')
            disp(FP)
            if(i == 1 || i == 2 || i == 3 || i == 4 || i == 5 || i == 6 || i == 9 || i == 10 || i == 11 || i == 12 || i == 16)
                tmp = zeros(1,D);
                filename = '0'+activityIDS(i) + '_features.csv';
                %disp(filename);
                M = csvread(filename);
                M = discretize(M,MAXL);
                for k = 1:length(M)
                    %tmp = zeros(1,D);
                    for n = 1:length(M(1,:))
                        jointHDC = iMjoints(ceil(n/3));
                        if mod(n,3) == 0
                            axisHDC = iMaxis(3);
                        else
                            axisHDC = iMaxis(mod(n,3));
                        end
                        valueHDC = CiM(M(k,n));
                        tmp = tmp + (jointHDC.*axisHDC).*valueHDC;
                    end
                    maxAngle = compareAngle;
                    predictedLabel = -1;
                    for b = 1:length(AM)
                        if(b == 1 || b == 2 || b == 3 || b == 4 || b == 5 || b == 6 || b == 9 || b == 10 || b == 11 || b == 12 || b == 16)
                            angle = cosAngle (AM(b), binarizeHV(tmp));
                            if (angle > maxAngle)
                                maxAngle = angle;
                                predictedLabel = b;
                            end
                        end
                    end
                    %predictedActivityCounter(:,predictedLabel) = predictedActivityCounter(:,predictedLabel) + 1; 
                    if predictedLabel == i
                        TP(:,i) = TP(:,i)+1;
                        %correctCounter(:,i) = correctCounter(:,i) + 1;
                    else
                        FN(:,i) = FN(:,i)+1;
                        FP(:,predictedLabel) = FP(:,predictedLabel)+1; 
                    end
                end
                %totalCounter(:,i) = length(M);
            end
        end
        cd ..;
    end
    precision = TP./(TP+FP);
    recall = TP./(TP+FN);
    %a = correctCounter;
    %b = predictedActivityCounter;
    %c = totalCounter;
end




