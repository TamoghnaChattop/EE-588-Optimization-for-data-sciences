clear all;
pwl_fit_data;

cvx_quiet('true')
figure
plot(x,y,'k:','linewidth',2)
hold on

% Single line
p = [x ones(100,1)]\y;
alpha = p(1)
beta = p(2)
plot(x,alpha*x+beta,'b','linewidth',2)
mse = norm(alpha*x+beta-y)^2

for K = 2:4
   % Generate Lagrange basis
   a = (0:(1/K):1)';
   F = max((a(2)-x)/(a(2)-a(1)),0);
   for k = 2:K
      a_1 = a(k-1);
      a_2 = a(k);
      a_3 = a(k+1);
      f = max(0,min((x-a_1)/(a_2-a_1),(a_3-x)/(a_3-a_2)));
      F = [F f];
   end
   f = max(0,(x-a(K))/(a(K+1)-a(K)));
   F = [F f];

   cvx_begin
      variable z(K+1)
      minimize(norm(F*z-y))
      subject to
      (z(3:end)-z(2:end-1))./(a(3:end)-a(2:end-1)) >= (z(2:end-1)-z(1:end-2))./(a(2:end-1)-a(1:end-2))
   cvx_end

   % Calculate alpha and beta
   alpha = (z(2:end)-z(1:end-1))./(a(2:end)-a(1:end-1))
   beta = z(2:end)-alpha(1:end).*a(2:end)

   % Plot solution
   y2 = F*z;
   mse = norm(y2-y)^2
   if K==2
       plot(x,y2,'r','linewidth',2)
   elseif K==3
       plot(x,y2,'g','linewidth',2)
   else
       plot(x,y2,'m','linewidth',2)
   end
end

xlabel('x')
ylabel('y')
