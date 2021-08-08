function [decoded] = peelDecoder(recv, H, max_itr)
% It implements the peeling decoder.
decoded = recv;
H2 = H;
v2 = recv;
for i = 1:max_itr
    didx = decoded==-1;
    
    eidx = v2==-1;
    H1 = H2(:,~eidx);
    H2 = H2(:,eidx);
    v1 = v2(~eidx);
    v2 = v2(eidx);
    if i == 1
        cnode = mod(v1*H1',2);
    end
    
    fidx = find(sum(H2,2)==1);
    if isempty(fidx)
        break
    end
    
    for j = 1:length(fidx)
        vidx = H2(fidx(j),:)==1;
        v2(vidx) = cnode(fidx(j));
        cnode(fidx(j)) = 0;
    end
    decoded(didx) = v2;
end