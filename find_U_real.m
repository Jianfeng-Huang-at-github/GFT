function U = find_U_real ( G, par )
% find the l1 basis of G
% only can be used when G.N is small, i.e,  G.N < 10

n = G.N;

% the first basis vector u1
u1 = ones (n, 1) / sqrt(n);
U = [u1];

for k = 2:n-1
    u = find_uk_real ( G.W, U, par{k});   
    U = [U u];
end

% the last basis vector un
u = null (U');
u = u / sqrt (u'*u);
U = [U u];

end



