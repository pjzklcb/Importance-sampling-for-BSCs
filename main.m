% This program is used to implement the Hamming weight-based importance
% sampling (HW-IS) algorithm. We provide BCH, LDPC and Polar codes as the
% default choices.
% How to add your own code?
% By modifying the Utils/codeIS.m file, you can easily achieve that. 
% 1. Add your code type into the switch statement in the encode() and
% decode() functions.
% 2. If you have your own encoder or decoder for your code, make it a
% function, put it into the folder Utils/, and finish the encoding or
% decdoing process in the switch statement in codeIS.m.
% 3. If your encoder or decoder requires information other than n, k or
% channel state p, then you need to add dynamic properties to the structure
% codeIS in the main.m as the following template shows.

clear

addpath('Utils/')
addpath('Data/')

%% code setting
% BCH
% m = 8; n = 2^m-1;       % Codeword length
% k = 231;                % Message length
% nwords = 10;            % Number of words to encode
% code = codeIS('BCH',n,k,nwords);

% LDPC
load('Data/LDPC/DSC_273_17_17.mat');    % provide G, H, info_idx for LDPC codes
[k,n] = size(G);
code = codeIS('LDPC',n,k);      % define code
code.addprop('G');              % add properties for encoding and decoding
code.addprop('H');
code.addprop('info_idx');
code.G = G; code.H = H; code.info_idx = info_idx;

% Polar code
% addpath('Utils/Polar Codes in MATLAB - v2/')
% addpath('Utils/Polar Codes in MATLAB - v2/functions/')
% n = 128; 
% k = 64;
% code = codeIS('Polar Code',n,k);
% code.addprop('designChannelState');
% code.designChannelState = 0.1;

%% channel setting
EbNo = 3:0.5:6.5;

%% Simulation
relativeError = 0.1;        % stopping criterion
maxRuns = 1e6;              % maximum runs
resolution = 1e3;           % fresh rate for display
[WER, BER, nSamples] = simulation(code, EbNo, relativeError, maxRuns, resolution);
