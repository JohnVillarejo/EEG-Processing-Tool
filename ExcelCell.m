function Cell = ExcelCell(n)

symbols = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
symi = mod(n,26);
if symi==0
    symi=26;
end

multn = floor((n-1)/26);

if multn>0
    Cell = strcat(symbols(multn),symbols(symi));
else
    Cell = symbols(n);
end