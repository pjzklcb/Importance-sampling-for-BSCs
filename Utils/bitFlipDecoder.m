function decoded = bitFlipDecoder(recv, H, num_itr)
% It implements the bit-flipping decoder.
% recv      : received codeword with hard-decision
% H         : parity-check matrix
% num_itr   : number of iterations
%
% decoded   : decoded codeword


% [r,n] = size(H);

% hard-decision
b = recv>0;

for i = 1:num_itr
    % syndrome calculation
    s = mod(b*H',2);
    
    % valid codeword
    if sum(s) == 0
        break
    end
    
    % number of unsatisfeid PCEs
    d = s*H;
    
    % update bit nodes
    d_max = max(d);
    if d_max ~= 0
        b(d==d_max) = 1-b(d==d_max);
    end
    
end

decoded = b;