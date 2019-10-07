function plot_U (G, U, N1, N2, wmargin, hmargin, param, str_u)
% Plot a basis U = [u_1,u_2, ..., u_n] on the graph G
% in an array of N1 rows and N2 columns

w = 1.0 / N2; 
h = 1.0 / N1;

for i = 1:N1
    for j = 1:N2
		% the (i,j) th subplot
		x = (j-1) * w + w * wmargin;
		y = 1 - i*h + h * hmargin;
		dx = (1 - 2 * wmargin) * w;
		dy = (1 - 2 * hmargin) * h;
		subplot('Position', [x y dx dy]);

		% plot the k-th basis vector U(;,k)
		k = N2 * (i-1) + j;
		gsp_plot_signal (G, U(:,k), param) 
		title (strcat (str_u,'_{',num2str(k), '}$'), 'interpreter', 'latex', 'FontSize', 15);
    end
end

