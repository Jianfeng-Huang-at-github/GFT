% Experiment 2: Compare errors between greedy basis and l1 basis

clc;
clear

compare_u2 = false;   % true to compare u2; false to compare U

load ('B.mat', 'B');

N = 8;
K = 100;
for n = 3:N

    R_gr = zeros (K, 1);
    R_lap = zeros (K, 1);
    for k = 1:K
        W = B (n, k).W;
        if compare_u2
            s_real = find_gav (W, B (n,k).U_real (:,2));
            s_gr = find_gav (W, B (n,k).U_greedy (:,2));
            s_lap  = find_gav (W, B (n,k).U_lap (:,2));
        else
            s_real = find_gav (W, B (n,k).U_real);
            s_gr = find_gav (W, B (n,k).U_greedy);
            s_lap  = find_gav (W, B (n,k).U_lap);
        end

        R_gr (k) = (s_gr - s_real) / s_real;
        R_lap (k) = (s_lap - s_real) / s_real;
    end

    % average of error 
    m_gr (n) = mean (R_gr);
    m_lap (n) = mean (R_lap);

end

plot (3:N, m_gr(3:N), 'r*-', 'LineWidth', 1.5, 'MarkerSize', 8); hold on;
plot (3:N, m_lap (3:N), 'bo-', 'LineWidth', 1.5, 'MarkerSize', 8); hold on;

set(gca,'xtick',3:N);
set(gca, 'FontSize', 18)
xlabel ('$N$', 'Interpreter', 'latex');

if compare_u2
    legend({'err$({\mathbf u}^{\rm Gr}_2,{\mathbf u}^{\ell_1}_2)$', 'err$(\mathbf{u}_2^{\rm Lp}, \mathbf{u}^{\ell_1}_2)$'}, 'interpreter', 'latex', 'Location', 'NorthWest')
    axis ([2 N+1 -.1 .8])	
else
    legend({'err$(\mathbf{U}^{\rm Gr},\mathbf{U}^{\ell_1})$', 'err$(\mathbf{U}^{\rm Lp}, \mathbf{U}^{\ell_1})$'}, 'interpreter', 'latex', 'Location', 'NorthWest')
    axis ([2 N+1 -.1 .4])	
end

set (gca, 'Position', [.2 .2 .7 .7]);

grid on

% save fig
if true
    w = 16;
    h = 10;
    set(gcf, 'PaperPosition', [0 0 w h]); %Position plot at left hand corner with width 5 and height 5.
    set(gcf, 'PaperSize', [w h]); %Set the paper to have width 5 and height 5.

    figpath = 'fig\Exp2\';
    if compare_u2
        saveas(gcf, strcat (figpath, 'error_u2_gr'), 'png')
    else
        saveas(gcf, strcat (figpath, 'error_U_gr'), 'png')
    end
end    

