% Experiment 3: Compare the approximation error between Laplacian basis and
% greedy basis to simulated signal and temperature signal

clc;
clear;

swiss = false;      % true: temperature signal; false: simulated signal
linear = true;      % true: first n-term appximation; false: largest n-term approximation

if swiss
    data = csvread ('temperature_data.csv',1, 0);

    % normalize coordinates (x, y, z) to the interval [0, 1]
    x = data (:,1);
    y = data (:,2);
    z = data (:,3);
    x = x - min(x);
    y = y - min(y);
    z = z - min(z);
    mxy = max (max ([x y]));
    mz = max (z);
    x = x / mxy;
    y = y / mxy;
    z = z / mz;

    % generate weight matrix by the coordinates (x, y, z)
    alpha = 100;
    W = xyz2W (x, y, z, alpha); 

    % set some small weights to zero
    W (W < .1) = 0;

    % delete isolated vertices
    Deg = sum (W);
    s = find (Deg > 0);
    W = W (s, s);
    x = x(s);
    y = y(s);
    data = data (s, :);

    % construct weighted graph G
    G = gsp_graph (W);
    G.coords = [x y];
    % gsp_plot_graph (G);

    % find the Laplacian and greedy basis
    G = gsp_compute_fourier_basis (G);
    U_tree = greedy (G.W);
    
    % read the signal from data
    sig = data (:, 6+3);
    

else % similated signal
    
    rand ('state', 1);
    n = 100;
    G = gsp_sensor (n);

    G = gsp_compute_fourier_basis (G);
    U_tree = greedy (G.W);

    % simulated signal
    tau = 2;
    r = 1- 2*rand (n, 1);
    h = 1./ (1+tau *G.e) .* r;
    sig = G.U * h;
    % gsp_plot_signal (G, sig);
    
end

figure
% plot signal
subplot('Position', [0.01 0.2 .3 .6])
gsp_plot_signal (G, sig);
if swiss 
    title ('Temperature signal')
else
    title ('Simulated signal')
end
   
% Fourier coeff. of x
x = sig; 
xx2 = G.U' * x;
xx1 = U_tree' * x;
n = length (x);

% plot Fourier coeff. 
if true
    subplot('Position', [.33 0.2 .28 .6])
    plot (1:n, xx1, '.-r', 'LineWidth', .5); hold on;
    plot (1:n, xx2, 'o-b', 'LineWidth', .5, 'Markersize', 2); hold off;

    xlim ([1 n])
    title ('Fourier coefficients')
    xlabel ('$k$', 'Interpreter', 'latex');
    fs = 13;
    legend({'${\hat {\mathbf x}}^{\rm Gr}(k)$', '${\hat {\mathbf x}}^{\rm Lp}(k)$'}, 'interpreter', 'latex', 'FontSize', fs)
end

% Compare approximation error
[sxx1 I1] = sort (abs (xx1), 'descend');
[sxx2 I2] = sort (abs (xx2), 'descend');



subplot('Position', [.7 0.2 .28 .6])
for i = 1:n
    if linear  % use first n term to approximate
        e2 (i) = norm (G.U(:,1:i) * xx2 (1:i) - x, 2) / norm (x);
        e1 (i) = norm (U_tree(:,1:i) * xx1 (1:i) - x, 2) / norm (x);
    else    % use largest n term to 
        y2 = G.U (:, I2(1:i)) * xx2 (I2(1:i));
        e2 (i) = norm (y2 - x, 2) / norm (x, 2);
        y1 = U_tree (:, I1(1:i)) * xx1 (I1(1:i));
        e1 (i) = norm (y1 - x, 2) / norm (x, 2);
    end
end
plot (1:n, e1, '.-r', 'LineWidth', .5); hold on;
plot (1:n, e2, 'o-b', 'LineWidth', .5, 'Markersize', 3); hold off;
xlim ([1 n])
if linear 
    title ('First n-term Approx. Error')
else
    title ('n-term approximation error')
end

xlabel ('$n$', 'Interpreter', 'latex');
legend({'$\varepsilon^{\rm Gr}(n)$', '$\varepsilon^{\rm Lp}(n)$'}, 'interpreter', 'latex', 'FontSize', fs)

w = 21; h = 7; 
set(gcf, 'PaperPosition', [0 0 w h]); %Position plot at left hand corner with width 5 and height 5.
set(gcf, 'PaperSize', [w h]); %Set the paper to have width 5 and height 5.

if true
    figpath = 'fig\Exp3\';
    if swiss
        saveas(gcf, strcat(figpath, 'swiss',int2str(linear)), 'png')
    else
        saveas(gcf, strcat(figpath, 'sim',int2str(linear)), 'png')
    end
end