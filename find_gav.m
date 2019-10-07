function s = find_gav ( W, X )
% Find the sum of total variation of the column vectors of X, i.e, 
% TV(X(:,1)) + TV (X(:,2)) + ... + TV (X(:,n))

n = size (W, 1);
D = diffmat (n, W);
s = sum (sum (abs(D*X)));

end

