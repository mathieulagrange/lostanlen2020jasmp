
function data = filterData(data, idx)

data.features = data.features(idx, :);
data.mode = data.mode(idx);
data.modeFamily = data.modeFamily(idx);
data.instrument = data.instrument(idx);
data.family = data.family(idx);
data.file = data.file(idx);
if isfield(data, 'judgments')
   data.judgments = data.judgments(:, idx); 
end

