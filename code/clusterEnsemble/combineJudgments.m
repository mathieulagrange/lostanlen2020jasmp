load ../ticelJudgments
addpath(genpath('.'))

PATH = getenv('PATH');
setenv('PATH', [PATH ':./ClusterEnsemble-V2.0/']);

ensemble = clusterensemble(ci);


save('../ticelJudgments.mat', 'ensemble','-append')