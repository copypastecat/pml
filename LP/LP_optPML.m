% LP for optimal PML mechanism for BIBO mechanisms

clear all; clc;
util_arr = [];
eps_arr = [];
rr_arr = [];

%for epsilon=1.01:0.2:200

epsilon = 1.5;
eps = log([epsilon,epsilon]); %privacy level(s)
expeps = exp(eps);
lambda_1 = 0.5; %priors
lambda_2 = 1-lambda_1;
lambda = [lambda_1,lambda_2]';


%equality constraint matrix for BIBO mechanisms
Aeq = [(1-lambda_1*expeps(1)) -lambda_2*expeps(1) 1 0 0 0 0 0
       -lambda_1*expeps(1) (1-lambda_2*expeps(1)) 0 1 0 0 0 0
       (lambda_1*expeps(2)-1) lambda_2*expeps(2)  0 0 1 0 0 0
       lambda_1*expeps(2) (lambda_2*expeps(2)-1)  0 0 0 1 0 0
              1                   0               0 0 0 0 1 0
              0                   1               0 0 0 0 0 1
             -1                   0               0 0 0 0 1 0
              0                   -1              0 0 0 0 0 1];

beq = [0 0 expeps(2)-1 expeps(2)-1 1 1 0 0];

%corresponding inequality constraints
A = Aeq(:,1:2);
b = beq;

%convert constraints to extreme points of bounding polytope using lcon2vert
V = lcon2vert(A,b);

%construct transition matrices from vertices and compute their utility
utils = [];
for idx=1:length(V(:,1))
    vertex = V(idx,:);
    mechanism = [vertex(1) 1-vertex(1)
                 vertex(2) 1-vertex(2)];
    utility = real(mi(mechanism,lambda)); %real since log may return numerically erronous complex part 
    utils = [utils utility];
end

%construct the equivalent LP
Aequiv = [1 1 1 1];
bequiv = 1;
lb = [0,0,0,0];
ub = [1,1,1,1];

f = -utils; %neg utils since standard LP minimizes

opt = linprog(f,[],[],Aequiv,bequiv,lb,ub);

p_opt = V((opt==1),:);
util_opt = utils((opt==1));
optimal_mechanism = [p_opt(1) 1-p_opt(1)
                 p_opt(2) 1-p_opt(2)]

rr_mechanism = (1/(1+epsilon))*[epsilon 1; 1 epsilon];

rr_util = mi(rr_mechanism,lambda);

util_arr = [util_arr util_opt];
eps_arr = [eps_arr epsilon];
rr_arr = [rr_arr rr_util];

%end

%plot(eps_arr,util_arr,'LineWidth',2);
%hold on;
%plot(eps_arr, rr_arr,'LineWidth',2);
%xlabel("e^{\epsilon}","FontSize",16);
%ylabel("I(X;Y)",'FontSize',16);
%legend(["optimal PML mechanism","randomized response"],'FontSize',16);
