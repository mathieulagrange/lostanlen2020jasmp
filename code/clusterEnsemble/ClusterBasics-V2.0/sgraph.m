% function labels = sgraph(k,dataname)
%
% copyright (c) 1998-2011 by Alexander Strehl

function labels = sgraph(k,dataname) 

scriptfile = ['' 'partgraph' num2str(sum(dataname=='0')) num2str(sum(dataname=='1')) num2str(sum(dataname=='2')) num2str(sum(dataname=='3')) '.bat'];

if ~exist('dataname'),
      dataname = ['' 'graph0'];
end;
resultname = [dataname '.part.' num2str(k)];

lastchar = str2num(dataname(length(dataname)));
if (isempty(lastchar)),
  disp('sgraph: file does not comply to name convention');
  lastchar = 0;
end;
s='';
if (lastchar<2),
   scriptfile = ['pmetis ' dataname ' ' num2str(k)];
else
   ubfactor = 5;
   scriptfile = ['shmetis ' dataname ' ' num2str(k) ' ' num2str(ubfactor)];
end;

system(scriptfile);

fid = fopen(resultname,'r');
if (fid == -1),
  disp('sgraph: partitioning not successful due to external error');
  fid = fopen(dataname);
  if (fid == -1),
    disp('sgraph: graph file is not accessible');
  else
    if lastchar>=2,
      junk = fscanf(fid,'%d',1); 
    end;
    labels = ones(1,fscanf(fid,'%d',1));
    if isempty(labels),
      disp('sgraph: empty label vector - suspecting file system full');
    end;
    fclose(fid);
  end;
else
  disp(['sgraph: ' scriptfile ' completed - loading ' resultname]);
  labels = (fscanf(fid,'%d')+1)';
  fclose(fid);
end;

fid = fopen(resultname,'r');
if (fid ~= -1),
  fclose(fid);
  delete(resultname);
end;
