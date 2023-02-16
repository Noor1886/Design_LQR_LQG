clc 
clear all

M=1000;
m1=100;m2=100;
l1=20;l2=10;
g=10;

%%State Space form of the System

A=[0 1 0 0 0 0
    0 0 (-g*m1)/M 0 (-g*m2)/M 0
    0 0 0 1 0 0
    0 0 (-g*(m1+M))/(M*l1) 0 (-g*m2)/(M*l1) 0
    0 0 0 0 0 1
    0 0 (-g*m1)/(M*l2) 0 (-g*(m2+M))/(M*l2) 0 ];
    

B=[ 0
    1/M
    0
    1/(M*l1)
    0
    1/(M*l2)];

C= [ 1 0 0 0 0 0 
      0 0 1 0 0 0
      0 0 0 0 1 0];
  
  
  
  % We know that from the Checks_for_Observability the pair A,C is observable only for
  %1.System is Observable for x(t)
  %2.System is Observable for (x,t2)
  %3.System is Observable for (x,t1,t2)
  
Q=diag([50 1500 50000 120000 500000 80000]);
R=0.01;

disp(' State FeedBack')
%State FeedBack 'K'
K=lqr(A,B,Q,R);
%size(K)
disp(K)

disp('Eigen Values of (A-B*K)')
% The Pole Placement should be faster than the eigen values of (A-B*K)
Eig_Vals= eig(A-B*K);
disp(Eig_Vals)

%Arbitrary Pole Placement
Poles=[-1 -2 -3 -4 -5 -6];

%State Outputs for the system that are Observable
C1=[1 0 0 0 0 0];
C3=[1 0 0 0 0 0
    0 0 0 0 1 0];
C4=[1 0 0 0 0 0
    0 0 1 0 0 0
    0 0 0 0 1 0];
% for C_l=C1:C3
%     L=place(A',C_l',Poles)';
% end

L1=place(A',C1',Poles)';
L2=place(A', C3',Poles)';
L3=place(A', C4',Poles)';
size(C1)
%% System Matrices for each state of the Observer

%For x(t)
A_L1=[(A-B*K) (B*K)
    zeros(6,6) (A-L1*C1)];
B_L1=[B
    zeros(size(B))];
C_L1=[C1 zeros(size(C1))];
%For (x(t),theta2)
A_L2=[(A-B*K) (B*K)
    zeros(6,6) (A-L2*C3)];
B_L2=[B
    zeros(size(B))];
C_L2=[C3 zeros(size(C3))];
%For (x(t),theta2, theta1)
A_L3=[(A-B*K) (B*K)
    zeros(6,6) (A-L3*C4)];
B_L3=[B
    zeros(size(B))];
C_L3=[C4 zeros(size(C4))];

%% State Space representation of the Linear system
SS2=ss(A_L2,B_L2,C_L2,0);
SS1=ss(A_L1,B_L1,C_L1,0)
SS3=ss(A_L3,B_L3,C_L3,0);

%% Visualizing Positions From STEP function
% X=[0;0;10*pi/180;0;15*pi/180;0];
figure(1)
step(SS1)
title('observability for outputvector_1')
xlabel('T')
ylabel('x')

figure(2)
step(SS2)
title('observability for outputvector_2')
xlabel('T')
ylabel('x')

figure(3)
step(SS3)
title('observability for outputvector_3')
xlabel('T')
ylabel('x')