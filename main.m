% Questo Pendolo è monodimensionale

clc;
clear;
close all;

ms = 1;%massa asta [Kg]
mr = 0;%massa rotore [Kg]
L =  0.5;%braccio pendolo [m]
R =  0;%raggio della ruota inerziale [m]
g = 9.81; %gravità m/s^2
%Phi è immesso nella dinamica in modo da calcolare la posizione senza
%linearizzazione.
phi = 0;%è l'angolo di inclinazione relativo all'asse Y [deg]. ATTENZIONE
Cd = 0; %Coefficiente di viscosità.

[B,C] = Eq_Dinamica(ms,mr,L,R);

T = 0;

G1 = (-ms*g*L/2-mr*g*L)*sin(phi);
G2 = T;

[t,x] = ode45(@ode_pendulum_NOWHEEL,[0 30],[0.001; 0;0]);
[t1,x1] = ode45(@ode_pendulum_WHEEL,[0 30],[0.001; 0;0]);

% plot(x.x, x.y(1,:),'k',x1.x,x1.y(1,:),'b'); axis([0 10 -2 5]);
figure;
plot(t,x(:,1),'k');hold on;
plot(t,x(:,2),'b');
plot(t,x(:,3),'r');
hold off;
figure;
plot(t1,x1(:,1),'k');hold on;
plot(t1,x1(:,2),'b');
plot(t1,x1(:,3),'g');
%plot(t1,x1(:,4),'r');
hold off;
