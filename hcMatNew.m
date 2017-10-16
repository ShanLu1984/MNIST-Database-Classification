%=======================================================
% Used to generate heat content feature from inputGraph
%=======================================================

function [ hc ] = hcMatNew(inputGraph,step_t,lazy_step)

P = inputGraph.P;
B = inputGraph.B;
D = inputGraph.D;
delta = 1/lazy_step;

sP = size(P,1);
correction = zeros(sP,sP);
for i = 1:sP
    for j = 1:sP
        correction(i,j) = (D(i)/D(j))^1;
    end
end

P(B,:) = [];
P(:,B) = [];
correction(B,:) = [];
correction(:,B) = [];

sP = size(P,1);
P_multi = eye(sP) .* (1-delta)  + delta .* P;

step=step_t*lazy_step;

hc.total = zeros(step+1,1);
hc.total(1) = sP;

temp = eye(sP);

for i = 1:step
   temp = temp * P_multi;
   hc_mat = temp .* correction;
   hc.total(i+1) = sum(sum(hc_mat));
end

    
end

%===============================================================================


