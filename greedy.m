function U = greedy (W)
% find the greedy basis of an undirected graph G with weight matrix W

n = size (W, 1);
R = W;          % mutual weight R(i,j) = W (i,j) / (s(i) * s(j))
s = ones (1,n); % size of each group of vertices
label = 1:n;    % the i-th vertice is in the label(i) group
U = [];

lAB = [];       % length of Ak and Bk

for k = 1:n-1
  
    % (mi, mj) = arg max R(i,j)
    [M I] = max (R(:)); 
    [mi, mj] = ind2sub (size(R), I);
    assert (mi ~= mj);
    % swap mi, mj if mi > mj
    if mi > mj
        t = mi; mi = mj; mj = t;
    end
    % [mi mj];
    
    % A = the group of mi,  B = the group of mj
    A = find (label == mi);
    B = find (label == mj);
    
    % update label
    label (label == mj) = mi;
    
    % compute greedy basis u_k
    uk = zeros (n,1);
    lA = length (A);
    lB = length (B);
    z = lA+lB; lAB = [z, lAB];
    t = 1 / sqrt (lA * lB * (lA + lB) );
    uk (A) = -lB * t;
    uk (B) = lA * t;
    U = [uk U];
    
    % update W
    W (mi, :) = W (mi, :) + W (mj, :);  % W (
    W (:, mi) = W (:, mi) + W (:, mj);
    W (mi, mi) = 0;
    W (mj, :) = 0;
    W (:, mj) = 0;
    
    % update s
    s(mi) = s(mi) + s(mj);
    s(mj) = -1;

    % update R
    % z = s (mi) * ones (1, n);  z = max (z, s);   % R (A,B) = W (A,B) / max (|A|, |B|)
    z = s (mi) * s;         % z(j) = |group(mi)| * |group(mj)|

    R (mi, :) = W (mi, :) ./ z;     % R (mi, j) = W (mi, j) / z (j)
    R (:, mi) = R (mi, :)';
    R (mj, :) = 0;
    R (:, mj) = 0;

end

u1 = ones (n,1) / sqrt(n);
U = [u1 U];

