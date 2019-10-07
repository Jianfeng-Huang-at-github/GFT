function W = xyz2W (x, y, z, alpha)

n = size (x, 1);
W = zeros (n);

for i = 1:n
    for j = i+1:n
        pi = [x(i) y(i) z(i)];
        pj = [x(j) y(j) z(j)];
        d = pi - pj;
        d2 = d * d';
        t = exp (-alpha * d2 );
        W (i, j) = t;
        W (j, i) = W(i, j);
    end
end
