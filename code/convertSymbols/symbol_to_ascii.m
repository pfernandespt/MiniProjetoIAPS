function c = symbol_to_ascii(s)
    c = char(sum((s - 1) .* [64; 16; 4; 1],1));
end

