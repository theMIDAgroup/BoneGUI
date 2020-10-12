function[aux]= myexec()
filename='lic.nfo';

% alldate(1)=datenum('20.11.2010','dd.mm.yyyy');
% alldate(2)=datenum('19.11.2010','dd.mm.yyyy');
% 
% onshadow(alldate,filename);

if exist(filename,'file')
    alldate=onclear(filename);
    temp=max(alldate);
    
    if temp < now
        temp = now;
        alldate(end+1)=temp;
        
        onshadow(alldate,filename);
    end
    
	aux=datenum('21.08.2012','dd.mm.yyyy')-temp;    
else
    aux=-1;
end

end





function[alldate]=onclear(filename)

psw='A55&%/@ù*^ìPW 2 99Qqwecx.#';

seed_crypto=sum(double(psw));
rand('seed',seed_crypto);

fo=fopen(filename,'r');
%%
str_CRYPTO='!" #$%&''()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~¡¢£¤¥¦§¨©ª«¬­®¯°±³´µ¶·¸º»¼½¿ÀÁÂÃÄÅÇÈÉÊËÌÍÎÏĞÑÒÓÔÕÖ×ÙÚÛÜİŞßàáâãäçèéêëìíîïñòóôõö÷øùúûüıÿ';
%%
str=fgetl(fo);
count = 1;
while(ischar(str))
    it_max=length(str);
    temp1=[];
    for it = 1 : it_max
        temp1(it)=find(str_CRYPTO==str(it));
    end
    temp_rand=floor(180.*rand(size(temp1)));
    temp2=temp1-temp_rand+181.*((temp1-temp_rand)<=0)-1;
    temp3=[];
    for it = 1 : it_max
        temp3(1,it)=str_CRYPTO(temp2(it));
    end
    
    alldate(count)=str2double(char(temp3));
count = count+1;
    str=fgetl(fo);
    clear temp1;
    clear temp2;
    clear temp3;
    clear temp_rand;
    
end
fclose(fo);
end


function onshadow(alldate,filename)

psw='A55&%/@ù*^ìPW 2 99Qqwecx.#';
seed_crypto=sum((double(psw)));
rand('seed',seed_crypto);

fo_w=fopen(filename,'w');


%%
str_CRYPTO='!" #$%&''()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~¡¢£¤¥¦§¨©ª«¬­®¯°±³´µ¶·¸º»¼½¿ÀÁÂÃÄÅÇÈÉÊËÌÍÎÏĞÑÒÓÔÕÖ×ÙÚÛÜİŞßàáâãäçèéêëìíîïñòóôõö÷øùúûüıÿ';
%%
for count = 1: length(alldate)
    str=num2str(alldate(count));
    it_max=length(str);
    temp1=[];
    for it = 1 : it_max
        temp1(it)=find(str_CRYPTO==str(it));
    end
    
    temp_rand=floor(180.*rand(size(temp1)));
    temp2=mod(temp1+temp_rand,181)+1;
    temp3=[];
    for it = 1 : it_max
        temp3(1,it)=str_CRYPTO(temp2(it));
    end
    
        fprintf(fo_w,'%s\n',char(temp3));

    clear temp1;
    clear temp2;
    clear temp3;
    clear temp_rand;
end
fclose(fo_w);

end