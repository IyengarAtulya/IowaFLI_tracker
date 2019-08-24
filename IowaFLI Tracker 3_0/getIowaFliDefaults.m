function abc=getIowaFliDefaults(FILENAME)
def=importdata(FILENAME);
for i=4:numel(def)
tok(i)=regexp(def{i},':\s*[\d*.]*\s*%','match');
n=regexp(tok{i},'[\d*.]*','match');
abc(i)=str2num(n{1});
end