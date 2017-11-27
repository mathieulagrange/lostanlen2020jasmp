function [score match] = accuracy(true_labels, cluster_labels)
%ACCURACY Compute clustering accuracy using the true and cluster labels and
%   return the value in 'score'.
%
%   Input  : true_labels    : N-by-1 vector containing true labels
%            cluster_labels : N-by-1 vector containing cluster labels
%
%   Output : score          : clustering accuracy
%
%   Author : Wen-Yen Chen (wychen@alumni.cs.ucsb.edu)
%			 Chih-Jen Lin (cjlin@csie.ntu.edu.tw)

% Compute the confusion matrix 'cmat', where
%   col index is for true label (CAT),
%   row index is for cluster label (CLS).

true_labels = true_labels(:);
cluster_labels = cluster_labels(:);

cluster_labels = cluster_labels+1-min(cluster_labels);
true_labels = true_labels+1-min(true_labels);




n = length(true_labels);
cat = spconvert(double([(1:n)' true_labels ones(n,1)]));
cls = spconvert(double([(1:n)' cluster_labels ones(n,1)]));
cls = cls';
cmat = full(cls * cat);

%
% Calculate accuracy
%
[match, cost] = hungarian(-cmat);
score = -cost/n;
