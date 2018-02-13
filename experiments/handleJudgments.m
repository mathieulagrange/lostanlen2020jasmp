function [data, judgments] = handleJudgments(config, data, average)

if ~exist('average', 'var'), average = 0; end

if length(data.mode)<length(data.file), data.file(end) = []; end
idx = [];
gt = [];
mgt = [];
egt = [];
d = load([config.codePath 'ticelJudgments.mat']);
for k=1:length(d.names)
    oct = strfind(data.file, d.names{k});
    oct = find(~cellfun(@isempty, oct));
    idx = [idx oct];
    gt = [gt repmat(d.ci(:, k), 1, length(oct))];
    % mgt = [mgt repmat(d.medoid(k), 1, length(oct))];
    egt = [egt repmat(d.ensemble(k), 1, length(oct))];
end
[idx, ia] = unique(idx);
if average
    judgments = egt(:, ia);
else
    judgments = gt(:, ia);
end
data = filterData(data, idx);