function u = find_uk_real ( W, U, par )
% find the k-th l1 basis vector given the first k-1 l1 basis vectors U
% by enumerating all the partitions 

n = size (W, 1);

mins = -1;  % current minimum total variation
u = [];     % the k-th l1 basis vector

for i = 1:length (par)                  % enumerate all the partitions par{i}
    H = p2H (par{i}, n);                % generate the matrix H by par{i}
    A = [U H];                          % combine conditions U' x = 0 and H' x = 0 to give A' = 0
    
    if rank (A) ~= n-1, continue, end   % skip if rank (A) ~= 1
    
    xi = null (A');                     % solve A' x = 0 to get xi
    xi = xi / sqrt (xi'*xi);            % normalize xi
    
    s = double (find_gav (W, xi));      % compute s = total variation of xi
    
    if mins < 0 || s < mins             % if s < current minimum value
        mins = s;                       % save s and xi
        u = xi;                 
    end
end

end

