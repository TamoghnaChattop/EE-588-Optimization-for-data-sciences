clear all;
pwl_fit_data;

m = length(x);

% For fine-grained pwl function plot
xp = 0:0.001:1; 
mp = length(xp);
yp = [];

for K = 1:4 
    a = [0:1/K:1]'; % a_0,...,a_K
    % matrix for sum f(x_i)
    F = sparse(1:m,max(1,ceil(x*K)),1,m,K);
    
    cvx_begin
        variables alpha1(K) beta1(K)
        minimize(norm(diag(x)*F*alpha1+F*beta1-y))
        subject to
        if (K>=2)
           alpha1(1:K-1).*a(2:K)+beta1(1:K-1) == alpha1(2:K).*a(2:K)+beta1(2:K)
           a(1:K-1) <= a(2:K)
        end
    cvx_end

    fp = sparse(1:mp,max(1,ceil(xp*K)),1,mp,K);
    yp = [yp diag(xp)*fp*alpha1+fp*beta1];
end

plot(x,y,'b.',xp,yp);