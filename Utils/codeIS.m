classdef codeIS<dynamicprops
% This structure is created by PAN Jinzhe on Aug 7, 2021.
% It includes all the information needed for encoding and decoding. Here we
% provide examples of BCH, LDPC and Polar codes as the template.
% The all-zero codeword is assumed. The output of the encoder should have
% the size (nwords,n).
% The decoder can have the channel state p as the input. The output should
% have the size (nwords,k).
    properties
        type            % code type
        n               % codeword length
        k               % information length
        nwords = 1      % input number of codewords for each itr
    end
    methods
        function obj = codeIS(type,n,k,nwords)
            if nargin == 3
                obj.type = type;
                obj.n = n;
                obj.k = k;
            elseif nargin == 4
                obj.type = type;
                obj.n = n;
                obj.k = k;
                obj.nwords = nwords;        % don't input it for LDPC and Polar codes
            else
                error('The number of inputs is wrong!');
            end
        end
        %% encoding
        function enc = encode(obj, varargin)
            switch obj.type
                case 'BCH'
                    msg = gf(zeros(obj.nwords,obj.k));
                    enc = bchenc(msg,obj.n,obj.k);
                case 'LDPC'
                    msg = zeros(obj.nwords,obj.k);
                    enc = mod(msg*obj.G,2);
                case 'Polar Code'
                    initPC(obj.n,obj.k,'BSC',obj.designChannelState);
                    msg = zeros(obj.k,obj.nwords);
                    enc = pencode(msg);
                % define your own encoder here.
                otherwise
                    error('Undefined code type!');
            end
        end
        %% decoding
        function dec = decode(obj, recv, varargin)
            switch obj.type
                case 'BCH'
                    dec = bchdec(recv,obj.n,obj.k);
                    dec = dec.x;
                case 'LDPC'
                    max_itr = 20;
                    dec = bitFlipDecoder(recv, obj.H, max_itr);
                    dec = dec(obj.info_idx);
                case 'Polar Code'                   % input channel state
                    if nargin == 3
                        p = varargin{1};
                    end
                    dec = pdecode(recv,'BSC',p)';
                % define your own decoder here.
                otherwise
                    error('Undefined code type!');
            end
        end
    end
end