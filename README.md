# Importance-sampling-for-BSC-channel
Matlab codes for the paper "Asymptotically Tight MLD Bounds and Minimum-Variance Importance Sampling Estimator for Efficient Performance of Linear Block Codes over BSCs"

This program is used to implement the Hamming weight-based importance sampling (HW-IS) algorithm. We provide BCH, LDPC and Polar codes as the default choices.

Please run the 'main.m' file with default settings for a try. You can change SNRs, stopping criteria, and other simulation related parameters in 'main.m'. The 'simulation.m' consists of the HW-IS algorithm, the display module and the figure-plotting module.

1. The 'Utils\' folder includes some useful tools such as the decoders for LDPC code and the Polar code, where the latter one 'Utils\'
2. The 'Data\' folder provides some '.mat' files for LDPC codes, which consists of the generator matrix 'G', the parity-check matrix 'H' and the information bit index 'info_idx'.
3. The 'Results\'

# How to add your own code?
By modifying the 'Utils/codeIS.m' file, you can easily achieve that. 
1. Add your code type into the switch statement in the 'encode()' and 'decode()' functions.
2. If you have your own encoder or decoder for your code, make it a function, put it into the folder 'Utils/', and finish the encoding or decdoing process in the switch statement in 'codeIS.m'. One remark is that all-zero codeword is assumed as the input of the 'encode()'. Please make sure that the size of the output of 'encode()' is (nwords,n). The size of the input and output of 'decode()' is (nwords,n) and (nwords,k), respectively.
3. If your encoder or decoder requires information other than n, k or channel state p, then you need to add dynamic properties to the structure codeIS in the 'main.m' as the following template shows.
