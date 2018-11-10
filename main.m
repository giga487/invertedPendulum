% Questo Pendolo è monodimensionale

clc;
clear;
close all;

ms = 1;%massa asta [Kg]
mr = 1;%massa rotore [Kg]
L =  1;%braccio pendolo [m]
R =  1;%raggio della ruota inerziale [m]
g = 9.81; %gravità m/s^2
%Phi è immesso nella dinamica in modo da calcolare la posizione senza
%linearizzazione.
phi = 0;%è l'angolo di inclinazione relativo all'asse Y [deg]. ATTENZIONE

[B,C] = Eq_Dinamica(ms,mr,L,R);

T = 0;

G1 = -ms*g*L/2*sind(phi)-mr*g*L*sind(phi);
G2 = T;

x = ode45(@genera_EqDiff,[0 30],[0.05; 0; 0; 0;0]);

% [t,y] = ode45(@eq_vander,[0 20],[2; 0]);
% [t,y2] = ode45(@odefun,[0 20],[-1; 0]);
% 
% plot(t,y2(:,1));axis([0 10 0 10]);
figure;
plot(x.x,x.y(1,:)); title('Angolo phi');grid on; axis equal;


