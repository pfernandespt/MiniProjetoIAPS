function msg = decrypt(msg, pwd)
    
    if(nargin == 1 || pwd(1) == ' ')
        return;
    end

    pwd = double(pwd);

    for i = 1:length(msg)
        ec = pwd(rem(i+1,length(pwd))+1);
        
        msg(i) = msg(i) - ec + 255 * (msg(i) < ec);
        msg(i) = bitxor(double(msg(i)),ec);
    end
end