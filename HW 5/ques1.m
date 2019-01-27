clear all;
nonlin_meas_data

row = zeros(1,m);
row(1) = -1;
row(2) = 1;
col = zeros(1,m-1);
col(1) = -1;
B = toeplitz(col,row);

cvx_begin
    variable x(n);
    variable z(m);
    minimize(norm(z-A*x));
    subject to
        1/beta*B*y <= B*z;
        B*z <= 1/alpha*B*y;
cvx_end

disp('estimated x:'); disp(x);
plot(z,y)
ylabel('y')
xlabel('z')
title('ML estimate of \phi')