% MATLAB PROGRAM <plotPAM_results.m>
% This program plots symbol error rate comparison before and after
% equalisation
%
%
figure(2)
subplot(111)
%- Correction from text example - the following plot is of SER, not BER.  
%- Change variable names to make this explicit.
figSER=semilogy(Eb2Naz,SER, 'k-' ,Eb2N,SERneq, 'b-o' ,Eb2N,SEReq, 'b-v');
axis([0 26 .99e-5 1]);
legend('Ideal 4-PAM (Analytical)', 'Without equaliser', 'With equaliser');
xlabel('E_b/N (dB)') ;ylabel('Symbol error probability');
%- Change figure handle variable name from figber to figSER for clarity
set(figSER, 'Linewidth' ,2);
grid on;  %- add grid lines to plot.
%% Constellation plot before and after equalisation
figure(3)
subplot(121)
plot(imag(z1(1:min(L,4000))) ,real(z1(1:min(L,4000) )) , 'x', 'MarkerSize',1);
axis('square')
%xlabel('Real part')
title(' (a) Before equalisation')
ylabel( 'Signal Amplitude' ) ;
subplot(122)
plot(imag(dsig(1:min(L,4000))) ,real(dsig(1:min(L,4000))), 'x', 'MarkerSize',1);
axis ('square')
title(' (b) After equalisation')
%xlabel('Real part')
ylabel('Signal Amplitude');
%% Multiptah Channel impulse response
figure(4)
t=length(h) ;
plot([1:t]/f_ovsamp,h);
xlabel('time (in unit of T_s) ')
title('Multipath channel impulse response');
%% Plot eye diagrams due to multipath channel
eyevec=conv(xchout,prcos);
eyevec=eyevec(delaychb+1: (delaychb+800)*f_ovsamp);
%- give the sample interval in terms of variable f_ovsamp so that
%- oversampling rate can be varied.
eyediagram(real(eyevec) ,2*f_ovsamp,2);
title('Eye diagram (without equaliser)');
xlabel('Time (in unit of T_s) ');
