function x = ccittenc(y)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
    n=length(y);
    x=zeros(1,n);
    for k=1:n
        if y(k) < 0
            s = 1;
        else
            s = 0;
        end
        
        if abs(y(k)) < 1/128
            x(k) = floor(abs(y(k))*2048)+128*s;
        elseif abs(y(k)) < 1/64
            x(k) = floor(abs(y(k))*2048-16)+16+128*s;
        elseif abs(y(k)) < 1/32
            x(k) = floor(abs(y(k))*1024-16)+32+128*s;
        elseif abs(y(k)) < 1/16
            x(k) = floor(abs(y(k))*512-16)+48+128*s;
        elseif abs(y(k)) < 1/8
            x(k) = floor(abs(y(k))*256-16)+64+128*s;
        elseif abs(y(k)) < 1/4
            x(k) = floor(abs(y(k))*128-16)+80+128*s;
        elseif abs(y(k)) < 1/2
            x(k) = floor(abs(y(k))*64-16)+96+128*s;
        else
            x(k) = floor(abs(y(k))*32-16)+112+128*s;
        end
    end
end

