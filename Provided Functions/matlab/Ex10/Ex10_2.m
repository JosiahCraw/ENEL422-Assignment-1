% MATLAB PROGRAM <Ex10_2 .m>
% This Matlab exercise <Ex10_2.m> generates
% on/off baseband signals using root-raised cosine
% pulseshape (rolloff factor = 0.5) and orthogonal baseband
% signal before estimating the bit error rate (BER) at different
% Eb/N ratio for display and comparison
clear;clf
L=1000000; % Total data symbols in experiment is 1 million
% To display the pulse shape, we oversample the signal
% by factor of f_ovsamp=8
f_ovsamp=16; % Oversampling factor vs data rate
delay_rc=3;
% OLD Matlab code to Generate root-raised cosine pulseshape (rolloff factor 0.5)
%prcos=rcosflt(( 1 ), 1, f_ovsamp, 'sqrt', 0.5, delay_rc);
%prcos=prcos(1 :end-f_ovsamp+1);
%prcos=prcos/norm(prcos);
% NEW code to generate root-raised cosine pulseshape (rolloff factor 0.5)
prcos = rcosdesign( 0.5, delay_rc*2, f_ovsamp );
pcmatch=prcos(end:-1:1);
% Generating a rectangular pulse shape
psinh=sin((0:f_ovsamp-1)*pi/f_ovsamp);
psinh=psinh/norm(psinh);
phmatch =psinh(end:-1:1);
% Generating a half-sine pulse shape
psine=sin((0:f_ovsamp-1)*2*pi/f_ovsamp);
psine=psine/norm(psine);
psmatch=psine(end:-1:1);
% Generating random signal data for polar signaling
s_data=round(rand(L,1));
% upsample to match the 'fictitious oversampling rate'
% which is f_ovsamp/T (T=1 is the symbol duration)
s_up=upsample(s_data,f_ovsamp);
s_cp=upsample(1-s_data,f_ovsamp);
% Identify the decision delays due to pulse shaping
% and matched filters
delayrc=2*delay_rc*f_ovsamp;
delayrt=f_ovsamp- 1;
% Generate polar signaling of different pulse-shaping
xrcos=conv(s_up,prcos);
xorth=conv(s_up,psinh)+conv(s_cp,psine);
t=(1:200)/f_ovsamp;
figure(1)
subplot(211)
figwave1=plot(t,xrcos(delayrc/2:delayrc/2+199));
title(' (a) On/off root-raised cosine pulse.');
set(figwave1, 'Linewidth' ,2);
subplot(212)
figwave2=plot(t,xorth(delayrt:delayrt+199));
title(' (b) Orthogonal modulation.')
set(figwave2, 'Linewidth' ,2);
% Find the signal length
Lrcos=length(xrcos);Lrect=length(xorth);
BER=[];
noiseq=randn(Lrcos,1);
% Generating the channel noise (AWGN)
for i=1:12,
    Eb2N(i)=i ; %(Eb/N in dB)
    Eb2N_num=10^(Eb2N(i)/10); % Eb/N in linear scale
    Var_n=1/(2*Eb2N_num); %1/SNR is the noise variance
    signois=sqrt(Var_n); %standard deviation
    awgnois=signois*noiseq; % AWGN
    % Add noise to s i gnals at the channel output
    yrcos=xrcos+awgnois/sqrt(2);
    yorth=xorth+awgnois( 1:Lrect );
    % Apply matched filters first
    z1=conv(yrcos,pcmatch); clear awgnois yrcos;
    z2=conv(yorth,phmatch);
    z3=conv(yorth,psmatch);clear yorth;
    % Sampling the rece i ved signal and acquire sampl es
    z1=z1(delayrc+1:f_ovsamp:end);
    z2=z2(delayrt+1 :f_ovsamp:end- f_ovsamp+1 );
    z3 =z3(delayrt+1:f_ovsamp:end-f_ovsamp+1) ;
    % Decision based on the s ign of the samples
    dec1=round((sign(z1(1:L)-0.5)+1)*.5);dec2=round((sign(z2-z3)+1)*.5);
    % Now compare against the original data to compute BER for
    % the three pulses
    BER=[BER; sum(abs(s_data-dec1))/L sum(abs(s_data-dec2))/L ];
    Q(i)=0.5*erfc(sqrt(Eb2N_num/2)); %Compute the Analytical BER
end
figure(2);
subplot(111);
figber= semilogy( Eb2N, Q, 'k-' ,Eb2N, BER(:,1), 'b-*', ...
    Eb2N, BER(:,2), 'r-o');
fleg=legend('Analytical', 'Root-raised cosine on/off', 'Orthogonal signaling') ;
fx=xlabel('E_b/N (dB) ');fy=ylabel('BER');
set(figber, 'Linewidth' , 2) ;set (fleg, 'FontSize' ,11);
set(fx, 'FontSize', 11);
set(fy, 'FontSize', 11);
% We can plot the individual pulses used for the binary orthogonal signaling
figure(3);
subplot(111);
pulse=plot((0:f_ovsamp)/f_ovsamp, [psinh 0], 'k-', ...
    (0:f_ovsamp)/f_ovsamp, [psine 0 ], 'k-o');
pleg=legend('Half-sine pulse', 'Sine pulse');
ptitle=title('Binary orthogonal signals');
set(pulse, 'Linewidth', 2) ;
set(pleg , 'Fontsize', 10);
set(ptitle, 'FontSize', 11);
