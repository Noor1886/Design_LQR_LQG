% Observability

clc; 
clear; 
close all;

syms M m1 m2 g l1 l2 F x x_dot theta1 theta1_dot theta2 theta2_dot;

x_ddot = (F-(m1*sin(theta1))*(g*cos(theta1)+l1*theta1_dot*theta1_dot)-m2*sin(theta2)*(g*cos(theta2)+l2*theta2_dot*theta2_dot)) ...
          /(M+m1*sin(theta1)*sin(theta1)+m2*sin(theta2)*sin(theta2)); 
theta1_ddot = (x_ddot*cos(theta1)-g*sin(theta1))/l1;
theta2_ddot = (x_ddot*cos(theta2)-g*sin(theta2))/l2;

A = [diff(x_dot,x), diff(x_dot,x_dot), diff(x_dot,theta1), ... 
     diff(x_dot,theta1_dot), diff(x_dot,theta2), diff(x_dot,theta2_dot); ...
     diff(x_ddot,x), diff(x_ddot,x_dot), diff(x_ddot,theta1), ...
     diff(x_ddot,theta1_dot), diff(x_ddot,theta2), diff(x_ddot,theta2_dot); ...
     diff(theta1_dot,x), diff(theta1_dot,x_dot), diff(theta1_dot,theta1), ...
     diff(theta1_dot,theta1_dot), diff(theta1_dot,theta2), diff(theta1_dot,theta2_dot); ...
     diff(theta1_ddot,x), diff(theta1_ddot,x_dot), diff(theta1_ddot,theta1), ...
     diff(theta1_ddot,theta1_dot), diff(theta1_ddot,theta2), diff(theta1_ddot,theta2_dot); ...
     diff(theta2_dot,x), diff(theta2_dot,x_dot), diff(theta2_dot,theta1), ...
     diff(theta2_dot,theta1_dot), diff(theta2_dot,theta2), diff(theta2_dot,theta2_dot); ...
     diff(theta2_ddot,x), diff(theta2_ddot,x_dot), diff(theta2_ddot,theta1), ...
     diff(theta2_ddot,theta1_dot), diff(theta2_ddot,theta2), diff(theta2_ddot,theta2_dot)];


A1 = subs(A,[x, x_dot, theta1, theta1_dot, theta2, theta2_dot],[0, 0, 0, 0, 0, 0]);

B = [x_dot, x_ddot, theta1_dot, theta1_ddot, theta2_dot, theta2_ddot];

B1 = subs(transpose(B),[x, x_dot, theta1, theta1_dot, theta2, theta2_dot, F],[0, 0, 0, 0, 0, 0, 1]);

%newA = subs(A1,[M,m1,m2,l1,l2,g],[1000,100,100,20,10,9.8]);
%newB = subs(B1,[M,m1,m2,l1,l2,g],[1000,100,100,20,10,9.8]);

% Output vector x, (theta1, theta2), (x, theta2) or (x, theta1, theta2)
% Y = CX + DU
% The state equation is observable if and only if the observability matrix
% satisfies rank[CT ATCT ... (AT)^(n-1)CT ] = n

C1 = [1, 0, 0, 0, 0, 0];
C2 = [0, 0, 1, 0, 1, 0];
C3 = [1, 0, 0, 0, 1, 0];
C4 = [1, 0, 1, 0, 1, 0];

% Observability

fprintf('Obervability Matrix\n')
O1 = [C1.', A1.'*C1.', A1.'*A1.'*C1.', A1.'*A1.'*A1.'*C1.', A1.'*A1.'*A1.'*A1.'*C1.', A1.'*A1.'*A1.'*A1.'*A1.'*C1.' ];
fprintf('rank of C1(x) is %d\n', rank(O1))


O2 = [C2.', A1.'*C2.', A1.'*A1.'*C2.', A1.'*A1.'*A1.'*C2.', A1.'*A1.'*A1.'*A1.'*C2.', A1.'*A1.'*A1.'*A1.'*A1.'*C2.' ];
fprintf('rank of C2(theta1, theta2) is %d\n', rank(O2))

O3 = [C3.', A1.'*C3.', A1.'*A1.'*C3.', A1.'*A1.'*A1.'*C3.', A1.'*A1.'*A1.'*A1.'*C3.', A1.'*A1.'*A1.'*A1.'*A1.'*C3.' ];
fprintf('rank of C3(x, theta2) is %d\n', rank(O3))

O4 = [C4.', A1.'*C4.', A1.'*A1.'*C4.', A1.'*A1.'*A1.'*C4.', A1.'*A1.'*A1.'*A1.'*C4.', A1.'*A1.'*A1.'*A1.'*A1.'*C4.' ];
fprintf('rank of C4(x, theta1, theta2) is %d\n', rank(O4))


