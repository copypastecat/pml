import QBase

using Plots, JuMP, HiGHS
 
 priors = [0.7,0.3] 
 epsilon_y1 = 0.6;
 epsilon_y2 = 0.3;

 l(x1,x2)  = log(max(x1,x2)) - log(priors[1]*x1 + priors[2]*x2);
 l2(x1,x2) = log(max((1-x1),(1-x2))) - log(priors[1]*(1-x1) + priors[2]*(1-x2));
 l_joint(x1,x2) = (l(x1,x2) < epsilon_y1) && (l2(x1,x2) < epsilon_y2);
 mi(x1,x2) = QBase.mutual_information(priors,[x1 x2; 1-x1 1-x2])*l_joint(x1,x2);

 Q = permutedims([0.27 0.73;0 1],(2,1)) # transpose 
 MI = QBase.mutual_information(priors,Q)
 print(MI)
  

 heatmap((0:0.001:1),(0:0.001:1),mi)
 #surface(0:0.001:1,0:0.001:1,mi,camera=(-30,40))

