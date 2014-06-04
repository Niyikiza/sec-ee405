function wavwritealaw(Y, WAVEFILE)
% Write Y to a Windows WAVE file in CCITT A-law format.
% Y must be a row vector of uint8.
% 16KHz sampling rate, mono format is assumed.
header=uint8([
    82
    73
    70
    70
     0
     0
     0
     0
    87
    65
    86
    69
   102
   109
   116
    32
    18
     0
     0
     0
     6
     0
     1
     0
   128
    62
     0
     0
   128
    62
     0
     0
     1
     0
     8
     0
     0
     0
   100
    97
   116
    97
     0
     0
     0
     0
]');

n=uint32(length(Y));
header(5)=uint8(bitand(n+38,255));
header(6)=uint8(bitand(bitshift(n+38,-8),255));
header(7)=uint8(bitand(bitshift(n+38,-16),255));
header(8)=uint8(bitand(bitshift(n+38,-24),255));
header(43)=uint8(bitand(n,255));
header(44)=uint8(bitand(bitshift(n,-8),255));
header(45)=uint8(bitand(bitshift(n,-16),255));
header(46)=uint8(bitand(bitshift(n,-24),255));

fid=fopen(WAVEFILE,'wb');
fwrite(fid, header, 'uint8');

Z=bitxor(uint8(Y), 85);	% 85=0x55

fwrite(fid, Z, 'uint8');
fclose(fid);
