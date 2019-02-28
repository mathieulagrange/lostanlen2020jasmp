addpath(genpath('manopt'))

% Set parameters n (dimension of ambient subspace) and p (dimension of subspace).
n = 8;
p = 3;
k = 2;

% Generate random subspaces.
A = zeros(n, p, k);
for ell = 1:k
    [A(:,:,ell), ~] = qr(randn(n, p), 0);
end

% Find the mean subspace.
X = karcher_mean(A);

% Find distances of mean to subspaces. For k = 2, X should be the same distance from both subspaces.
dists = zeros(k, 1);
for ell = 1:k
    dists(ell) = sqrt(sum(acos(svd(X'*A(:,:,ell))).^2));
end
