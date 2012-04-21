% Spring 2012, 18-551 Project
% James Chun, jtchun@andrew.cmu.edu
% Training Script - libsvm

clear all;
load FntData;
load FntDataNoisy;
load rawData;

labels = 0:2; % Actual label vector
numTrainingSamplesPerChar = 100;

% Implementing Zoning
colDiv = 4;
rowDiv = 4;
n = colDiv * rowDiv; % Feature
n = 32;
m = length(labels);  % Num Classes;

% Preprocessing data
minNumTrainingSamplesPerChar = 0;
if (numTrainingSamplesPerChar < minNumTrainingSamplesPerChar)
    numTrainingSamplesPerChar = minNumTrainingSamplesPerChar;
end

% Generating labels
trainingLabels = ones(numTrainingSamplesPerChar * m, 1);
for i = 1:m
    trainingLabels((i-1)*numTrainingSamplesPerChar+1:i*numTrainingSamplesPerChar) = i*ones(numTrainingSamplesPerChar, 1);
end

% % Generating Data
% dataIndex = 0;
% trainingData = ones(numTrainingSamplesPerChar * m, n);
% for i = 1:m
%     
%     % Noisy Images
%     char = imgDataTestNoisy{i};
%     for j = 1:minNumTrainingSamplesPerChar
%         dataIndex = dataIndex + 1;
%         img = char{end - j};
%         featureVec = getSkeletonZoneFeature(img, rowDiv, colDiv);
%         trainingData(dataIndex, :) = featureVec;
%     end
%     
%     % Clean Images
%     char = imgDataTrain{i};
%     for j = 1:numTrainingSamplesPerChar-minNumTrainingSamplesPerChar
%         dataIndex = dataIndex + 1;
%         img = char{j};
%         featureVec = getSkeletonZoneFeature(img, rowDiv, colDiv);
%         trainingData(dataIndex, :) = featureVec;
%     end
% end

% Generating Data and Reducing Dimensions
reducFact = 0.125; % Reduction factor
[trainingData nVecs cummulVar] = dimRed(imgDataRawTrain, n, numTrainingSamplesPerChar, m, reducFact, minNumTrainingSamplesPerChar, imgDataTestNoisy, rowDiv, colDiv);

% Normalizing Features
trainingData = (trainingData - repmat(min(trainingData,[],1),size(trainingData,1),1))*spdiags(1./(max(trainingData,[],1)-min(trainingData,[],1))',0,size(trainingData,2),size(trainingData,2));

% Code to find params
bestcv = 0;
for log2c = -1.1:3.3,
  for log2g = -4.1:1.1,
    cmd = ['-t 0 -v 2 -c ', num2str(2^log2c), ' -g ', num2str(2^log2g)];
    cv = svmtrain(trainingLabels, trainingData, cmd);
    if (cv >= bestcv),
      bestcv = cv; bestc = 2^log2c; bestg = 2^log2g;
    end
    %fprintf('%g %g %g (best c=%g, g=%g, rate=%g)\n', log2c, log2g, cv, bestc, bestg, bestcv);
  end
end

% Training SVM
cmd = ['-t 2 -c ', num2str(bestc), ' -g ', num2str(bestg)];
model = svmtrain(trainingLabels, trainingData, cmd);
clearvars -except model imgDataRawTrain imgDataRawTest imgDataTrain imgDataTest imgDataTestNoisy labels m n rowDiv colDiv trainingLabels trainingData nVecs varCap reducFact cummulVar;
save svmTrainLibSVM.mat;
