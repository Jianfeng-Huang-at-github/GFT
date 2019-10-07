% generate graphs and basis example

% load ('B.mat', 'B');

% number of vertices n 
for n = 3:8
    par = cell (n, 1);
    for k = 2:n-1
        par{k} = SetPartition (1:n, k);
    end

    tic
    K = 100;
    for k = 1:K
        % generate a random graph
        rand ('state', k);
        G = rand_G_by_dist (n, .5, .5);      
        if min (sum (G.W)) == 0             
            disp ('Oops! Graph not connected!')
        end

        B(n, k).W = G.W;
        B(n, k).U_real = find_U_real (G, par); 

        G = gsp_compute_fourier_basis (G);
        B(n, k).U_lap = G.U;

        W = B (n, k).W;
        B (n,k).U_greedy = greedy (W);
        
        k
    end
     toc
end

save ('B.mat', 'B');