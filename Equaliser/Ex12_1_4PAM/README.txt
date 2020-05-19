Files in this directory are taken from Lathi (International 4th Edition), Computer Exercise 12.1.

This code implements a baseband equivalent model of transmission of bits using 16QAM modulation over a multipath channel.

Refer to the text book for more information and example outputs.

Note: Numerous corrections have been made, including correction to the power scaling of the channel impulse response and noise
samples and the analytical expression for symbol error rate.

A new function 'eyediagram' has been provided to allow the example to run without the Matlab communications toolbox.
A new function 'qfun' has been provided to map between the erfc() and Q() functions.