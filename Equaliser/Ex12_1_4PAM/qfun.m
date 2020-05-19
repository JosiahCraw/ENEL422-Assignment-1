function q = qfun( x )
%
% function q = qfun( x )
%
% Q Gaussian tail probability function
%    Q(x) = 1/2 erfc( x/sqrt(2) );
%
% INPUTS
%   x  Argument of 'Q' function to be evaluated.
%
% OUTPUTS:
%   q  = Q(x) = 1/2 erfc( x/ sqrt(2) );
%
% 10/Apr/2016  GKW
% 

q  = 1/2 * erfc( x/sqrt(2) );
