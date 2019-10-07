function G = rand_G_by_dist ( n, sigma, rd )
% Generate a random graph G

% n random points 
x = rand (n, 2); 

% compute the distance d(i,j) between points i and j
d = zeros (n, n);
mind = -1;
maxd = -1;
for i = 1:n
    for j = i+1:n
        d (i, j) = norm (x(i,:) - x(j,:));    
        if mind == -1 || d(i,j) < mind
            mind = d (i,j);
        end
        if maxd == -1 || d(i,j) > maxd
            maxd = d (i,j);
        end
    end
end

d0 = mind + (maxd - mind) * rd;    

% gaussian weight w(i,j)
W = zeros (n, n);
for i = 1:n
    for j = i+1:n
        W(i, j) = exp (-d (i, j)^2 / sigma);   
        W(j, i) = W(i, j);
    end
end

W = W / sum(sum(W)) * n;    

G = gsp_graph (W);          
G.coords = x;

end

