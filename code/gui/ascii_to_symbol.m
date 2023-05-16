function s = ascii_to_symbol(c)
    s = zeros(4,length(c));

    c = double(c);

    s(1,:) = fix(c/64);
    s(2,:) = fix((c - 64*s(1,:))/16);
    s(3,:) = fix((c - 16*s(2,:) - 64*s(1,:))/4);
    s(4,:) = c - 4*s(3,:) - 16*s(2,:) - 64*s(1,:);

    s = s +1;
end