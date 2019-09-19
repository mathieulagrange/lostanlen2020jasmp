function [data, judgments] = splitJudgments(data, judgments, split, test)

if ~exist('test', 'var'), test = 0; end

if ~isempty(split)
    rng(0);
    
    idx = randi(ceil(100/split), size(judgments, 2), 1)-1;
    if test
        idx = find(idx==0);
    else
        idx = find(idx);
    end
    data = filterData(data, idx);
    judgments = judgments(:, idx);
end