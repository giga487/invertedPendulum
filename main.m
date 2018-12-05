% Questo Pendolo è monodimensionale

clc;
clear;
close all;

%Phi è immesso nella dinamica in modo da calcolare la posizione senza
%linearizzazione.

[B_EnergiaCinetica,G] = calcolo_elementi_dinamica();

[A_l,B_l,C_l,D_l] = SSDinamica_3(B_EnergiaCinetica,G);

Time_Campionamento = 0.001;

T_fine = 500;

% G = ss(A_l,B_l,C_l,D_l,Time_Campionamento);
G = ss(A_l,B_l,C_l,D_l,Time_Campionamento);

G.StateName = {'phi','dot_phi','dot_theta'};
G.InputName = {'dot_theta'};

Co = ctrb(G.A,G.B);
rankCO = rank(Co);
OB = obsv(G.A,G.C);
rankOB = rank(OB);

[Wn,zeta,P] = damp(G); %returns the poles of sys.

freq = Wn./(2*pi); %in Hz

NOISE_rms = 0.02*pi/180; %rad


%% Calcolo del sistema in forma di quasi velocita

Kp = -50;
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

