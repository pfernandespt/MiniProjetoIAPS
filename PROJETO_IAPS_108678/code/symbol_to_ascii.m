function c = symbol_to_ascii(s)
% symbol_to_ascii converts a matrix of symbols into a string
%   c = symbol_to_ascii(s)
%       'c': string of characters
%       's': matrix of symbols
%
%   by: Paulo Fernandes, 108678 (UAveiro)

    c = char(sum((s - 1) .* [64; 16; 4; 1],1));
end

