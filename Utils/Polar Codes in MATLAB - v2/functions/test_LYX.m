N = 8;
n = log2(N);
for i=1:N
    i_bin = dec2bin(i-1,n);
    for lastlevel = 1:n
        if i_bin(lastlevel) == '1'
            break;
        end
    end
    index_of_first1_from_MSB(i) = lastlevel;
    
    i_bin = dec2bin(i-1,n);
    for lastlevel = 1:n
        if i_bin(lastlevel) == '0'
            break;
        end
    end
    index_of_first0_from_MSB(i) = lastlevel;
end