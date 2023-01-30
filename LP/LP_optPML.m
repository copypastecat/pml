% LP for optimal PML mechanism

clear all; clc;

eps = log([1.5,1.5]); %privacy level(s)
expeps = exp(eps);
lambda_1 = 0.5; %priors
lambda_2 = 1-lambda_1;
lambda = [lambda_1,lambda_2];


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
    utility = mi(mechanism,lambda);
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
optimal_mechanism = [p_opt(1) 1-p_opt(1)
                 p_opt(2) 1-p_opt(2)]