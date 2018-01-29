clear all
addpath(genpath('functions'))
load('extractedData/results.mat');

data2use={1,9,[1 9]};
seuil={[5 6 7],[5 6 7],[11 12 13 14]};

for jj=1:length(data2use)
    
    rating2use=rating(:,data2use{jj});
    mode2use=mode(:,1);
    instrument2use=instrument(:,1);
    sounds2use=sounds(:,1);
    path2use=path(:,1);
    
    rating2use=sum(rating2use,2);
    [rating2use,ind]=sort(rating2use,'descend');
    
    for ll=1:length(seuil{jj})
        ind=ind(rating2use>=seuil{jj}(ll));
        
        %% Instrument
        
        oldIntrument=unique(instrument2use);
        newInstrument=unique(instrument2use(ind));
        
        isNewInstrument=cellfun(@(x) any(strcmp(x,newInstrument)),oldIntrument);
        
        disp(['Seuil=' num2str(seuil{jj}(ll)) '; Data2use: '  num2str(jj) ])
        disp(['Nbr New Instruments=' num2str(sum(isNewInstrument)) '; Nbr missing Instrument=' num2str(sum(~isNewInstrument))])
        
        data=[];
        objects=[];
        for pp=1:length(ind)
            data.objects(pp).sounds=sounds2use(ind(pp));
            data.objects(pp).path=path2use(ind(pp));
            data.objects(pp).instrument=instrument2use(ind(pp));
            data.objects(pp).mode=mode2use(ind(pp));
        end
        
        data.instrument_missing=oldIntrument(~isNewInstrument);
        data.instrument_used=newInstrument;
        
        if length(data2use{jj})==1
            savejson('',data,['export/ticelxp1_subject_' num2str(data2use{jj}) '_tresh_' num2str(seuil{jj}(ll)) '.json']);
        else
            savejson('',data,['export/ticelxp1_subject_mix_tresh_' num2str(seuil{jj}(ll)) '.json' ]);
        end
        disp('')
    end
end