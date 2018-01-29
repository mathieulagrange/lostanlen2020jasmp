clear all
addpath(genpath('functions'));


files=dir('results/*js');
rating=[];
instrument={};
mode={};
name={};
path={};
sounds={};

keep = 1:length(files);
keep = [1 9];

for jj=1:length(keep)
    name{jj}=files(jj).name;
    disp(files(keep(jj)).name);
    xx=1;
    results=loadjson(['results/' files(keep(jj)).name]);
    for ll=1:length(results)
        for nn=1:length(results{ll}.modes)
            rating(xx,jj)=results{ll}.modes{nn}.rating;
            instrument{xx,jj}=results{ll}.name;
            mode{xx,jj}=results{ll}.modes{nn}.name;
            sounds{xx,jj}=results{ll}.modes{nn}.sounds;
            path{xx,jj}=results{ll}.modes{nn}.path;
            xx=xx+1;
        end
    end
end

save('extractedData/results','rating','instrument','mode','name','sounds','path')