clc
clear
close all;

%Evidenzio la dinamica del pendolo inverso

mt = 0.83; %kg
g = 9.81; %m/s^2
L = 0.25; %lunghezza del pendolo.
Irot = 0.0015; %da solidworks
Itot = 0.13; %da solidworks

A21 = mt*g*L/Itot
A31 = -mt*g*L/Itot

Time_Campionamento = 0.001; %s

A = [0,1,0;
     A21,0,0;
     A31,0,0;];
B = [0;-1/Itot;(Itot+Irot)/(Irot*Itot)];

C = [1,0,0; %psi
     0,1,0, %dot_psi
     0,0,1];%dot_theta
 D = 0;
 
 G = ss(A,B,C,D)
 
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
Kd = -10;

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

 