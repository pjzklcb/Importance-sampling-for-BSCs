function [WER_vec, BER_vec, nSamples] = simulation(code, EbN0, re, maxRuns, resolution)
% This function is written by PAN Jinzhe on Aug 7, 2021.
% It implements the Hamming weight-based importance sampling (HW-IS)
% algorithm for BSCs.
% The input should include the instance that contains all the information
% for encoding and decoding. The outputs are the WER, the BER and the
% corresponding sample size.
n = code.n;
k = code.k;
nwords = code.nwords;
R = k/n;

t = 1;
theta = [zeros(1,t),ones(1,n+1-t)];

%% encoding
enc = code.encode();

%% channel setting
EsN0 = R*10.^(EbN0/10);
p = qfunc(sqrt(2*EsN0));

min_num = 500;
min_num_IS = 100;
WER_vec = zeros(size(EbN0));
BER_vec = zeros(size(EbN0));
WER_acc = zeros(size(EbN0));            % word error accumulator
BER_acc = zeros(size(EbN0));            % bit error accumulator
var_acc = zeros(size(EbN0));
nSamples = zeros(size(EbN0));           % count the number of samples for each Eb/N0
WERre_vec = ones(size(EbN0));           % store relative error for each Eb/N0
time_vec = zeros(size(EbN0));           % store time cost for each Eb/N0
wt_hist = zeros(1,n+1);                 % count the number of samples fall in each weight
err_hist = zeros(1,n+1);                % count the number of errors in each weight
% create figure
figure('Name','Eb/N0 vs WER','NumberTitle','off');

for i = 1:length(EbN0)
    tic
    % set initial pmf based on the error ratio and the channel state
    ak = sqrt(theta).*binopdf(0:n,n,p(i));
    ak = ak/sum(ak);
    while WERre_vec(i)>=re && nSamples(i)<=maxRuns
        %% display simulation progress
        if mod(nSamples(i), maxRuns/resolution) == 0
            disp(' ');
            disp('From up to bottom, the rows represent Eb/N0, WER, number of samples and the relative error, respectively.');
            disp([['Eb/N0     ';'WER       ';'nSamples  ';'RE        '], num2str([EbN0(max(1,i-5):max(6,i));
                WER_acc(max(1,i-5):max(i,6))./nSamples(max(1,i-5):max(6,i));nSamples(max(1,i-5):max(6,i));
                round(WERre_vec(max(1,i-5):max(i,6)),3)])]);
            disp(' ');
        end
        
        %% generate error vector
        wg = rand_pmf(0:n,ak,nwords);
        z = zeros(nwords,n);
        for j = 1:nwords
            z(j,:) = [ones(1,wg(j)),zeros(1,n-wg(j))];
            z(j,randperm(n)) = z(j,:);
        end
        recv = enc+z;
        
        %% decoding
        dec = code.decode(recv,p(i));       % the decoder can use the channel state as the input
        
        IndE = sum(dec,2)~=0;
        BerE = sum(dec,2)/k;
        wt = sum(z,2);
        w = binopdf(wt,n,p(i))./ak(wt+1)';
        wt_hist(wt+1) = wt_hist(wt+1)+1;
        err_hist(wt+1) = err_hist(wt+1)+IndE';
        
        WER_acc(i) = WER_acc(i)+IndE'*w;
        BER_acc(i) = BER_acc(i)+BerE'*w;
        var_acc(i) = var_acc(i)+BerE'*w.^2;
        
        nSamples(i) = nSamples(i)+nwords;
        
        %% update IS pmf
        if nSamples(i)>=min_num_IS && mod(nSamples(i),min_num_IS)==0
            if sum(err_hist)==0
                ak = [0, ak(1:end-1)];
                ak = ak/sum(ak);
                continue
            end
            
            theta = err_hist./wt_hist;
            idx = find(theta>0);
            for j = 1:length(idx)-1
                theta(idx(j):idx(j+1)-1) = theta(idx(j));
            end
            theta(idx(end):end) = theta(idx(end));
            theta(isnan(theta)) = 0;
            
            ak = sqrt(theta).*binopdf(0:n,n,p(i));
            if idx(1)>t+1+1
                ak(idx(1)-1) = ak(idx(1));
            end
            ak = ak/sum(ak);
        end
        
        %% update WER
        if nSamples(i) >= min_num && WER_acc(i)   % avoid NaN case
            Pe = WER_acc(i)/nSamples(i);
            Pb = BER_acc(i)/nSamples(i);
            
            % IS variance
            var_IS = (var_acc(i)/nSamples(i)-Pb^2)/nSamples(i);
            WERre_vec(i) = sqrt(var_IS)/Pb;
        end
    end
    WER_vec(i) = WER_acc(i)/nSamples(i);
    BER_vec(i) = BER_acc(i)/nSamples(i);
    time_vec(i) = toc;
    
    %% plot figure
    semilogy(EbN0(1:i),WER_vec(1:i),'o-');
    grid on; xlabel('E_b/N_0 (dB)'); ylabel('WER'); xlim([EbN0(1),EbN0(end)]);
    drawnow
end
%% simulation time cost
time_vec = round(time_vec,2);
ISgain = 100./(WER_vec.*nSamples);
savetime = time_vec * (ISgain-1)';
hour = floor(savetime/3600);
minite = floor(mod(savetime,3600)/60);
speedup = savetime/sum(time_vec);
% display
disp(['This simulation takes ', num2str(sum(time_vec)), 's.']);
disp(['This tool has just saved you around ', num2str(hour), ' h ', num2str(minite),' min' ...
    ' with a speedup factor ', num2str(speedup,'%.3e'), ' over the Monte Carlo simulation.']);
