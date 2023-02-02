function epsilon = evaluate_pml(mechanism, priors)
    epsilon = log(max(max(mechanism)./sum(mechanism.*priors')));
end