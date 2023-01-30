function mi = mi(p_ycondx,p_x)
  %computes the entropy of a joint RV given by its priors and transition
  %probanility matrix in Nats
    p_xy = (p_x.*p_ycondx')';
    p_y = sum(p_xy,1);
    logterms = log(p_ycondx./p_y);
    logterms(isinf(logterms)) = 0;
    t = sum(p_xy.*logterms);
    t(isnan(t))=0;
    mi = sum(t);
end
