function [So,Su] =normCondEntropies(target,prediction)
%% From TOWARDS QUANTITATIVE MEASURES OF EVALUATING SONG SEGMENTATION
% Hanna Lukashevich ISMIR 2008 – Session 3b – Computational Musicology
% Na - number of states in the annotated segmentation;
% Ne - number of states in the estimated segmentation;
% nij - number of frames that simultaneously belong to the state i in the annotated segmentation and to the state j in the estimated one;
% The subscript a and the running index i are assigned to the annotated segmentation.
% Correspondingly, the subscript e denotes the estimated segmentation and the running index j is associated to its states.

%% TEST
if nargin ==0

%% debug Metrics 1
% prediction=[4 2 1 2 1 3 2 1 5];
% target=    [1 2 3 2 3 4 2 3 5];


%% debug Metrics ex2
% target=    [4 2 1 1 2 1 1 3 2 1 1 5];
% prediction=[1 2 2 2 2 2 2 1 2 2 2 1];
    
%% debug Metrics ex3
% target=    [4 2 1 1 2 1 1 3 2 1  1  5];
% prediction=[1 2 3 4 5 6 7 8 9 10 11 12];

%% debug Metrics ex4
% target=    [4 2 1 1 2 1 1 3 2 1 1 5];
% prediction=[1 2 2 3 2 2 3 3 2 2 3 1];


%% debug Metrics ex5
target=    [2 2 2 1 1 1 2 2 2 1 1 1];
prediction=[1 2 1 2 1 2 1 2 1 2 1 2];

[So,Su] =normCondEntropies(target,prediction);disp(['So=' num2str(So) ' | Su=' num2str(Su)]);return;
end
%% Metric computation

nij=zeros(max(target),max(prediction));

for ii=1:max(target)
    for jj=1:max(prediction)
        indA=find(target==ii);
        nij(ii,jj)=sum(prediction(indA)==jj);
    end
end

% Joint distributions of the labels
pij=nij/sum(sum(nij));
pai=sum(pij,2);
pej=sum(pij,1);

% Conditional Distributions
pae=pij./repmat(sum(pij,1),size(nij,1),1);
pea=pij./repmat(sum(pij,2),1,size(nij,2));
pea(isnan(pea))=0; %FIXME;
pae(isnan(pae))=0; %FIXME;

Hea=sum(pai.*sum(pea.*log2(pea+eps),2))*-1;
Hae=sum(pej.*sum(pae.*log2(pae+eps),1))*-1;

% -over -under segmentation scores
if max(prediction)==1
    So=1;
else
    So=1-Hea/(log2(max(prediction)));
end

if max(target)==1
    Su=1;
else
    Su=1-Hae/(log2(max(target)));
end
