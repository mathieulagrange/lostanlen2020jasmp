function ticelSimilarity(source)

if ~exist('source', 'var'), source = 'All'; end

if iscell(source)
    for k=1:length(source)
        ticelSimilarity(source{k}); 
    end
    return
end

addpath('jsonlab');

dataPath = '../../data/';

[status,msg] = mkdir('figures');

colorCode = { ...
'#f0a3ff ', ...
'#c20088 ', ...
'#740aff ', ...
'#4c005c ', ...
'#191919 ', ...
'#5ef1f2 ', ...
'#00998f ', ...
'#0075dc ', ...
'#003380 ', ...
'#808080 ', ...
'#ffff00 ', ...
'#9dcc00 ', ...
'#8f7c00 ', ...
'#005c31 ', ...
'#2bce48 ', ...
'#ffa405 ', ...
'#ff5005 ', ...
'#ff0010 ', ...
'#990000 ', ...
'#993f00 '};

% load
d = dir([dataPath '*.json']);


%d = dir([dataPath '949d03783cdeadbb29379f2870a9c126.json']);
ind=1;
for k=1:length(d)
    try
        jsonData = loadjson([dataPath d(k).name]);
        users{k} = jsonData.email;
%         k
%         jsonData.email
        jk = [jsonData.organization{:}];
        c{ind, :} = {jk(:).color};
        x(ind, :) = [jk(:).x];
        y(ind, :) = [jk(:).y];
        [~, ~, ci(ind, :)] = unique(c{ind, :});
        name{ind, :} = {jk(:).file};
        ind = ind+1;
        
    end
end

names = name{ind-1, :};
for k=1:length(names)
    c = strsplit(names{k}, '-');
    i = strsplit(c{1}, '+');
    instruments{k} = i{1};
    modes{k} = c{2};
    m=2;
    while c{m+1}(1) == lower(c{m+1}(1)) && ~strcmp(c{m+1}, 'mf')
        modes{k} = [modes{k} '-' c{m+1}];
        m = m+1;
    end
    names{k} = [c{1} '-' modes{k}];
end


x([7, 31], :) = [];
y([7, 31], :) = [];
ci([7, 31], :) = [];

% norm
for k=1:size(x, 1)
  x(k, :) = x(k, :)-min(x(k, :)); 
  y(k, :) = y(k, :)-min(y(k, :));  
  x(k, :) = x(k, :)/max(x(k, :)); 
  y(k, :) = y(k, :)/max(y(k, :));
  di(k, :) = pdist([x(k, :); y(k, :)]');
  dc(k, :) = pdist(ci(k, :)', 'jaccard');
end

save('judgments.mat', 'ci')

for k=1:size(x, 1)
    dat.names = names;
    dat.x = x(k, :);
    dat.y = y(k, :);
    dat.color = ci(k, :);   
    savejson('', dat, ['figures/'  num2str(k) '.json']);
    scatter(x(k, :), y(k, :), 100, ci(k, :), 'filled');
    axis off
    saveas(gcf, ['figures/' num2str(k)], 'png')
end


for k=1:size(x, 1)
    imagesc(squareform(dc(k, :)))
    colormap gray
    set(gca, 'xtick', 0)
set(gca, 'ytick', 1:length(names))
set(gca, 'yticklabel', names)
    saveas(gcf, ['figures/' num2str(k) 'Sim'], 'png')
end



ds = mean(di, 1);
dc = mean(dc, 1);
vs = var(di, 1);

imagesc(squareform(dc))
colormap default
set(gca, 'xtick', 0)
set(gca, 'ytick', 1:length(names))
set(gca, 'yticklabel', names)
saveas(gcf, 'figures/allSim', 'png')

save(['sim' source '.mat'], 'ds', 'dc', 'instruments', 'modes', 'names')

%displayData(ds, 'Simi', instruments, modes, source, length(name))
pm = displayData(dc+.000001*rand(size(dc)), 'Class', instruments, modes, source, length(name));

dat.names = names;
dat.x = pm(:, 1);
dat.y = pm(:, 2);
dat.color =  ones(1, size(pm, 1));
savejson('', dat, 'figures/all.json');

[iNames, ~, ii] = unique(instruments);
[mNames, ~, im] = unique(modes);

l = linkage(dc, 'weighted');

m = cluster(l, 'maxclust', 5);
dat.color = m;
savejson('', dat, 'figures/allModes.json');
dat.color = im;
savejson('', dat, 'figures/allModesRef.json');

i = cluster(l, 'maxclust', 8);
dat.color = i;
savejson('', dat, 'figures/allInstruments.json');
dat.color = ii;
savejson('', dat, 'figures/allInstrumentsRef.json');

function pm = displayData(ds, type, instruments, modes, source, nb)

pm = mdscale(squareform(ds), 2);

figure(1)
[instrumentClasses, ~, bi] = unique(instruments);
colormap(jet(length(instrumentClasses)))

scatter(pm(:, 1), pm(:, 2), 100, bi, 'filled')
caxis([1 16])
colorbar('Ticks',.5+(1:length(instrumentClasses)),...
         'TickLabels',instrumentClasses, 'TickLength', 0)
% dx = 0.01; dy = 0.01; % displacement so the text does not overlay the data points
% text(pm(:, 1)+dx, pm(:, 2)+dy,  names);
axis off
title([source ' ' type ' Instruments (' num2str(nb)  ')'])
saveas(gcf, ['figures/' source type 'Instruments' num2str(nb)], 'png')

figure(1)
[modeClasses, ~, bi] = unique(modes);
colormap(jet(length(modeClasses)))
scatter(pm(:, 1), pm(:, 2), 100, bi, 'filled')
caxis([1 16])
colorbar('Ticks',.5+(1:length(modeClasses)),...
         'TickLabels',modeClasses, 'TickLength', 0)
     
% dx = 0.01; dy = 0.01; % displacement so the text does not overlay the data points
% text(pm(:, 1)+dx, pm(:, 2)+dy,  names);
axis off

title([source ' ' type ' Modes (' num2str(nb)  ')'])
saveas(gcf, ['figures/' source type 'Modes' num2str(nb)], 'png')



