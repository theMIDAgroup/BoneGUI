function[str_x] = Convert_Num2Str(x)
%%convert a number in a string, and it uses comma (,) as decimal separator
%%instead of the traditional dot (.)
minus = [];
if x<0, minus = '-'; end
x = abs(x);
str_x = [minus num2str(floor(x))];

temp = x-floor(x);
temp_str = num2str(temp);
if temp~=  0
    str_x = [str_x ',' temp_str(3:end)];
end
end