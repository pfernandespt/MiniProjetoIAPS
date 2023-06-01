function msg = decrypt(msg, pwd)
% decrypt uses a password to decrypt a string
%   msg = decrypt(msg, pwd)
%       'msg': string of characters to decrypt
%       'pwd': password to use for decryption
%
%   by: Paulo Fernandes, 108678 (UAveiro)

    if(nargin == 1 || isempty(pwd))
        return;
    end

    pwd = double(pwd);

    for i = 1:length(msg)
        ec = pwd(rem(i+1,length(pwd))+1);
        
        msg(i) = msg(i) - ec + 255 * (msg(i) < ec);
        msg(i) = bitxor(double(msg(i)),ec);
    end
end