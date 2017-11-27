function [f,p,r] = boundariesEvaluation(time,timeAnnotation,threshold)

%% BOUNDARIESEVALUATION

% Recall is the percentage of the total number of
% annotated boundaries that were recovered, and precision is the percentage of estimated
% boundaries that were correct.

%% Evaluate boundaries detection
correctBoundaries=0;
annotatedBoundaries = length(timeAnnotation);
estimatedBoudaries = length(time);

for ii = 1:length(timeAnnotation)
    if(~isempty(time(time(time>timeAnnotation(ii)-threshold)<timeAnnotation(ii)+threshold)))
        correctBoundaries=correctBoundaries+1;
    end
end

p=correctBoundaries/estimatedBoudaries;
r=correctBoundaries/annotatedBoundaries;
f=2*(p*r)/(p+r);

if isnan(f)
    f=0;
end
end

