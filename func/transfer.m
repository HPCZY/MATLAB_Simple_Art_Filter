function y = transfer(x, lambda)
    y = lambda .^ (x * exp(lambda)) ./ gamma(x);
end