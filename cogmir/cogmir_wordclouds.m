clf(); clc(); close all;
fig = openfig('../paper/figures/groupModes.fig');
color_data = fig.CurrentAxes.Children(6).CData;
tick_labels = fig.CurrentAxes.Colorbar.TickLabels;

%%
judg_data = color_data(1, :);
judg_data_diff = diff(judg_data);
changepoints = find(judg_data_diff~=0);
cluster_starts = [1, changepoints+1];
cluster_stops = [changepoints, length(judg_data)];
nClusters = length(cluster_starts);

refs = cell(1, nClusters);
for cluster_id = 1:nClusters
    disp(cluster_id);
    cluster_start = cluster_starts(cluster_id);
    cluster_stop = cluster_stops(cluster_id);
    refs{cluster_id} = ...
        tick_labels(color_data(2, cluster_start:cluster_stop));
    refs_esc = cellfun( ...
        @(x) [x, ','], refs{cluster_id}, 'UniformOutput', false);
    counter_keys = unique(refs{cluster_id},'stable');
    counter_values = ...
        cellfun(@(x) sum(ismember(refs{cluster_id},x)),counter_keys,'un',0);
    fileID = fopen(['clustermodes_', int2str(cluster_id), '.txt'],'w');
    fprintf(fileID, '%s', [refs_esc{:}]);
    fclose(fileID);
end


%%