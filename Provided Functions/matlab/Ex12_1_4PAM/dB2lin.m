function xlin = dB2lin( xdB)
%
% function xlin = dB2lin( xdB)
%
% Convert a dB power ratio into linear measure.
%  xlin = 10^ (xdB/10)
%
% INPUTS
%   xdB  scalar, matrix or vector of values in dB
%
% OUTPUTS:
%   xlin  The values in xdB converted into linear measure.
%
% 10/Apr/2016  GKW

xlin = 10.^( xdB/10 );
