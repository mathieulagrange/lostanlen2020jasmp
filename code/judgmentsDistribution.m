
load('judgments.mat')

figPath = '../paper/figures/';

nbc=[];
sic=[];
for k=1:size(ci, 1)
    nb = unique(ci(k, :));
    nbc = [nbc length(nb)];
    sic = [sic hist(ci(k, :), nb)]; 
end

disp('number of groups : ')
disp([mean(nbc) std(nbc)])
disp('size of groups : ')
disp([mean(sic) std(sic)])

hist(nbc, 1:20)
axis([1 20 0 5])
xlabel('Number of groups')
set(gca, 'fontSize', 20)
saveas(gcf, [figPath 'nbc.png']);


hist(sic, 1:78)
axis([1 78 0 50])
xlabel('Size of groups')
set(gca, 'fontSize', 20)
saveas(gcf, [figPath 'sbc.png']);