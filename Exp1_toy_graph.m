% Experiment 1 (Table 3)
% Illustrate Laplacian basis, l1 basis, and greedy basis on different 
% toy graphs (Path, Ring, Comet, Sensor)

clc
clear

rand ('state',0);

savefig = false;

graphs = {'path', 'comet', 'sensor'}; 

for k = 1 : length(graphs)
    graph_name = graphs{k};
    
    % set graph plotting parameters
    param.bar = 1;
    param.bar_width = 2.5;
    
    % generate the graph G
    if strcmp (graph_name, 'path')
        G = gsp_path (8);
        param.cp = [4.5 4 2];
    elseif strcmp (graph_name, 'comet')
        G = gsp_comet (8,5);
        param.cp = [3 -5 1]; 
    elseif strcmp (graph_name, 'sensor')
        G = gsp_sensor (8);
        param.cp = [.5 -1 1.5]; 
        scale = 2;
    end

    n = G.N;

    % compute Laplacian basis of G
    [U_lap D] = eig (full(G.L));
    if U_lap (1,1) < 0
        U_lap (:,1) = -U_lap (:,1);
    end

    % compute greedy basis of G
    U_greedy = greedy (G.W);

    % compute l1 basis of G
    par = cell (n, 1);
    for k = 2:n-1
        par{k} = SetPartition (1:n, k);
    end
    U_real = find_U_real (G, par);

    % plot the base and save the figures
    w = 25; h = 4;
    nr = 1; nc = 8;

    figpath = 'fig\Exp1\';
    scale = 1;
    
    % plot graph
    figure (4); 
    gsp_plot_graph (G);
    if savefig    
        set(gcf, 'PaperPosition', [0 0 h h]);
        set(gcf, 'PaperSize', [h h]);
        saveas(gcf, strcat(figpath,graph_name, '_graph'), 'png')
    end

    % plot greedy basis
    figure (1); 
    plot_U (G, scale * U_greedy, nr, nc, .05, .24, param, '${\mathbf u}^{\rm Gr}');
    if savefig    
        set(gcf, 'PaperPosition', [0 0 w h]);
        set(gcf, 'PaperSize', [w h]);
        saveas(gcf, strcat(figpath,graph_name,'_U_greedy'), 'png')
    end

    % plot Laplacian basis
    figure (2); 
    plot_U (G, scale * U_lap, nr, nc, .05, .24, param, '${\mathbf u}^{\rm Lp}');
    if savefig    
        set(gcf, 'PaperPosition', [0 0 w h]);
        set(gcf, 'PaperSize', [w h]);
        saveas(gcf, strcat(figpath,graph_name,'_U_lap'), 'png')
    end

    % plot l1 basis
    figure (3); 
    plot_U (G, scale * U_real, nr, nc, .05, .24, param, '${\mathbf u}^{\ell_1}');
    if savefig    
        set(gcf, 'PaperPosition', [0 0 w h]);
        set(gcf, 'PaperSize', [w h]);
        saveas(gcf, strcat(figpath,graph_name,'_U_ell1'), 'png')
    end

end
