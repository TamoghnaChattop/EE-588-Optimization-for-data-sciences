clear all;
sep3way_data

cvx_begin
    variables a1(2) a2(2) a3(2) b1 b2 b3
    (a1 - a2)'*X - (b1 - b2) >= 1
    (a1 - a3)'*X - (b1 - b3) >= 1
    (a2 - a1)'*Y - (b2 - b1) >= 1
    (a2 - a3)'*Y - (b2 - b3) >= 1
    (a3 - a1)'*Z - (b3 - b1) >= 1
    (a3 - a2)'*Z - (b3 - b2) >= 1
    a1 + a2 + a3 == 0
    b1 + b2 + b3 == 0
cvx_end

% maximally confusing point
p = [(a1-a2)';(a1-a3)']\[(b1-b2);(b1-b3)];

% plot
plot(X(1,:),X(2,:),'*');
hold on;
plot(Y(1,:),Y(2,:),'ro');
plot(Z(1,:),Z(2,:),'g+');
plot(p(1),p(2),'ks');

t = [-5:0.01:8];
u1 = a1 - a2; v1 = b1 - b2;
u2 = a2 - a3; v2 = b2 - b3;
u3 = a3 - a1; v3 = b3 - b1;

line1 = (-t*u1(1) + v1)/u1(2);
idx1 = find(u2'*[t;line1] - v2 > 0);
plot(t(idx1),line1(idx1));

line2 = (-t*u2(1) + v2)/u2(2);
idx2 = find(u3'*[t; line2] - v3 > 0);
plot(t(idx2),line2(idx2),'r');

line3 = (-t*u3(1) + v3)/u3(2);
idx3 = find(u1'*[t; line3] - v1 > 0);
plot(t(idx3),line3(idx3),'g');
