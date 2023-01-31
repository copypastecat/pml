import QBase

using Plots, LaTeXStrings
 
 priors = [0.5,0.5] 
 epsilon_y1 = log(1.5);
 epsilon_y2 = log(1.5);

 l(x1,x2)  = log(max(x1,x2)) - log(priors[1]*x1 + priors[2]*x2);
 l2(x1,x2) = log(max((1-x1),(1-x2))) - log(priors[1]*(1-x1) + priors[2]*(1-x2));
 l_joint(x1,x2) = 0.5*float((l(x1,x2) < epsilon_y1) && (l2(x1,x2) < epsilon_y2));
 ldp(x1,x2) = 0.5*float(max(abs(log(x1/x2)),abs(log((1-x1)/(1-x2)))) < min(epsilon_y1,epsilon_y2));
 l_vals(x1,x2) = max(l(x1,x2), l2(x1,x2));
 comp(x1,x2) = ldp(x1,x2) + l_joint(x1,x2);

 mi(x1,x2) = QBase.mutual_information(priors,[x1 x2; 1-x1 1-x2])*l_joint(x1,x2);
 hamming(x1,x2) = (priors[1]*(1-x1) + priors[2]*(x2))*l_joint(x1,x2);

 Q = permutedims([0.27 0.73;0 1],(2,1)) # transpose 
 MI = QBase.mutual_information(priors,Q)
 
 mi_max = 0;
 for i in (0:0.001:1)
    for j in (0:0.001:1)
        if mi(i,j) > mi_max
            global mi_max = mi(i,j);
            global p_1 = i;
            global p_2 = j;
        end
    end
 end

 print(p_1)
 print(p_2)

 h = heatmap((0:0.001:1),(0:0.001:1),comp);
 ylabel!(L"$p_2$");
 xlabel!(L"$p_1$");
 title!(L"$\epsilon$-PML (red) vs. $\epsilon$-LDP (yellow) valid regions")

 #surface(0:0.001:1,0:0.001:1,mi,camera=(-30,40))
 #savefig("BIBO-symmetric.png")
