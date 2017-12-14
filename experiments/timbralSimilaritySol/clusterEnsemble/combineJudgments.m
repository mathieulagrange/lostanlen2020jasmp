load ticelJudgments
addpath(genpath('.'))

ensemble = clusterensemble(ci);

% generate reference algorithmically
reference = 20;

for kclus=1:size(ci, 1)
    [accuracyv, classMatching] = accuracy(ci(reference,:), ci(kclus,:));
    
    labeltemp=ci(kclus,:);
    labeltemp2=ci(kclus,:);
    for kcm=1:size(classMatching,1)
        n=classMatching(kcm,:);
        vcm=find(n);
        if(~isempty(vcm))
            
            labeltemp(labeltemp2==kcm)=vcm;
        end
    end
    ci2(kclus,:)=labeltemp;
    
end
medoid = mode(ci2);

save('../ticelJudgments.mat', 'medoid', 'ensemble','-append')