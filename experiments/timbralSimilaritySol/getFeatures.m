function data = getFeatures(config, data, setting, step)

if length(data.mode)<size(data.features, 1)
 data.features(end, :) = []; % TODO fix this
end
if length(data.mode)<length(data.file)
 data.file(end) = []; % TODO fix this
end
 


switch setting.split
    case 'none'
        idx = 1:length(data.file);
    case 'octave'
        idx = octaveSelection(config, data);
    otherwise
        nbItems = length(data.mode);
        idx = randi(nbItems, ceil(nbItems*str2num(setting.split)/100), 1);
        if step==2 && setting.test
            idx = setdiff(1:nbItems, idx);
        end
end
data = filterData(data, idx);
% 
% switch setting.reference
%     case 'judgments'
%         idx = [];
%         gt = [];
%         d = load([config.codePath 'ticelJudgments.mat']);
%         for k=1:length(d.names)
%             oct = strfind(data.file, d.names{k});
%             oct = find(~cellfun(@isempty, oct));
%             idx = [idx oct];
%             gt = [gt repmat(d.ci(:, k), 1, length(oct))];
%         end
%         [idx, ia] = unique(idx);
%         data = filterData(data, idx);
%         data.judgments = gt(:, ia); %TODO fix this
% end
idx = removeLessThan(data, setting);
data = filterData(data, idx);
features = data.features;

switch setting.cut
    case 1
        switch setting.features
            case 'mfcc'
                features = features(:, 1:13);
            case 'scat'
                var=nanstd(features); % TODO remove ?
                var=var/(sum(var));
                [vars, I] = sort(var,2,'descend');
                features=features(:,I);
                sumvar=cumsum(vars);
                 ix=find(sumvar>.83,1);
                features=features(:,1:ix);
        end
end

switch setting.median
    case 1
        features = features./repmat(median(features,1),size(features, 1),1);
end

switch setting.compress
    case 1
        features=log1p(features/1e-3);
end

if ~isnan(setting.expand) && setting.expand
     features = expandFeatures(features, setting.expand);
end

switch setting.randomize
    case 1
     features = randn(size(features));
end

switch setting.standardize
    case 1
        features=bsxfun(@minus,features, mean(features));
        features=bsxfun(@rdivide,features, std(features));
end
data.features= features;

function idx = removeLessThan(data, setting)

[~, ~, gt] = unique(data.(setting.reference));

class = unique(gt);
nbPerClass = hist(gt, class);

class = class(nbPerClass>setting.neighbors);
idx=zeros(1, length(gt));
for k=1:length(class)
    idx(class(k)==gt)=1;
end
idx = find(idx);



function features = expandFeatures(features, n)

ref = features;
ex = features;
while size(features, 2) < n
   for k=1:size(ref, 2)
       for m=1:size(ex, 2)
          nex(:, (k-1)*size(ex, 2)+m) = ex(:, m).*ref(:, k); 
       end
   end
   features = [features nex];
   ex = nex;
end

features = features(:, 1:n);


