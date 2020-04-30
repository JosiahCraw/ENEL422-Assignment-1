%% Matlab Program <Exl2_1_4PAM.m>
%- Code example for assignment question (h) and (i) based upon Matlab Program <Exl2_1.m> from Lathi Text.
%- Code has been modified to implement a 4-PAM system, by taking just the in-phase component of the original
%- 16QAM implementation in Ex12_1.m.  Note - original comments have been left intact (refer text book).
%- Modified lines have been noted by comments commencing with "%-"


% This Matlab exercise <Ex12_1.m> performs simulation of
% linear equalization under QAM-16 baseband transmission
% a multipath channel with AWGN.
%
%- Note: numerous corrections have bene made, particularly relating to scaling
%- of noise and channel impulse response.  Changes are commented with '%-'.
%
% Correct carrier and synchronization is assumed.
% Root-raised cosine pulse of rolloff factor = 0.5 is used
% Matched filter is applied at the receiver front end.
% The program estimates the symbol error rate (SER) at different Eb/N
clear;clf;
L=1000000; % Total data symbols in experiment
% To display the pulse shape, we oversample the signal
% by factor of f_ovsamp=8
f_ovsamp=8; % Oversampling factor vs data rate
delay_rc=4;
%- OLD Generating root-raised cosine pulseshape (rolloff factor = 0.5)
%prcos=rcosflt([ 1 ], 1, f_ovsamp, 'sqrt', 0.5, delay_rc);   % Root Raised Cosine (RRC) pulse
%prcos=prcos(1:end-f_ovsamp+1);                              % remove 0's
%prcos=prcos/norm(prcos);                                    % normalise
%- NEW code to generate root-raised cosine pulseshape (rolloff factor 0.5)
prcos = rcosdesign( 0.5, delay_rc*2, f_ovsamp );
pcmatch=prcos(end:-1:1);                                    % Matched Filter.
%% Generating random signal data for polar signaling
%- Modifed for 4-PAM by simply removing the quadrature (imaginary) component of the data.
s_data=4*round(rand(L,1))+2*round(rand(L,1))-3;
% upsample to match the 'oversampling rate' (normalize by 1/T).
% It is f_ovsamp/T (T=1 is the symbol duration)
s_up=upsample(s_data,f_ovsamp);

% Identify the decision delays due to pulse shaping
% and matched filters
delayrc=2*delay_rc*f_ovsamp;
% Generate polar signaling of different pulse-shaping
xrcos=conv(s_up,prcos);
%- co-efficients for low-pass filter at transmitter - 12th order, -20dB ripple
[c_num,c_den] = cheby2(12,20, (1+0.5)/f_ovsamp);
% The next commented line finds frequency response
%[H,fnlz]=freqz(c_num,c_den,512,8);

% The lowpass filter is the Tx filter before signal is sent to the channel
xchout=filter(c_num,c_den,xrcos);

% We can now plot the power spectral densities of the two
%         xrcos and xchout
% This shows the filtering effect of the Tx filter before
% transmission in terms of the signal power spectral densities
% It shows how little lowpass Tx filter may have distorted the signal
plotPSD_comparison

%% Apply a 2-ray multipath channel
mpath=[1 0 0 -0.65]; % multipath delta(t)-0.65 delta(t-3T/8)

% time-domain multipath channel
%- Scale the multipath channel impulse response for unit energy
mpath = mpath/norm(mpath);
h=conv(conv(prcos,pcmatch) ,mpath);
%- Lathi didn't normalise channel, but modified symbol energy later.
%- hscale=norm(h);

xchout=conv(mpath,xchout); %apply 2-ray multipath
xrxout=conv(xchout,pcmatch);    %send the signal through matched filter
                                % separately from the noise
delaychb=delayrc+3;
out_mf=xrxout(delaychb+1:f_ovsamp:delaychb+L*f_ovsamp);
clear xrxout;

%% Generate random noise for channel output
%- Original modified for 4PAM by removing the quadrature component of the noise
noiseq=randn(L*f_ovsamp,1);
% send AWGN noise into matched filter first
noiseflt=filter(pcmatch, [1] ,noiseq); clear noiseq;
% Generate sampled noise after matched filter before scaling it
% and adding to the QAM signal
noisesamp=noiseflt(1:f_ovsamp:L*f_ovsamp,1);

clear noiseq noiseflt;
%- Normalised energy for 4PAM symbol is 5
Es=5;            % symbol energy

%% Call linear equalizer receiver to work
linear_eq

for ii=1:10;
    Eb2Naz(ii)=2*ii-2;
    %- Compute the analytical SER. NB: Original code in error - incorrect
    % - conversion from Q() to erfc()!  Refer to Lathi equation 10.104
    %- Q(ii)=3*0.5*erfc(sqrt((2*10^(Eb2Naz(ii)*0.1)/5)/2)); % WRONG!
    
    %- Compute the SER using the Q function to be consistent with the
    %- expressions in the lectures and text (Lathi section 10.6.5, eqn 10.99d
    %- NB: Q(x) = 1/2 erfc( x/sqrt(2) ).  See qfun.m
    %- Also change variable name to explicitly refer to symbol error rate.
    M=4;   % 4PAM
    SER(ii) = 2 * (M-1)/M * qfun( sqrt( 6 * log2(M) / (M*M-1) * dB2lin( Eb2Naz(ii))));
end
% Now plot results
plotPAM_results
