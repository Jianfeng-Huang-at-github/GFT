function D  = diffmat ( n, W )
% Construct matrix D such that TV = ||D*x||_1 = sum w_ij |x_i - x_j|

D = zeros (n*(n-1)/2,n);
k = 1;
for i=1:n
    for j=i+1:n
        D(k, i) = W(i,j);
        D(k, j) = -W(i,j);
        k = k + 1;
    end
end

end

