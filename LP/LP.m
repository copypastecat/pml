% LP for optimal PML mechanism

clear all; clc;

N = 3; %source alphabet size

epsilon = 1.3;
eps = log(epsilon*ones(N,1)); %privacy level(s)
expeps = exp(eps);
lambda = 1/N*ones(N,1); %priors
%lambda = [0.7,0.1,0.1,0.1]';

%construct inequality constraint matrix
A_1 = eye(N) - repmat(lambda',N,1).*(ones(N)-eye(N)) - diag(lambda'*epsilon);
A = [kron(eye(N),A_1);eye(N*N);-eye(N*N)];
b = [zeros(N*N,1);ones(N*N,1);zeros(N*N,1)];

%equality constraint matrix
Aeq = repmat(eye(N),1,N);
beq = ones(N,1);

%convert constraints to extreme points of bounding polytope using lcon2vert
tic;
V = lcon2vert(A,b,Aeq,beq);
t1 = toc;
disp("time for finding vertices: ");
disp(t1);

%construct transition matrices from vertices and compute their utility
utils = [];
tic;
for idx=1:length(V(:,1))
    vertex = V(idx,:);
    mechanism = reshape(vertex,N,N);
    utility = real(mi(mechanism,lambda)); %real since log may return numerically erronous complex part 
    utils = [utils utility];
end
t2 = toc;
disp("time for calculating utility:");
disp(t2);

%construct the equivalent LP
Aequiv = ones(1,length(utils));
bequiv = 1;
lb = zeros(1,length(utils));
ub = ones(1,length(utils));

f = -utils; %neg utils since standard LP minimizes

tic;
opt = linprog(f,[],[],Aequiv,bequiv,lb,ub);
t3 = toc;
disp("time for solving LP:");
disp(t3);

p_opt = V((opt==1),:);
util_opt = utils((opt==1));
optimal_mechanism = reshape(p_opt,N,N);
