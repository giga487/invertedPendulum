% Questo Pendolo è monodimensionale

clc;
clear;
close all;

ms = 1;%massa asta [Kg]
mr = 1;%massa rotore [Kg]
L =  0.5;%braccio pendolo [m]
R =  0.15;%raggio della ruota inerziale [m]
g = 9.81; %gravità m/s^2
%Phi è immesso nella dinamica in modo da calcolare la posizione senza
%linearizzazione.
phi = 0;%è l'angolo di inclinazione relativo all'asse Y [deg]. ATTENZIONE
Cd = 0; %Coefficiente di viscosità.

[B,C] = Eq_Dinamica(ms,mr,L,R);
G1 = (-ms*g*L/2-mr*g*L);

[A_l,B_l,C_l,D_l] = SSDinamica(B,C,G1);

G = ss(A_l,B_l,C_l,D_l);
G.StateName = {'phi','dot_phi'};
G.InputName = {'Coppia'};


