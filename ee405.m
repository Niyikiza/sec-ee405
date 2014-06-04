function r=ee405(s, cmd)
% Sends cmd (string) to the ee405 board using serial port s.
% If there is any return value, it will be returned in r.
% r is a matrix of double (usually a row vector)

% remove trailing '\n', '\r', 10, or 13's
% Note that x='abc\n' in matlab will give x(4)='\' and x(5)='n'.
% If you do x=sprintf('abc\n'), then uint8(x(4)) will be equal to 10.
m=length(cmd);
while m>=1
    if (cmd(m)==10) | (cmd(m)==13)
        if m==1
            cmd='';
            break;
        else
            cmd=cmd(1:m-1);
            m=m-1;
        end
    elseif ((cmd(m) == 'n') | (cmd(m) == 'r')) & (m>=2)
        if cmd(m-1)=='\'
            if m==2
                cmd='';
                break;
            else
                cmd=cmd(1:m-2);
                m=m-2;
            end
        else
            break;
        end
    else
        break;
    end
end

r=[];

for j=1:100
    while s.BytesAvailable > 0
        fread(s,s.BytesAvailable,'int8');	% read unnecessary data in serial input buffer and discard
    end

    % Note that '\n' will be automatically inserted by fprintf(s,...) when s is a serial port.
    fprintf(s, cmd);

    r1=fscanf(s);   % normally r1 will contain cmd followed by '\n'

    if ~isempty(strfind(r1, cmd))
        for k=1:10000
            while s.BytesAvailable < 4; end	% wait until '\r>> ' or a return value is returned
            if s.BytesAvailable == 4    % this means only '\r>> ' is returned
                if length(r)==0
                    r=[];
                end
                return
            end
            r2=fscanf(s);
            u=sscanf(r2, '%d')';
            n=length(u);
            [x y]=size(r);
            p=zeros(x+1,max([y n]));
            if x>0 & y>0
                p(1:x,1:y)=r;
            end
            p(x+1,1:n)=u;
            r=p;
        end
    end
    % If isempty(strfind(r1, cmd)), something is wrong (possibly communication error 
    % due to Rx buffer overrun in EE405). Do it all over again.
end
