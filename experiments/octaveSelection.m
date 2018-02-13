 function idx = octaveSelection(config, data, octaveNumber)
 
 if ~exist('octaveNumber', 'var'), octaveNumber = 4; end

%  config.inputPath = '/data/databases/instruments/SOL/';
 
fid = fopen([config.inputPath 'fileList.txt']);
fileList = fscanf(fid, '%s\n');
fclose(fid);
fileList = regexp(fileList, '.wav', 'split');
fileList(end)=[];

D = regexp(fileList, '/', 'split');
for k=1:length(D)-1,
    dk = D{k};
    instrument{k} = dk{1};
    mode{k} = [dk{1} '-' dk{2}];
    name{k} = dk{3};
end

oct = strfind(name, [num2str(octaveNumber) '-']);
oct = find(~cellfun(@isempty, oct));

mul = strfind(name, 'mul');
mul = find(~cellfun(@isempty, mul));

oct = setdiff(oct, mul);

idx = oct;

% add unpitched
% notes = {'A', 'B', 'C', 'D', 'E', 'F', 'G'};
% pitched = [];
% for k=1:length(notes)
%    c = strfind(name, notes{k});
%    pitched = [pitched find(~cellfun(@isempty, c))];
% end
% 
% unpitched = setdiff(1:length(name), pitched);
% idx = [oct unpitched];


