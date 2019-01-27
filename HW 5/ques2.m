clear all;
ml_estim_incr_signal_data

% maximum likelihood estimation with no monotonicity taken into account

cvx_begin
    variable xls(N)
    yhat = conv(h,xls);
    minimize (sum_square(yhat(1:end-3) - y))
cvx_end

% monotonic and non negative signal estimation

cvx_begin
    variable xmono(N)
    yhat = conv(h,xmono);
    minimize (sum_square(yhat(1:end-3) - y))
    subject to
        xmono(1) >= 0;
        xmono(1:N-1) <= xmono(2:N);
cvx_end

t = 1:N;
figure;
set(gca, 'FontSize', 12);
plot(t, xtrue, 'r', t, xmono, '--', t, xls, 'k:');
xlabel('t');
legend('xt', 'xmono', 'xls', 'Location', 'SouthEast');


