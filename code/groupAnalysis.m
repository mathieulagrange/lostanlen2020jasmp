function groupAnalysis()

modes = 0;
load clusters

modeClasses = unique(modes);
instrumentClasses = unique(instruments);

cl = c(5, :);
ncl = length(unique(cl));

[scl, icl] = sort(cl);

colormap(jet(15))

ptx=0;
ptl=0;
for k=1:ncl
    cc = length(im(cl==k));
    ptl(k+1) = ptl(k)+cc;
    ptx(k+1) = ptl(k)+cc/3;
    mi = mode(im(cl==k));
%     scl(scl==k) = mi;
   clusterNames{k} = modeClasses(mi);
end
ptx(1)=[];

clusterNames{end} = [clusterNames{end} 'art'];
clusterNames{2} = [clusterNames{2} 'key'];

figure(1)
image([scl/max(scl)*15; im(icl)']);
colorbar('Ticks', (1:length(modeClasses))+.5, 'TickLabels', modeClasses, 'TickLength', 0)
text(ptx, ones(1, ncl), clusterNames, 'fontSize', 12);
axis off
set(gcf, 'WindowButtonDownFcn', @getMousePositionOnImage);
dat.names = names(icl);
dat.ap = audioplayer(0, 44100);
guidata(gcf, dat);
title('Modes')
saveas(gcf, 'figures/groupModes', 'png')
savefig(gcf, 'figures/groupModes')

%% instruments

cl = c(8, :);
ncl = length(unique(cl));

[scl, icl] = sort(cl);

colormap(jet(15))

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
end
ptx(1)=[];
pty = ones(1, ncl)-.025;
pty(1:2:end) = pty(1:2:end)+.05;
% clusterNames{end} = [clusterNames{end} 'art'];
% clusterNames{2} = [clusterNames{2} 'key'];

figure(2)
image([scl/max(scl)*15; ii(icl)']);


instrumentClasses = unique(instruments);
colorbar('Ticks',(1:length(instrumentClasses))+.5, 'TickLabels',instrumentClasses, 'TickLength', 0)
text(ptx, pty, clusterNames, 'fontSize', 12);
axis off
set(gcf, 'WindowButtonDownFcn', @getMousePositionOnImage);
dat.names = names(icl);
dat.ap = audioplayer(0, 44100);
guidata(gcf, dat);

title('Instruments')
saveas(gcf, 'figures/groupInstruments', 'png')
savefig(gcf, 'figures/groupInstruments')