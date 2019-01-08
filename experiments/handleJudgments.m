function [data, judgments, idx] = handleJudgments(config, data, average, filter)

if ~exist('average', 'var'), average = 0; end
if ~exist('filter', 'var'), filter = 1; end

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

if (filter)
data = filterData(data, idx);
end