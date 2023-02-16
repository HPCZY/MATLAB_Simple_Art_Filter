function y = clip(x, m)
    y = min(max(x, 1), m);
end