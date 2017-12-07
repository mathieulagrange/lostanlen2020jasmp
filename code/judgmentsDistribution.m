
load('judgments.mat')

nbc=[];
sic=[];
for k=1:size(ci, 1)
    nb = unique(ci(k, :));
    nbc = [nbc length(nb)];
    sic = [sic hist(ci(k, :), nb)]; 
end

subplot 211
hist(nbc, 1:20)
axis([1 20 0 5])
subplot 212
hist(sic, 1:78)
axis([1 78 0 50])