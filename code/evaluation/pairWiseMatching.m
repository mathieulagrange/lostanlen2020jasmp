function [f,p,r] = pairWiseMatching(target, prediction)

if nargin==0
    prediction=[1 1 2 2 1 1 6 6 1 1 6 6];
    target    =[2 2 1 1 3 3 1 1 2 2 1 1];
    [f,p,r] = pairWiseMatching(target, prediction);
    disp(['F=' num2str(f) '; P=' num2str(p) '; R=' num2str(r)]);
    return;
end

%% Metric Computation
% time consuming, but memory gain
Ma=length(find(abs(pdist(target(:),'hamming')-1)==1));
Me=length(find(abs(pdist(prediction(:),'hamming')*2-2)==2));
Mea=length(find(abs(pdist(prediction(:),'hamming')*2-2)-abs(pdist(target(:),'hamming')-1)==1));

if(Me==0)
    warning('trivial case, no pair in prediction');
    p=0;
else
    p=Mea/Me;
end
if(Ma==0)
    warning('trivial case, no pair in target');
    r=0;
else
    r=Mea/Ma;
end
if p+r == 0
    f=0;
else
    f=2*p*r/(p+r);
end