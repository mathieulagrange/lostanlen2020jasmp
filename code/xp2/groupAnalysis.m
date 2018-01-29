function groupAnalysis()

modes = 0;
load clusters

modeClasses = unique(modes);
instrumentClasses = unique(instruments);

cl = c(5, :);
ncl = length(unique(cl));

[scl, icl] = sort(cl);

% colormap(jet(15))

ptx=0;
ptl=0;
for k=1:ncl
    cc = length(im(cl==k));
    ptl(k+1) = ptl(k)+cc;
    ptx(k+1) = ptl(k)+cc/3;
    mi = mode(im(cl==k));
%     scl(scl==k) = mi;
   clusterNames{k} = modeClasses(mi);
   smcl(scl==k) = mi;
end
ptx(1)=[];


clusterNames{end} = [clusterNames{end} 'art'];
clusterNames{2} = [clusterNames{2} 'key'];

vec = [smcl; im(icl)'];

figure(1)
% cm = colormap(parula);
cm = jet(max(vec(:)));
cm = cm(randperm(length(cm)), :);
colormap(cm);

% colormap jet
image(vec); %scl/max(scl)*15
l1 = line([0 79], [1.5 1.5]); l1.Color = 'k';
for k=2:ncl   
    l1 = line([1 1]*ptl(k)+.5, [.5 1.5]); l1.Color = 'k';
end
colorbar('Ticks', (1:length(modeClasses))+.5, 'TickLabels', modeClasses, 'TickLength', 0)
[clusterNames{:}]
%text(ptx, ones(1, ncl), clusterNames, 'fontSize', 12);
% axis off
   set(gca, 'xtick', 0)
% set(gcf, 'WindowButtonDownFcn', @getMousePositionOnImage);
% dat.names = names(icl);
% dat.ap = audioplayer(0, 44100);
% guidata(gcf, dat);
% title('Modes')
set(gca, 'ytick', 1:2)
set(gca, 'yticklabel', {'Judg.', 'Ref.'});
% ytickangle(90)
saveas(gcf, '../paper/figures/groupModes', 'png')
savefig(gcf, '../paper/figures/groupModes')

%% instruments

cl = c(8, :);
ncl = length(unique(cl));

[scl, icl] = sort(cl);

% colormap(jet(15))

ptx=0;
ptl=0;
clusterNames = {};
for k=1:ncl
    cc = length(ii(cl==k));
    ptl(k+1) = ptl(k)+cc;
    ptx(k+1) = ptl(k)+cc/3;
    mi = mode(ii(cl==k));
%     scl(scl==k) = mi;
   clusterNames{k} = instrumentClasses(mi);
    smcl(scl==k) = mi;
end
% smcl
ptx(1)=[];
pty = ones(1, ncl)-.025;
pty(1:2:end) = pty(1:2:end)+.05;
% clusterNames{end} = [clusterNames{end} 'art'];
% clusterNames{2} = [clusterNames{2} 'key'];

figure(2)
vec = [smcl; ii(icl)'];
cm = jet(max(vec(:)));
cm = cm(randperm(length(cm)), :);
colormap(cm);
image(vec);
for k=2:ncl   
    l1 = line([1 1]*ptl(k)+.5, [.5 1.5]); l1.Color = 'k';
end

instrumentClasses = unique(instruments);
colorbar('Ticks',(1:length(instrumentClasses))+.5, 'TickLabels',instrumentClasses, 'TickLength', 0)
[clusterNames{:}]
% text(ptx, pty, clusterNames, 'fontSize', 12);
  set(gca, 'xtick', 0);
  l1 = line([0 79], [1.5 1.5]); l1.Color = 'k';
% set(gcf, 'WindowButtonDownFcn', @getMousePositionOnImage);
% dat.names = names(icl);
% dat.ap = audioplayer(0, 44100);
% guidata(gcf, dat);
set(gca, 'ytick', 1:2)
set(gca, 'yticklabel', {'Judg.', 'Ref.'});
% ytickangle(90)
% title('Instruments')
saveas(gcf, '../paper/figures/groupInstruments', 'png')
savefig(gcf, '../paper/figures/groupInstruments')