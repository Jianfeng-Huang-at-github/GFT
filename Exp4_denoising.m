% Experiment 4: Denoising using two different methods: Greedy n-term
% approximation and Tikhonov regularization

clear
clc

w = 15; h = 11;
figpath = 'fig\Exp4\';

savefig = true;

G = gsp_minnesota ();

% Prepare the greedy basis and Laplacian basis for later use
if false
    G = gsp_compute_fourier_basis (G);
    save ('minnesota_G.mat', 'G');
    
    minnesota_U_gr = greedy (G.W);
    save ('minnesota_U_gr.mat', 'minnesota_U_gr')
end

% use the 3rd laplacian basis vector to generate a two-valued signal x
if false
    load ('minnesota_G.mat', 'G');
    x = G.U (:,3);
    x (x > 0) = 1;
    x (x < 0) = -1;
    save ('piecewise_signal.mat', 'x');
end

%==============================================================
% Start Denoising

% load the original signal x
load ('piecewise_signal.mat', 'x'); 
% plot x
param.climits = [-2 2];
figure(1); gsp_plot_signal (G, x, param);
if savefig
    set(gcf, 'PaperPosition', [0 0 w h]);
    set(gcf, 'PaperSize', [w h]);
    saveas(gcf, strcat(figpath, 'dn1'), 'png')
end

% add some gassian noise to x to get noisy signal y
y = awgn (x, 10);
% plot y
figure(2); gsp_plot_signal (G, y, param);
if savefig
    set(gcf, 'PaperPosition', [0 0 w h]);
    set(gcf, 'PaperSize', [w h]);
    saveas(gcf, strcat(figpath, 'dn2'), 'png')
end
    
% Denoising by greedy basis
if true
    load ('minnesota_U_gr.mat', 'minnesota_U_gr')
    y_hat = minnesota_U_gr' * y;
    z_hat = y_hat;
    
    % use greedy coefficients to approximate z
    s = sort (abs(y_hat), 'descend');
    K = floor (0.03*G.N);
    z_hat (abs (z_hat) < s(K)) = 0;
    z = minnesota_U_gr * z_hat;
    
    figure (3); gsp_plot_signal (G, z, param);
    if savefig
        set(gcf, 'PaperPosition', [0 0 w h]);
        set(gcf, 'PaperSize', [w h]);
        saveas(gcf, strcat(figpath, 'dn3'), 'png')
    end
    
end

% Tikhonov regularization
if true
    load ('minnesota_G.mat', 'G');
    y_hat = G.U' * y;
    gamma = 4;
    z_hat = y_hat ./ (1 + gamma * G.e);
    z = G.U * z_hat;
    figure (4); gsp_plot_signal (G, z, param);
    if savefig
        set(gcf, 'PaperPosition', [0 0 w h]);
        set(gcf, 'PaperSize', [w h]);
        saveas(gcf, strcat(figpath, 'dn4'), 'png')
    end
end
