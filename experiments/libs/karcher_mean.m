% KARCHER_MEAN Compute Karcher mean of subspaces
%
% Usage
%    X = karcher_mean(A);
%
% Input
%    A: An array of matrices of size n-by-p-by-k, where n is the dimension of
%       the ambient space, p is the dimension of the subspace, and k is the
%       number of subspaces. The matrix A(:,:,ell) is an orthonormal matrix
%       which constitutes a basis for the ellth subspace.
%
% Output
%    X: An orthonormal matrix of size n-by-p whose columns form a basis for a
%       Karcher mean of the given subspaces. This is a subspace that locally
%       minimizes
%
%          sum_{ell=1}^k dist(X, A_ell)^2 ,
%
%       where A_ell is the subspace spanned by A(:,:,ell) and dist(X, Y)^2 is
%       the sum of the squared principal angles between X and Y, that is
%
%          dist(X, Y)^2 = sum(acos(svd(X'*Y)).^2) .
%
%       The output X is obtained by minimizing this objective starting at
%       A(:,:,1).

function X = karcher_mean(A)
    n = size(A, 1);
    p = size(A, 2);
    k = size(A, 3);

    M = grassmannfactory(n, p);

    problem = struct();
    problem.M = M;
    problem.cost = @(X)(cost(M, A, X));
    problem.grad = @(X)(grad(M, A, X));
    problem.hess = approxhessianFD(problem);

    options = struct();
    options.verbosity = 0;

    X = trustregions(problem, A(:,:,1), options);
end

function f = cost(M, A, X)
    f = 0;
    for ell = 1:size(A, 3)
        f = f + 1/2*M.dist(X, A(:,:,ell))^2;
    end
end

function u = grad(M, A, X)
    u = M.zerovec();
    for ell = 1:size(A, 3)
        u = M.lincomb(X, 1, u, -1, M.log(X, A(:,:,ell)));
    end
end
