function H = p2H ( p, n )
% p is a partition of vertices {1,...,n}, corresponding to different values
% of a vector x.
% For example, if p = {{1,2,3}, {4,5}}, then x1 = x2 = x3, x4 = x5.
% The equalities x1 = x2 = x3, x4 = x5 can be expressed in matrix form H' x = 0, where
% H = [1 -1 0 0 0; 
%      0 1 -1 0 0; 
%      0 0 0 1 -1]'

H = [];
for k = 1:length(p)
    %  p{k} = {x_i1, x_i2, ...} means x_i1 = x_i2 = ... 
    s = p{k};               
    if length(s) > 1
        for i = 1:length(s)-1
            h = zeros (n, 1);
            h (s(i))  = 1;
            h (s(i+1)) = -1;   % h = [...0, 1, 0 ... 0, -1, 0 ...] 
            H = [H h];
        end
    end
end