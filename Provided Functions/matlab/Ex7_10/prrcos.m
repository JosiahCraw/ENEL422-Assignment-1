% (prrcos. m)
% Usage y=prrcos(rollfac,length, T)
function y=prrcos(rollfac,length, T)
% Root raised cosine pulse shape
% rollfac = 0 to 1 is the rolloff factor
% length is the onesided pulse length in the number of T
% length = 2T+1;
% T is the oversampling rate
y=rcosfir(rollfac, length, T,1, 'sqrt');
y = y / norm(y);  % normalise to unit energy
end
