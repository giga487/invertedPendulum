% Questo Pendolo è monodimensionale

clc;
clear;
close all;

ms = 0.5;%massa asta [Kg]
mr = 2;%massa rotore [Kg]
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

G = ss(A_l,B_l,C_l,D_l,'TimeUnit','seconds','Ts',0.01);

G.StateName = {'phi','dot_phi'};
G.InputName = {'Coppia'};


%% Parametri Motori

Coppia_stallo = 36*100;  %kg/m
V_max = 12; %V
I_stallo = 6.5; %A DI STALLO
I_max_NOLOAD = 0.25; %A
w_max = 122*2*pi/60; %rad/s

R_max = V_max/I_max_NOLOAD;
K = V_max/w_max;


%% Fine