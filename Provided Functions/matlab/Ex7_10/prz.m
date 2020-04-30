function pout=prz(T);
% generating a rectangular pulse of width T/2
% Usage function pout~prz(T);
%
% Modified from: Lathi, Ding, "Modern Digital and Analog Communication Systems"
% 4ed, 2009, Oxford University Press.

pout= [zeros(1,T/4) ones(1,T/2) zeros(1,T/4)];
end
