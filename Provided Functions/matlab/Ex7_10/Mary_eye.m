% (Mary_eye.m)
% generate and plot eyediagrams
%
clear;clf;
data= sign(randn(1,400))+2* sign(randn(1,400)); % 400 PAM symbols
Tau=64; %Define the symbol period
dataup=upsample(data, Tau); %Generate impulse train
yrz=conv(dataup,prz(Tau)); %Return to zero polar signal
yrz=yrz(1:end-Tau+1);
ynrz=conv(dataup,pnrz(Tau)); %Non-return to zero polar
ynrz=ynrz(1:end-Tau+1);
ysine=conv(dataup,psine(Tau)); %half sinusoid polar
ysine=ysine(1:end-Tau+1);
Td=4; % truncating raised cosine to 4 periods
yrcos=conv(dataup,prcos(0.5,Td,Tau)); % rolloff factor = 0.5
yrcos=yrcos(2*Td*Tau:end-2*Td*Tau+1); %generating RC pulse train
eye1=eyediagram(yrz,2*Tau,Tau,Tau/2) ;title('RZ eye-diagram');
eye2=eyediagram(ynrz,2*Tau,Tau,Tau/2) ;title('NRZ eye-diagram');
eye3=eyediagram(ysine,2*Tau,Tau,Tau/2) ;title('Half-sine eye-diagram');
eye4=eyediagram(yrcos,2*Tau,Tau); title('Raised-cosine eye-diagram');
