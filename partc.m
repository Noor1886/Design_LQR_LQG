syms m1 m2 m l1 l2 g
%% A matrix
A=[0 1 0 0 0 0; 0 0 -(m1*g)/m 0 -(m2*g)/m 0; 0 0 0 1 0 0;
0 0 (-(m1*g)/(m*l1) -(g/l1)) 0 -(m2*g)/(m*l1) 0;
0 0 0 0 0 1;
0 0 -(m1*g)/(m*l2) 0 (-(m2*g)/(m*l2) -(g/l2)) 0 ];
%% B matrix
B=[0; 1/m; 0; 1/(m*l1); 0; 1/(m*l2)];
%% Check for Controlability
Control_matrix=[B A*B A^2*B A^3*B A^4*B A^5*B]
simplify(Control_matrix)
rank(Control_matrix)
