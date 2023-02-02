%plot PML vs LDP regions on utility surface

clear all; clc;

epsilon = 1.8;
eps = log([epsilon,epsilon]); %privacy level(s)
expeps = exp(eps);
lambda_1 = 0.5; %priors
lambda_2 = 1-lambda_1;
lambda = [lambda_1,lambda_2];

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

p_1 = 0:0.01:1;
p_2 = 0:0.01:1;
[P_1,P_2] = meshgrid(p_1,p_2);
MI = mi_2d(p_1,p_2,lambda');
levels = (0:0.01:1);
contour(P_1,P_2,MI,levels,'LineWidth',2); hold on; axis equal;
hf=fill([1 1 0 0],[0 1 1 0],'w','facealpha',0.8);

feasible_pml = is_pml(p_1,p_2,A,b);
MI(~feasible_pml) = NaN;
contour(P_1,P_2,MI,levels,'linewidth',2);
%fill(V(:,1),V(:,2),'w','FaceAlpha',1);
%fill(V(:,2),V(:,1),'w','FaceAlpha',1);
%feasible_ldp = is_ldp(p_1,p_2);
%MI(~feasible_ldp) = NaN;
%contour(P_1,P_2,MI,levels,'linewidth',2);
line([0 V(2,1)],[0 ,V(2,2)]);
line([0 V(3,1)],[0, V(3,2)]);
line([1 V(2,1)],[1 V(2,2)]);
line([1 V(3,1)],[1 V(3,2)]);
xlabel('p_1');
ylabel('p_2');

function mi2d = mi_2d(P_1,P_2,lambda)
    mi2d = zeros(length(P_1),length(P_2));
    N = length(P_1);
    for i = 1:N
        for j = 1:N
            mechanism = [P_1(i) 1-P_1(i);P_2(j) 1-P_2(j)];
            mi2d(i,j) = mi(mechanism,lambda);
        end
    end
end

function boolmtrx = is_pml(p_1,p_2,A,b)
    N = length(p_1);
    boolmtrx = zeros(N,N);
    for i = 1:N
        for j = 1:N
            boolmtrx(i,j) = all((A*[p_1(i) p_2(j)]' <= b'));
        end 
    end
end

function boolmtrx = is_ldp(p_1,p_2)
    N = length(p_1);
    boolmtrx = zeros(N,N);
    for i = 1:N
        for j = 1:N
            boolmtrx(i,j) = max(abs(log(p_1(i)/p_2(i))),abs(log((1-p_1(i))/(1-p_2(i))))) < min(eps);
        end
    end
end

