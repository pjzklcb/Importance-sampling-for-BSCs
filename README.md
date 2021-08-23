# Importance-sampling-for-BSC-channel
Matlab codes for the paper "Asymptotically Tight MLD Bounds and Minimum-Variance Importance Sampling Estimator for Efficient Performance of Linear Block Codes over BSCs"

This program is used to implement the Hamming weight-based importance sampling (HW-IS) algorithm. We provide BCH, LDPC and Polar codes as the default choices.

Please run the 'main.m' file with default settings for a try. You can change SNRs, stopping criteria, and other simulation related parameters in 'main.m'. The 'simulation.m' consists of the HW-IS algorithm, the display module and the figure-plotting module.

1. The 'Utils\' folder includes some useful tools such as the decoders for LDPC code and the Polar code, where the latter one 'Utils\Polar Codes in MATLAB -v2' is developed by Harish Vangala and can be found in 'https://ecse.monash.edu/staff/eviterbo/polarcodes.html'. If you have your own encoding or decoding functions, please add them into 'Utils/'. Later, in the part 'How to add your own code?', we will show you how to call them.
2. The 'Data\' folder provides some '.mat' files for LDPC codes, which consists of the generator matrix 'G', the parity-check matrix 'H' and the information bit index 'info_idx'. It includes some MacKay's code from 'http://www.inference.org.uk/mackay/codes/data.html'. The default 'DSC.273.17.17.mat' LDPC code is from 'http://the-art-of-ecc.com/8_Iterative/index.html'. You can add your own LDPC codes with the same format into this folder.
3. The 'Results\' folder includes some examples of BCH, LDPC and Polar codes by implementing the program.
4. The 'demo\' folder includes the screenshot and video for our program running with the default settings - (273,191) DSC LDPC code with BP decoder.

# How to add your own code?
By modifying the 'Utils/codeIS.m' file, you can easily achieve that. 
1. Give your code type a name and add the name into the switch statement in the 'encode()' and 'decode()' functions.
2. If you have your own encoder or decoder for your code, make it a function, put it into the folder 'Utils/', and finish the encoding or decdoing process in the switch statement in 'codeIS.m'. One remark is that all-zero codeword is assumed as the input of the 'encode()'. Please make sure that the size of the output of 'encode()' is (nwords,n). The sizes of the input and output of 'decode()' are (nwords,n) and (nwords,k), respectively.
3. If your encoder or decoder requires information other than n, k or channel state p, then you need to add dynamic properties to the structure codeIS in the 'main.m' as the following template shows.
