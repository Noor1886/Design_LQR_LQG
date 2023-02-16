M=1000;
m1=100;m2=100;
l1=20;l2=10;
g=10;

%% State Space form of the System

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
  
 % Check for Controllability
disp('CONTROLLABILITY CHECK') 

% Using the generalized form rank([B B*A B*A^2 B*A^3 B*A^4 B*A^5])=size(A)

rank_check=rank([B A*B (A^2)*B (A^3)*B (A^4)*B (A^5)*B]);

if rank_check==6
    disp('System is Controllable')
else
    disp('System is Not Controllable')
end

% DESIGN FOR LQR CONTROLLER
%% We Observed that the system is Controllable, So we now determine the stateFeed back (K)
 
%Adjusting Cost  'Q' until the system is controllable
%R=0.01
Q=diag([50 1500 50000 120000 500000 80000]);
R=0.01;

%State FeedBack 'K'
K=lqr(A,B,Q,R);
%size(K)
disp(K)

%New State Space System would be ''X= (A-B*K)x + B*U''

A_N=[A-B*K];
States={'x' 'x_dot' 'theta1' 'theta1_dot' 'theta2' 'theta2_dot'};
input={'F'};
Outputs = {'x'; 'alpha1'; 'alpha2'};

%Converting to a State Space Model
sys=ss(A_N,B,C,0,'statename',States,'inputname',input,'outputname',Outputs);

%% Simulating the linearState responses to the initial conditions

X=[0;0;15*pi/180;0;15*pi/180;0];
t = 0:0.01:150;
dim_t= size(t);
F = zeros(dim_t);
[Y, t_T, X_T] = lsim(sys, F, t, X);
size(Y)
%% Visualization
figure,
plot(t, Y(:,1));
xlabel('Time'); ylabel('Crane Position');

figure,
plot(t, Y(:,2));
xlabel('Time'); ylabel('Pendulum Angle theta_1');

figure,
plot(t, Y(:,3));
xlabel('Time'); ylabel('Pendulum Angle theta_2');
% Using the Lynapunov indirect Method to Obtain Stability 

%System has been Linearized
Ly_St= eig(A_N)
if real(Ly_St)<1
    disp('System is Stable')
else
    disp('System is not Stable')
end
