% Spring 2012, 18-551 Project
% Classification Script

function [answer predLabel] = capstoneClassify(chars, labels, reducFact, nVecs, model, rowDiv, colDiv)

if (isempty(chars)) 
    answer = [];
    return
end
dim = numel(chars{1}) * reducFact * reducFact;
dim = dim + 256; % for projections
dim = 64;
dataInput = zeros(length(chars), dim);

dataIndex = 0;
for i = 1:length(chars)
    dataIndex = dataIndex + 1;
%     thumbnail = imresize(chars{i}, reducFact);
%     vec = getCompositeFeature(chars{i});
%     dataInput(dataIndex, :) = [reshape(thumbnail, 1, dim-256) vec];
%         dataInput(dataIndex, :) = getCompositeFeature(char{i});
        dataInput(dataIndex, :) = getSkeletonZoneFeature(chars{i}, rowDiv, colDiv);
end

dataInput = dataInput * nVecs;
dataInput = (dataInput - repmat(min(dataInput,[],1),size(dataInput,1),1))*spdiags(1./(max(dataInput,[],1)-min(dataInput,[],1))',0,size(dataInput,2),size(dataInput,2));

% Running the svm
testLabels = randi(100, length(chars), 1); % Does not matter
[predLabel accuracy ~] = svmpredict(testLabels, dataInput, model);

answer = zeros(1, length(chars));
for i = 1:length(predLabel)
    answer(i) = labels(predLabel(i));
end
end