% Questo Pendolo è monodimensionale

clc;
clear;
close all;

ms = 0.033;%massa asta [Kg]
mr = 0.5;%massa rotore [Kg]
L =  0.5;%braccio pendolo [m]
Raggio_Ruota =  0.15; %raggio della ruota inerziale [m]
I_Ruota = mr*Raggio_Ruota*Raggio_Ruota;
g = 9.81; %gravità m/s^2
%Phi è immesso nella dinamica in modo da calcolare la posizione senza
%linearizzazione.
phi = 0;%è l'angolo di inclinazione relativo all'asse Y [deg]. ATTENZIONE
Cd = 0; %Coefficiente di viscosità.

% [B_EnergiaCinetica,C] = Eq_Dinamica(ms,mr,L,Raggio_Ruota);
% [B_EnergiaCinetica,C,G] = Eq_Dinamica_corretta(ms,mr,L,Raggio_Ruota);

[B_EnergiaCinetica,C,G] = Dinamica(ms,mr,L,Raggio_Ruota);

%[A_l,B_l,C_l,D_l] = SSDinamica_Corretta(B_EnergiaCinetica,C,G,Raggio_Ruota,mr);

% [A_l,B_l,C_l,D_l] = SSDinamica_RANGO2(B_EnergiaCinetica,C,G,Raggio_Ruota,mr);
[A_l,B_l,C_l,D_l] = SSDinamica_3(B_EnergiaCinetica,C,G,Raggio_Ruota,mr)

Time_Campionamento = 0.001;

T_fine = 500;

% G = ss(A_l,B_l,C_l,D_l,Time_Campionamento);
G = ss(A_l,B_l,C_l,D_l);

%G.StateName = {'phi','dot_phi','theta','dot_theta','ddot_theta'};
% G.StateName = {'phi','dot_phi'};
G.StateName = {'phi','dot_phi','dot_theta'};
G.InputName = {'dot_theta'};

Co = ctrb(G.A,G.B);
rankCO = rank(Co);
OB = obsv(G.A,G.C);
rankOB = rank(OB);

[Wn,zeta,P] = damp(G); %returns the poles of sys.

freq = Wn./(2*pi); %in Hz

NOISE_rms = 0.02*pi/180; %rad

%% Controllo

Kp = 1000;
Kd = 0;

%con questi due parametri il sistema funziona.
%I risultati sono una coppia massima 

%% Parametri Motori

Coppia_stalloKgm = 36*0.01/2;  %kg*m
%Il kilogrametro è un unità di misura tecnica dell'energia.
%un kgm è pari ad un kg forza per un metro.
%Il chilogrammetro equivale quindi al lavoro necessario per sollevare
%di un metro un corpo di massa di un chilogrammo.
%devo moltiplicare quindi per 9.81 per ottenere Nm
Coppia_stalloNm = Coppia_stalloKgm*9.81;
V_max = 12; %V
I_stallo = 6.5; %A DI STALLO
I_max_NOLOAD = 0.25; %A
w_max = 122*2*pi/60/2; %rad/s

R_max = V_max/I_max_NOLOAD;
K = V_max/w_max;

b = 0.1; %N*m*s
L = 2*0.001; %mH


%% MOTORE

A_m = [-R_max/L, -K/L, 0;
       -K/I_Ruota, 0.1/I_Ruota, 0;
       0, 1, 0];
 
B_m = [1/L;0;0];

C_m = [ 0 1 0;
        0 0 1;];
  
D_m = 0;

Motore_SS = ss(A_m,B_m,C_m,D_m,'TimeUnit','seconds','Ts',Time_Campionamento);

