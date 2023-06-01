function msg = encrypt(msg, pwd)
% encrypt uses a password to decrypt a string
%   msg = encrypt(msg, pwd)
%       'msg': string of characters to encrypt
%       'pwd': password to use for encryption
%
%   by: Paulo Fernandes, 108678 (UAveiro)
    
    if(nargin == 1 || isempty(pwd))
        return;
    end

    pwd = double(pwd);

    for i = 1:length(msg)
        ec = pwd(rem(i+1,length(pwd))+1);
        msg(i) = rem(bitxor(double(msg(i)),ec) + ec,255);
    end
end