clear all
close all

%symbolical variables
syms q1_symb q2_symb q3_symb  d1_symb d2_symb d3_symb x real

% set angles 
q = [q1_symb q2_symb q3_symb];
q_test1 = [0 0 0];
q_test2 = [0 -1.2566 2.3562];

%Link lengths
L=[d1_symb d2_symb d3_symb];
L_test=[1, 1, 1];


%%
%FK
FK=Rz(q(1))*Tz(L(1))*Ry(q(2))*Tx(L(2))*Ry(q(3))*Tx(L(3))  ;
simplify(FK);

T=double(subs(FK, [q L], [q_test2 L_test]));

draw_robot(q_test2,L_test)



%%

%Jacobian Numerial method

H = Rz(q(1))*Tz(L(1))*Ry(q(2))*Tx(L(2))*Ry(q(3))*Tx(L(3)) ;% forward kinematics
H=simplify(H);
R = simplify(H(1:3,1:3));  % extract rotation matrix
% diff by q1
Td=Rzd(q(1))*Tz(L(1))*Ry(q(2))*Tx(L(2))*Ry(q(3))*Tx(L(3))*...
    [R^-1 zeros(3,1);0 0 0 1];
J_1 = [Td(1,4), Td(2,4), Td(3,4), Td(3,2), Td(1,3), Td(2,1)]' ; % extract 6 components from 4x4 Td matrix to Jacobian 1st column
% diff by q2
Td=Rz(q(1))*Tz(L(1))*Ryd(q(2))*Tx(L(2))*Ry(q(3))*Tx(L(3))*...
    [R^-1 zeros(3,1);0 0 0 1];
J_2 = [Td(1,4), Td(2,4), Td(3,4), Td(3,2), Td(1,3), Td(2,1)]' ; % extract 6 components from 4x4 Td matrix to Jacobian 1st column
% diff by q3
Td=Rz(q(1))*Tz(L(1))*Ry(q(2))*Tx(L(2))*Ryd(q(3))*Tx(L(3))*...
    [R^-1 zeros(3,1);0 0 0 1];
J_3 = [Td(1,4), Td(2,4), Td(3,4), Td(3,2), Td(1,3), Td(2,1)]' ; % extract 6 components from 4x4 Td matrix to Jacobian 1st column

% Full Jacobian 6x3
Jq1 = [simplify(J_1), simplify(J_2), simplify(J_3)]


%%  fist exercise. polinomial


%fist join
qn=[0 2];
tn=[0 2];
v=[0 0];
acc=[0 0];

A=[1 tn(1) tn(1)^2 tn(1)^3 tn(1)^4 tn(1)^5  
   0 1 2*tn(1) 3*tn(1)^2 4*tn(1)^3 5*tn(1)^4 
   0 0 2 6*tn(1) 12*tn(1)^2 20*tn(1)^3 
   1 tn(2) tn(2)^2 tn(2)^3 tn(2)^4 tn(2)^5
   0 1 2*tn(2) 3*tn(2)^2 4*tn(2)^3 5*tn(2)^4
   0 0 2 6*tn(2) 12*tn(2)^2 20*tn(2)^3];
c=[qn(1);v(1);acc(1);qn(2);v(2);acc(2)];
b=A\c

syms t
q_1=b(1)+b(2)*t + b(3)*t^2 + b(4)*t^3 + b(5)*t^4 + b(6)*t^5;
simplify(q_1)

t=linspace(tn(1),tn(end),100);
q1=b(1)+b(2).*t + b(3).*t.^2 + b(4).*t.^3 + b(5).*t.^4 + b(6).*t.^5 ;
qd1=0 +b(2) + 2*b(3).*t + 3*b(4).*t.^2 + 4*b(5).*t.^3 + 5*b(6).*t.^4 ;
qdd1=0 +0 +  2 + 6*b(4).*t + 12*b(5).*t.^2 + 20*b(6).*t.^3 ;


%second join
qn=[0 3];
tn=[0 2];
v=[0 0];
acc=[0 0];

A=[1 tn(1) tn(1)^2 tn(1)^3 tn(1)^4 tn(1)^5  
   0 1 2*tn(1) 3*tn(1)^2 4*tn(1)^3 5*tn(1)^4 
   0 0 2 6*tn(1) 12*tn(1)^2 20*tn(1)^3 
   1 tn(2) tn(2)^2 tn(2)^3 tn(2)^4 tn(2)^5
   0 1 2*tn(2) 3*tn(2)^2 4*tn(2)^3 5*tn(2)^4
   0 0 2 6*tn(2) 12*tn(2)^2 20*tn(2)^3];
c=[qn(1);v(1);acc(1);qn(2);v(2);acc(2)];
b=A\c

syms t
q_2=b(1)+b(2)*t + b(3)*t^2 + b(4)*t^3 + b(5)*t^4 + b(6)*t^5;
simplify(q_2)

t=linspace(tn(1),tn(end),100);
q2=b(1)+b(2).*t + b(3).*t.^2 + b(4).*t.^3 + b(5).*t.^4 + b(6).*t.^5 ;
qd2=0 +b(2) + 2*b(3).*t + 3*b(4).*t.^2 + 4*b(5).*t.^3 + 5*b(6).*t.^4 ;
qdd2=0 +0 +  2 + 6*b(4).*t + 12*b(5).*t.^2 + 20*b(6).*t.^3 ;


%third join
qn=[0 4];
tn=[0 2];
v=[0 0];
acc=[0 0];

A=[1 tn(1) tn(1)^2 tn(1)^3 tn(1)^4 tn(1)^5  
   0 1 2*tn(1) 3*tn(1)^2 4*tn(1)^3 5*tn(1)^4 
   0 0 2 6*tn(1) 12*tn(1)^2 20*tn(1)^3 
   1 tn(2) tn(2)^2 tn(2)^3 tn(2)^4 tn(2)^5
   0 1 2*tn(2) 3*tn(2)^2 4*tn(2)^3 5*tn(2)^4
   0 0 2 6*tn(2) 12*tn(2)^2 20*tn(2)^3];
c=[qn(1);v(1);acc(1);qn(2);v(2);acc(2)];
b=A\c


syms t
q_3=b(1)+b(2)*t + b(3)*t^2 + b(4)*t^3 + b(5)*t^4 + b(6)*t^5;
simplify(q_3)


t=linspace(tn(1),tn(end),100);
q3=b(1)+b(2).*t + b(3).*t.^2 + b(4).*t.^3 + b(5).*t.^4 + b(6).*t.^5 ;
qd3=0 +b(2) + 2*b(3).*t + 3*b(4).*t.^2 + 4*b(5).*t.^3 + 5*b(6).*t.^4 ;
qdd3=0 +0 +  2 + 6*b(4).*t + 12*b(5).*t.^2 + 20*b(6).*t.^3 ;

% uncomment to get all plots
% figure   
% plot(t,q1)
% title('q1')
% figure
% plot(t,qd1)
% title('qd1')
% figure
% plot(t,qdd1)
% title('qdd1')
% 
% figure
% plot(t,q2)
% title('q2')
% figure
% plot(t,qd2)
% title('qd2')
% figure
% plot(t,qdd2)
% title('qdd2')
% 
% figure
% plot(t,q2)
% title('q3')
% figure
% plot(t,qd2)
% title('qd3')
% figure
% plot(t,qdd2)
% title('qdd3')
% 

%% trapezoidal trayectory
q1i = 0; q1f = 2; vmax1 = 1; accmax1 = 10;
q2i = 0; q2f = 3; vmax2 = 1; accmax2 = 10;
q3i = 0; q3f = 4; vmax3 = 1; accmax3 = 10;

v1i = 0; v2i = 0; v3i = 0;       % initial velocity for joints
acc1i = 0; acc2i = 0; acc3i = 0;   % initial acceleration for joints
delts_t = 0.01;  %f=100hz
n = 0;
while (floor(delts_t*10^n)~=delts_t*10^n)
    n=n+1;
end
E = 1*10^-n;

% getting maximun time ts and tf of the joints
%joint 1   ts,tf
t1s = vmax1/accmax1;
if rem(t1s,delts_t)~=0
    t1s_new = round(t1s,n)+E;
else
    t1s_new = round(t1s,n)+E;
end
t1f = (q1f-q1i)/vmax1 + t1s_new;
if rem(t1f,delts_t)~=0
    t1f_new = round(t1f,n)+E;
else
    t1f_new = round(t1f,n);
end

%joint 2 ts, tf
t2s = vmax2/accmax2;
if rem(t2s,delts_t)~=0
    t2s_new = round(t2s,n)+E;
else
    t2s_new = round(t2s,n);
end

t2f = (q2f-q2i)/vmax2 + t2s_new;
if rem(t2f,delts_t)~=0
    t2f_new = round(t2f,n)+E;
else
    t2f_new = round(t2f,n);
end

%joint 3   t,tf
t3s = vmax3/accmax3;
if rem(t3s,delts_t)~=0
    t3s_new = round(t3s,n)+E;
else
    t3s_new = round(t3s,n);
end

t3f = (q3f-q3i)/vmax3 + t3s_new;
if rem(t3f,delts_t)~=0
    t3f_new = round(t3f,n)+E;
else
    t3f_new = round(t3f,n);
end

if (t3f_new > t2f_new) && (t3f_new > t1f_new)
    tf_new = t3f_new;
    ts_new = t3s_new;
elseif (t2f_new > t1f_new)  && (t2f_new > t3f_new)
    tf_new = t2f_new;
    ts_new = t2s_new;
else
    tf_new = t1f_new;
    ts_new = t1s_new;
end

ts_new
tf_new
% recompute accelerations and velocities with the news times ts and tf
vmax1_new = ((q1f-q1i)/(tf_new-ts_new))
amax1_new = vmax1_new/ts_new
vmax2_new = ((q2f-q2i)/(tf_new-ts_new))
amax2_new = vmax2_new/ts_new
vmax3_new = ((q3f-q3i)/(tf_new-ts_new))
amax3_new = vmax3_new/ts_new

% joint 1 - coefficients:
% t0 --> ts: 
joint1_a10 = q1i;
joint1_a11 = v1i;
joint1_a12 = 0.5*amax1_new;
% ts --> tf-ts:
joint1_a20 = q1i + 0.5*amax1_new*ts_new^2 - vmax1_new*ts_new;
a21 = vmax1_new;
% tf-ts --> tf:
joint1_a30 = q1f - 0.5*amax1_new*tf_new^2;
joint1_a31 = amax1_new*tf_new;
joint1_a32 = -0.5*amax1_new;

% joint 2 - coefficients:
% t0 --> ts:
joint2_a10 = q2i;
joint2_a11 = v2i;
joint2_a12 = 0.5*amax2_new;
% ts --> tf-ts:
joint2_a20 = q2i + 0.5*amax2_new*ts_new^2 - vmax2_new*ts_new;
joint2_a21 = vmax2_new;
% tf-ts --> tf:
joint2_a30 = q2f - 0.5*amax2_new*tf_new^2;
joint2_a31 = amax2_new*tf_new;
joint2_a32 = -0.5*amax2_new;

% joint 3 - coefficients:
% t0 --> ts:
joint3_a10 = q3i;
joint3_a11 = v3i;
joint3_a12 = 0.5*amax3_new;
% ts --> tf-ts:
joint3_a20 = q3i + 0.5*amax3_new*ts_new^2 - vmax3_new*ts_new;
joint3_a21 = vmax3_new;
% tf-ts --> tf:
joint3_a30 = q3f - 0.5*amax3_new*tf_new^2;
joint3_a31 = amax3_new*tf_new;
joint3_a32 = -0.5*amax3_new;


t = 0:delts_t:tf_new;
q1 = (joint1_a10+joint1_a11.*t+joint1_a12.*t.^2).*(t<=ts_new)...
    +(joint1_a20+a21.*t).*(t>ts_new).*(t<=(tf_new-ts_new))...
    +(joint1_a30+joint1_a31.*t+joint1_a32.*t.^2).*(t>(tf_new-ts_new)).*(t<=tf_new);
v1 = (joint1_a11+2*joint1_a12.*t).*(t<=ts_new)...
    +(a21).*(t>ts_new).*(t<=(tf_new-ts_new))...
    +(joint1_a31+2*joint1_a32.*t).*(t>(tf_new-ts_new)).*(t<=tf_new);
acc1 = (2*joint1_a12).*(t<=ts_new)...
    +(0).*(t>ts_new).*(t<=(tf_new-ts_new))...
    +(2*joint1_a32).*(t>(tf_new-ts_new)).*(t<=tf_new);
q2 = (joint2_a10+joint2_a11.*t+joint2_a12.*t.^2).*(t<=ts_new)...
    +(joint2_a20+joint2_a21.*t).*(t>ts_new).*(t<=(tf_new-ts_new))...
    +(joint2_a30+joint2_a31.*t+joint2_a32.*t.^2).*(t>(tf_new-ts_new)).*(t<=tf_new);
v2 = (joint2_a11+2*joint2_a12.*t).*(t<=ts_new)...
    +(joint2_a21).*(t>ts_new).*(t<=(tf_new-ts_new))...
    +(joint2_a31+2*joint2_a32.*t).*(t>(tf_new-ts_new)).*(t<=tf_new);
acc2 = (2*joint2_a12).*(t<=ts_new)...
    +(0).*(t>ts_new).*(t<=(tf_new-ts_new))....
    +(2*joint2_a32).*(t>(tf_new-ts_new)).*(t<=tf_new);
q3 = (joint3_a10+joint3_a11.*t+joint3_a12.*t.^2).*(t<=ts_new)...
    +(joint3_a20+joint3_a21.*t).*(t>ts_new).*(t<=(tf_new-ts_new))...
    +(joint3_a30+joint3_a31.*t+joint3_a32.*t.^2).*(t>(tf_new-ts_new)).*(t<=tf_new);
v3 = (joint3_a11+2*joint3_a12.*t).*(t<=ts_new)...
    +(joint3_a21).*(t>ts_new).*(t<=(tf_new-ts_new))...
    +(joint3_a31+2*joint3_a32.*t).*(t>(tf_new-ts_new)).*(t<=tf_new);
acc3 = (2*joint3_a12).*(t<=ts_new)...
    +(0).*(t>ts_new).*(t<=(tf_new-ts_new))....
    +(2*joint3_a32).*(t>(tf_new-ts_new)).*(t<=tf_new);

figure
plot(t,q1,'k','linewidth',2)
hold on
plot(t,q2,'r','linewidth',2)
hold on
plot(t,q3,'g','linewidth',2)
grid on
title('position(rad) vs time(s)')
legend('joint_1', 'joint_2','joint_3')
axis([0 tf_new -inf inf])

figure
plot(t,v1,'k','linewidth',2)
hold on
plot(t,v2,'r','linewidth',2)
hold on
plot(t,v3,'g','linewidth',2)
title('velocity(rad/s) vs time(s)')
legend('joint_1' , 'joint_2', 'joint_3')
grid on
axis([0 tf_new -inf inf])

figure
plot(t,acc1,'k','linewidth',2)
hold on
plot(t,acc2,'r','linewidth',2)
hold on
plot(t,acc3,'g','linewidth',2)
title('acceleration (rad/s^2)vs time(s)')
legend('joint_1','joint_2','joint_3')
grid on
axis([0 tf_new -inf inf])


%% 4. trapezoidal trayectory in task space (with out constrains in joinst space) 

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % trayectory planning to go from p1 to p2 with (trapezoidal)
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
xi = 1; xf = sqrt(2)/2; vmax1 = 1; accmax1 = 10;  %x
yi = 0; yf = sqrt(2)/2; vmax2 = 1; accmax2 = 10;  %y
zi = 1; zf = 1.2;       vmax3 = 1; accmax3 = 10;  %z

x_vi = 0; y_vi = 0; z_vi = 0;       % initial velocity 
acc1i = 0; acc2i = 0; acc3i = 0;   % initial acceleration f
delts_t = 0.01;  %f=100
n = 0;
while (floor(delts_t*10^n)~=delts_t*10^n)
    n=n+1;
end
E = 1*10^-n;

% getting maximun time ts and tf 
%cartesin x    ts,tf
t1s = vmax1/accmax1;
if rem(t1s,delts_t)~=0
    t1s_new = round(t1s,n)+E;
else
    t1s_new = round(t1s,n)+E;
end
t1f = (xf-xi)/vmax1 + t1s_new;
if rem(t1f,delts_t)~=0
    t1f_new = round(t1f,n)+E;
else
    t1f_new = round(t1f,n);
end

%cartesin y ts, tf
t2s = vmax2/accmax2;
if rem(t2s,delts_t)~=0
    t2s_new = round(t2s,n)+E;
else
    t2s_new = round(t2s,n);
end

t2f = (yf-yi)/vmax2 + t2s_new;
if rem(t2f,delts_t)~=0
    t2f_new = round(t2f,n)+E;
else
    t2f_new = round(t2f,n);
end

%cartesin z   t,tf
t3s = vmax3/accmax3;
if rem(t3s,delts_t)~=0
    t3s_new = round(t3s,n)+E;
else
    t3s_new = round(t3s,n);
end

t3f = (zf-zi)/vmax3 + t3s_new;
if rem(t3f,delts_t)~=0
    t3f_new = round(t3f,n)+E;
else
    t3f_new = round(t3f,n);
end

if (t3f_new > t2f_new) && (t3f_new > t1f_new)
    tf_new = t3f_new;
    ts_new = t3s_new;
elseif (t2f_new > t1f_new)  && (t2f_new > t3f_new)
    tf_new = t2f_new;
    ts_new = t2s_new;
else
    tf_new = t1f_new;
    ts_new = t1s_new;
end

ts_new
tf_new
% recompute accelerations and velocities with the news times ts and tf
vmax1_new = ((xf-xi)/(tf_new-ts_new))
amax1_new = vmax1_new/ts_new
vmax2_new = ((yf-yi)/(tf_new-ts_new))
amax2_new = vmax2_new/ts_new
vmax3_new = ((zf-zi)/(tf_new-ts_new))
amax3_new = vmax3_new/ts_new

% x - coefficients:
% t0 --> ts: 
cartesianx_a10 = xi;
cartesianx_a11 = x_vi;
cartesianx_a12 = 0.5*amax1_new;
% ts --> tf-ts:
cartesianx_a20 = xi + 0.5*amax1_new*ts_new^2 - vmax1_new*ts_new;
cartesianx_a21 = vmax1_new;
% tf-ts --> tf:
cartesianx_a30 = xf - 0.5*amax1_new*tf_new^2;
cartesianx_a31 = amax1_new*tf_new;
cartesianx_a32 = -0.5*amax1_new;

% y - coefficients:
% t0 --> ts:
cartesiany_a10 = yi;
cartesiany_a11 = y_vi;
cartesiany_a12 = 0.5*amax2_new;
% ts --> tf-ts:
cartesiany_a20 = yi + 0.5*amax2_new*ts_new^2 - vmax2_new*ts_new;
cartesiany_a21 = vmax2_new;
% tf-ts --> tf:
cartesiany_a30 = yf - 0.5*amax2_new*tf_new^2;
cartesiany_a31 = amax2_new*tf_new;
cartesiany_a32 = -0.5*amax2_new;

% z - coefficients:
% t0 --> ts:
cartesianz_a10 = zi;
cartesianz_a11 = z_vi;
cartesianz_a12 = 0.5*amax3_new;
% ts --> tf-ts:
cartesianz_a20 = zi + 0.5*amax3_new*ts_new^2 - vmax3_new*ts_new;
cartesianz_a21 = vmax3_new;
% tf-ts --> tf:
cartesianz_a30 = zf - 0.5*amax3_new*tf_new^2;
cartesianz_a31 = amax3_new*tf_new;
cartesianz_a32 = -0.5*amax3_new;


t = 0:delts_t:tf_new;
x_possition = (cartesianx_a10+cartesianx_a11.*t+cartesianx_a12.*t.^2).*(t<=ts_new)...
    +(cartesianx_a20+cartesianx_a21.*t).*(t>ts_new).*(t<=(tf_new-ts_new))...
    +(cartesianx_a30+cartesianx_a31.*t+cartesianx_a32.*t.^2).*(t>(tf_new-ts_new)).*(t<=tf_new);
x_velocity = (cartesianx_a11+2*cartesianx_a12.*t).*(t<=ts_new)...
    +(cartesianx_a21).*(t>ts_new).*(t<=(tf_new-ts_new))...
    +(cartesianx_a31+2*cartesianx_a32.*t).*(t>(tf_new-ts_new)).*(t<=tf_new);
x_acceleration = (2*cartesianx_a12).*(t<=ts_new)...
    +(0).*(t>ts_new).*(t<=(tf_new-ts_new))...
    +(2*cartesianx_a32).*(t>(tf_new-ts_new)).*(t<=tf_new);
y_possition = (cartesiany_a10+cartesiany_a11.*t+cartesiany_a12.*t.^2).*(t<=ts_new)...
    +(cartesiany_a20+cartesiany_a21.*t).*(t>ts_new).*(t<=(tf_new-ts_new))...
    +(cartesiany_a30+cartesiany_a31.*t+cartesiany_a32.*t.^2).*(t>(tf_new-ts_new)).*(t<=tf_new);
y_velocity = (cartesiany_a11+2*cartesiany_a12.*t).*(t<=ts_new)...
    +(cartesiany_a21).*(t>ts_new).*(t<=(tf_new-ts_new))...
    +(cartesiany_a31+2*cartesiany_a32.*t).*(t>(tf_new-ts_new)).*(t<=tf_new);
y_acceleration = (2*cartesiany_a12).*(t<=ts_new)...
    +(0).*(t>ts_new).*(t<=(tf_new-ts_new))....
    +(2*cartesiany_a32).*(t>(tf_new-ts_new)).*(t<=tf_new);
z_possition = (cartesianz_a10+cartesianz_a11.*t+cartesianz_a12.*t.^2).*(t<=ts_new)...
    +(cartesianz_a20+cartesianz_a21.*t).*(t>ts_new).*(t<=(tf_new-ts_new))...
    +(cartesianz_a30+cartesianz_a31.*t+cartesianz_a32.*t.^2).*(t>(tf_new-ts_new)).*(t<=tf_new);
z_velocity = (cartesianz_a11+2*cartesianz_a12.*t).*(t<=ts_new)...
    +(cartesianz_a21).*(t>ts_new).*(t<=(tf_new-ts_new))...
    +(cartesianz_a31+2*cartesianz_a32.*t).*(t>(tf_new-ts_new)).*(t<=tf_new);
z_acceleration = (2*cartesianz_a12).*(t<=ts_new)...
    +(0).*(t>ts_new).*(t<=(tf_new-ts_new))....
    +(2*cartesianz_a32).*(t>(tf_new-ts_new)).*(t<=tf_new);

figure
plot(t,x_possition,'k','linewidth',2)
hold on
plot(t,y_possition,'r','linewidth',2)
hold on
plot(t,z_possition,'g','linewidth',2)
grid on
title('position(m) vs time(s)')
legend('x', 'y','z')
axis([0 tf_new -inf inf])

figure
plot(t,x_velocity,'k','linewidth',2)
hold on
plot(t,y_velocity,'r','linewidth',2)
hold on
plot(t,z_velocity,'g','linewidth',2)
title('velocity(m/s) vs time(s)')
legend('x' , 'y', 'z')
grid on
axis([0 tf_new -inf inf])

figure
plot(t,x_acceleration,'k','linewidth',2)
hold on
plot(t,y_acceleration,'r','linewidth',2)
hold on
plot(t,z_acceleration,'g','linewidth',2)
title('acceleration (m/s^2)vs time(s)')
legend('x','y','z')
grid on
axis([0 tf_new -inf inf])
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plot joints position, velocities and acc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
syms t
x_possition_f1 = (cartesianx_a10+cartesianx_a11.*t+cartesianx_a12.*t^2);
x_possition_f2 =(cartesianx_a20+a21.*t);
x_possition_f3 =(cartesianx_a30+cartesianx_a31.*t+cartesianx_a32.*t.^2);
x_velocity_f1  = (cartesianx_a11+2*cartesianx_a12.*t);
x_velocity_f2 =    (cartesianx_a21);
x_velocity_f3 =   (cartesianx_a31+2*cartesianx_a32.*t);
x_acceleration_f1 = (2*cartesianx_a12);
x_acceleration_f2 =   +(0);
x_acceleration_f3 =  +(2*cartesianx_a32);

y_possition_f1 = (cartesiany_a10+cartesiany_a11.*t+cartesiany_a12.*t^2);
y_possition_f2 =(cartesiany_a20+a21.*t);
y_possition_f3 =(cartesiany_a30+cartesiany_a31.*t+cartesiany_a32.*t.^2);
y_velocity_f1  = (cartesiany_a11+2*cartesiany_a12.*t);
y_velocity_f2 =    (cartesiany_a21);
y_velocity_f3 =   (cartesiany_a31+2*cartesiany_a32.*t);
y_acceleration_f1 = (2*cartesiany_a12);
y_acceleration_f2 =   +(0);
y_acceleration_f3 =  +(2*cartesiany_a32);

z_possition_f1 = (cartesianz_a10+cartesianz_a11.*t+cartesianz_a12.*t^2);
z_possition_f2 =(cartesianz_a20+a21.*t);
z_possition_f3 =(cartesianz_a30+cartesianz_a31.*t+cartesianz_a32.*t.^2);
z_velocity_f1  = (cartesianz_a11+2*cartesianz_a12.*t);
z_velocity_f2 =    (cartesianz_a21);
z_velocity_f3 =   (cartesianz_a31+2*cartesianz_a32.*t);
z_acceleration_f1 = (2*cartesianz_a12);
z_acceleration_f2 =   +(0);
z_acceleration_f3 =  +(2*cartesianz_a32);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% inverse jacobian to convert task space velocities to join space velocities
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%substitute symbols in FK and Jacobian previos calculated
q_symbols = [q1_symb q2_symb q3_symb]; % set symbols of angles 
L_symbols=[d1_symb d2_symb d3_symb]; % set symbols of lenghst 
L_dimensions=[1, 1, 1];  %True Link lengths
FK_L=subs(FK, [L_symbols], [L_dimensions] ); %subs
Jq1_L=subs(Jq1, [L_symbols], [L_dimensions] ); %subs

J = Jq1_L(1:3,:);   %first 3 rows, Jacobian secction for joints velocity 
task_space_velocities_f1= [x_velocity_f1,y_velocity_f1,z_velocity_f1]';
q_velocities_f1 =J\task_space_velocities_f1;

task_space_velocities_f2= [x_velocity_f2,y_velocity_f2,z_velocity_f2]';
q_velocities_f2 =J\task_space_velocities_f2;

task_space_velocities_f3= [x_velocity_f3,y_velocity_f3,z_velocity_f3]';
q_velocities_f3 =J\task_space_velocities_f3;



t = 0:delts_t:tf_new;
x_possition(1)

qvelocity = (cartesianx_a10+cartesianx_a11.*t+cartesianx_a12.*t.^2).*(t<=ts_new)...
    +(cartesianx_a20+cartesianx_a21.*t).*(t>ts_new).*(t<=(tf_new-ts_new))...
    +(cartesianx_a30+cartesianx_a31.*t+cartesianx_a32.*t.^2).*(t>(tf_new-ts_new)).*(t<=tf_new);

q_pos=[];

%q_pos(1)=[0,-1 2]; %inicial position for the joints
only_position=1; 
for i=2:length(x_possition) 
    p1=[x_possition(i),y_possition(i),z_possition(i)]';
    Td=Tx(p1(1))*Ty(p1(2))*Tz(p1(3));
    %q_pos(i)=IK(Td, q_pos(i-1)',q_symbols,only_position,FK_L,Jq1_L); % get vector of joins position using IK
end
% dfdh
%q= 
%dfs;



%% 4b. If we have also to constran the join space and taks space
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% inverse jacobian to convert task space velocities to join space velocities
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%substitute symbols in FK and Jacobian previos calculated
q_symbols = [q1_symb q2_symb q3_symb]; % set symbols of angles 
L_symbols=[d1_symb d2_symb d3_symb]; % set symbols of lenghst 
L_dimensions=[1, 1, 1];  %True Link lengths
FK_L=subs(FK, [L_symbols], [L_dimensions] ) %subs
Jq1_L=subs(Jq1, [L_symbols], [L_dimensions] ) %subs

% Ik p1
%fist we estimate q for all the joints in the position p1
p1=[1,0,1]'
Td=Tx(p1(1))*Ty(p1(2))*Tz(p1(3));%Td=[0,0,0,p1(1);0,0,0,p1(2);0,0,0,p1(3);0,0,0,1]; %position we want to get coordinates
q0 = [0,-1 2]'; %inicial position for the joints
only_position=1; %1=match just position   0=match position and orientation
q_p1 = IK(Td, q0,q_symbols,only_position,FK_L,Jq1_L); % get vector of joins position using IK
T_q_p1 = double(subs(FK_L, [q_symbols], [q_p1'] )); %get the position xyz efector
%p1 and p1_ik have to be the samme 
p1_ik= [T_q_p1(1,4),T_q_p1(2,4),T_q_p1(3,4)]'

% Ik p2
%fist we estimate q for all the joints in the position p2
p2=[sqrt(2)/2,sqrt(2)/2,1.2]'
Td=Tx(p2(1))*Ty(p2(2))*Tz(p2(3)); %position we want to get coordinates in homogenous tranformation
q0 = q_p1; %inicial position for the joints
only_position=1; %1=match just position   0=match position and orientation
q_p2 = IK(Td, q0,q_symbols,only_position,FK_L,Jq1_L) % get vector of joins position using IK
T_q_p2 = double(subs(FK_L, [q_symbols], [q_p2'] )); %get the position xyz efector
%p1 and p1_ik have to be the samme 
p2_ik= [T_q_p2(1,4),T_q_p2(2,4),T_q_p2(3,4)]'


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% inverse jacobian to convert task space velocities to join space velocities
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
J = Jq1_L(1:3,:);   %first 3 rows, Jacobian secction for joints velocity 
J_inv=inv(J);
task_space_max_velocities= [1,1,1]';
q_max_velocities =J_inv* task_space_max_velocities;

%task_space_max_aceleration= [10,10,10]';
%q_max_aceleration =J_inv* task_space_max_aceleration;








% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % trayectory planning to go from p1 to p2
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% q1i = q_p1(1); q1f = q_p2(1); vmax1 = q_max_velocities(1); accmax1 = q_max_aceleration(1);
% q2i = q_p1(2); q2f = q_p2(2); vmax2 = q_max_velocities(2); accmax2 = q_max_aceleration(2);
% q3i = q_p1(3); q3f = q_p2(3); vmax3 = q_max_velocities(3); accmax3 = q_max_aceleration(3);
% 
% v1i = 0; v2i = 0; v3i = 0;       % initial velocity for joints
% acc1i = 0; acc2i = 0; acc3i = 0;   % initial acceleration for joints
% delts_t = 0.01;  %f=100hz
% n = 0;
% while (floor(delts_t*10^n)~=delts_t*10^n)
%     n=n+1;
% end
% E = 1*10^-n;
% 
% % getting maximun time ts and tf of the joints
% %joint 1   ts,tf
% t1s = double(subs(vmax1, [q_symbs], [q_p1'] ))/double(subs(accmax1, [q_symbs], [q_p1'] ))%vmax1/accmax1;
% if rem(t1s,delts_t)~=0
%     t1s_new = round(t1s,n)+E;
% else
%     t1s_new = round(t1s,n)+E;
% end
% t1f = (q1f-q1i)/vmax1 + t1s_new;
% if rem(t1f,delts_t)~=0
%     t1f_new = round(t1f,n)+E;
% else
%     t1f_new = round(t1f,n);
% end
% 
% %joint 2 ts, tf
% t2s = vmax2/accmax2;
% if rem(t2s,delts_t)~=0
%     t2s_new = round(t2s,n)+E;
% else
%     t2s_new = round(t2s,n);
% end
% 
% t2f = (q2f-q2i)/vmax2 + t2s_new;
% if rem(t2f,delts_t)~=0
%     t2f_new = round(t2f,n)+E;
% else
%     t2f_new = round(t2f,n);
% end
% 
% %joint 3   t,tf
% t3s = vmax3/accmax3;
% if rem(t3s,delts_t)~=0
%     t3s_new = round(t3s,n)+E;
% else
%     t3s_new = round(t3s,n);
% end
% 
% t3f = (q3f-q3i)/vmax3 + t3s_new;
% if rem(t3f,delts_t)~=0
%     t3f_new = round(t3f,n)+E;
% else
%     t3f_new = round(t3f,n);
% end
% 
% if (t3f_new > t2f_new) && (t3f_new > t1f_new)
%     tf_new = t3f_new;
%     ts_new = t3s_new;
% elseif (t2f_new > t1f_new)  && (t2f_new > t3f_new)
%     tf_new = t2f_new;
%     ts_new = t2s_new;
% else
%     tf_new = t1f_new;
%     ts_new = t1s_new;
% end
% 
% ts_new
% tf_new
% % recompute accelerations and velocities with the news times ts and tf
% vmax1_new = ((q1f-q1i)/(tf_new-ts_new))
% amax1_new = vmax1_new/ts_new
% vmax2_new = ((q2f-q2i)/(tf_new-ts_new))
% amax2_new = vmax2_new/ts_new
% vmax3_new = ((q3f-q3i)/(tf_new-ts_new))
% amax3_new = vmax3_new/ts_new
% 
% % joint 1 - coefficients:
% % t0 --> ts: 
% joint1_a10 = q1i;
% joint1_a11 = v1i;
% joint1_a12 = 0.5*amax1_new;
% % ts --> tf-ts:
% joint1_a20 = q1i + 0.5*amax1_new*ts_new^2 - vmax1_new*ts_new;
% a21 = vmax1_new;
% % tf-ts --> tf:
% joint1_a30 = q1f - 0.5*amax1_new*tf_new^2;
% joint1_a31 = amax1_new*tf_new;
% joint1_a32 = -0.5*amax1_new;
% 
% % joint 2 - coefficients:
% % t0 --> ts:
% joint2_a10 = q2i;
% joint2_a11 = v2i;
% joint2_a12 = 0.5*amax2_new;
% % ts --> tf-ts:
% joint2_a20 = q2i + 0.5*amax2_new*ts_new^2 - vmax2_new*ts_new;
% joint2_a21 = vmax2_new;
% % tf-ts --> tf:
% joint2_a30 = q2f - 0.5*amax2_new*tf_new^2;
% joint2_a31 = amax2_new*tf_new;
% joint2_a32 = -0.5*amax2_new;
% 
% % joint 3 - coefficients:
% % t0 --> ts:
% joint3_a10 = q3i;
% joint3_a11 = v3i;
% joint3_a12 = 0.5*amax3_new;
% % ts --> tf-ts:
% joint3_a20 = q3i + 0.5*amax3_new*ts_new^2 - vmax3_new*ts_new;
% joint3_a21 = vmax3_new;
% % tf-ts --> tf:
% joint3_a30 = q3f - 0.5*amax3_new*tf_new^2;
% joint3_a31 = amax3_new*tf_new;
% joint3_a32 = -0.5*amax3_new;
% 
% 
% t = 0:delts_t:tf_new;
% q1 = (joint1_a10+joint1_a11.*t+joint1_a12.*t.^2).*(t<=ts_new)...
%     +(joint1_a20+a21.*t).*(t>ts_new).*(t<=(tf_new-ts_new))...
%     +(joint1_a30+joint1_a31.*t+joint1_a32.*t.^2).*(t>(tf_new-ts_new)).*(t<=tf_new);
% v1 = (joint1_a11+2*joint1_a12.*t).*(t<=ts_new)...
%     +(a21).*(t>ts_new).*(t<=(tf_new-ts_new))...
%     +(joint1_a31+2*joint1_a32.*t).*(t>(tf_new-ts_new)).*(t<=tf_new);
% acc1 = (2*joint1_a12).*(t<=ts_new)...
%     +(0).*(t>ts_new).*(t<=(tf_new-ts_new))...
%     +(2*joint1_a32).*(t>(tf_new-ts_new)).*(t<=tf_new);
% q2 = (joint2_a10+joint2_a11.*t+joint2_a12.*t.^2).*(t<=ts_new)...
%     +(joint2_a20+joint2_a21.*t).*(t>ts_new).*(t<=(tf_new-ts_new))...
%     +(joint2_a30+joint2_a31.*t+joint2_a32.*t.^2).*(t>(tf_new-ts_new)).*(t<=tf_new);
% v2 = (joint2_a11+2*joint2_a12.*t).*(t<=ts_new)...
%     +(joint2_a21).*(t>ts_new).*(t<=(tf_new-ts_new))...
%     +(joint2_a31+2*joint2_a32.*t).*(t>(tf_new-ts_new)).*(t<=tf_new);
% acc2 = (2*joint2_a12).*(t<=ts_new)...
%     +(0).*(t>ts_new).*(t<=(tf_new-ts_new))....
%     +(2*joint2_a32).*(t>(tf_new-ts_new)).*(t<=tf_new);
% q3 = (joint3_a10+joint3_a11.*t+joint3_a12.*t.^2).*(t<=ts_new)...
%     +(joint3_a20+joint3_a21.*t).*(t>ts_new).*(t<=(tf_new-ts_new))...
%     +(joint3_a30+joint3_a31.*t+joint3_a32.*t.^2).*(t>(tf_new-ts_new)).*(t<=tf_new);
% v3 = (joint3_a11+2*joint3_a12.*t).*(t<=ts_new)...
%     +(joint3_a21).*(t>ts_new).*(t<=(tf_new-ts_new))...
%     +(joint3_a31+2*joint3_a32.*t).*(t>(tf_new-ts_new)).*(t<=tf_new);
% acc3 = (2*joint3_a12).*(t<=ts_new)...
%     +(0).*(t>ts_new).*(t<=(tf_new-ts_new))....
%     +(2*joint3_a32).*(t>(tf_new-ts_new)).*(t<=tf_new);
% 
% figure
% plot(t,q1,'k','linewidth',2)
% hold on
% plot(t,q2,'r','linewidth',2)
% hold on
% plot(t,q3,'g','linewidth',2)
% grid on
% title('position(rad) vs time(s)')
% legend('joint_1', 'joint_2','joint_3')
% axis([0 tf_new -inf inf])
% 
% figure
% plot(t,v1,'k','linewidth',2)
% hold on
% plot(t,v2,'r','linewidth',2)
% hold on
% plot(t,v3,'g','linewidth',2)
% title('velocity(rad/s) vs time(s)')
% legend('joint_1' , 'joint_2', 'joint_3')
% grid on
% axis([0 tf_new -inf inf])
% 
% figure
% plot(t,acc1,'k','linewidth',2)
% hold on
% plot(t,acc2,'r','linewidth',2)
% hold on
% plot(t,acc3,'g','linewidth',2)
% title('acceleration (rad/s^2)vs time(s)')
% legend('joint_1','joint_2','joint_3')
% grid on
% axis([0 tf_new -inf inf])

