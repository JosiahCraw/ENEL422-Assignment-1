% MATLAB PROGRAM <linear_eq.m>
% This is the receiver part of the QAM equalization example
%
Ntrain=200;
Neq=8;
% Number of training symbols for Equalization
% Order of linear equalizer (=length-1)
u=0;
SERneq=[];
SEReq=[];
% equalization delay u must be <= Neq
for i=1:13,
    Eb2N(i)=i*2-1;                          %(Eb/N in dB)
    Eb2N_num=10^(Eb2N(i)/10);               % Eb/N in numeral
    Var_n=Es/(2*Eb2N_num);                  %1/SNR is the noise variance
    signois=sqrt(Var_n/2);                  % standard deviation
    z1=out_mf+signois*noisesamp;            % Add noise

    Z=toeplitz(z1(Neq+1:Ntrain),z1(Neq+1:-1:1)); %signal matrx for
                                                % computing R
    dvec=[s_data(Neq+1-u:Ntrain-u)];        % build training data vector
    f=pinv(Z'*Z)*Z'*dvec;                   % equalizer tap vector
    dsig=filter(f,1,z1);                    % apply FIR equalizer
        % Decision based on the Re/Im parts of the samples
    deq=sign(real(dsig(1:L)))+sign(real(dsig(1:L))-2)+ ...
        sign(real(dsig(1:L))+2)+ ...
        j*(sign(imag(dsig(1:L)))+sign(imag(dsig(1:L))-2)+ ...
        sign(imag(dsig(1:L))+2));
    % Now compare against the original data to compute SER
    % (1) for the case without equalizer
    % NB: there was an error in the code in the text book with one
    % occurrence of z1 mistyped as 'dsig'.  This has been corrected.
    dneq=sign(real(z1(1:L)))+sign(real(z1(1:L))-2)+ ...
        sign(real(z1(1:L))+2)+ ...
        j*(sign(imag(z1(1:L)))+sign(imag(z1(1:L))-2)+ ...
        sign(imag(z1(1:L))+2));
    SERneq=[SERneq;sum(abs(s_data~=dneq))/(L)];
    % (2) for the case with equalizer
    SEReq=[SEReq;sum(s_data~=deq)/L];
end
