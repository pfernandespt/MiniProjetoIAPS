function msg = encrypt(msg, pwd)
    
    if(nargin == 1 || pwd(1) == ' ')
        return;
    end

    pwd = double(pwd);

    for i = 1:length(msg)
        ec = pwd(rem(i+1,length(pwd))+1);
        msg(i) = rem(bitxor(double(msg(i)),ec) + ec,255);
    end
end