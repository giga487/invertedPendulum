clc
clear
close all;

%Evidenzio la dinamica del pendolo inverso
L = 0.25; %lunghezza del pendolo.
% diametro_ruota = 0.15;
% m_ruota = 0.457;

diametro_ruota = 0.11; %m
% m_ruota = 0.182676
m_ruota = 0.666003
m_mot = 0.333;
m_asta = 0.05;
% I_ruota = 0.000327; %SOLIDOWORKS
I_ruota = 0.001445;
%La massa rotante risulta troppo leggera o troppo piccola dimensionalmente
%per il motore. Ci sono pochi frangenti in cui il sistema funziona, sarebbe
%opportuno avere una massa rotante con un'inerzia maggiore

I_ruota_stima = m_ruota*(diametro_ruota/2)^2;
I_mot = L^2*m_mot;
I_asta = m_asta*(L^2)/12;

g = 9.81; %m/s^2

B11 = m_asta*(L/2)^2+m_ruota*L^2+m_mot*L^2 + I_asta+I_ruota+I_mot;
B12 = I_ruota;
B21 = I_ruota;
B22 = I_ruota;
Delta = B11*B22-B12*B21;

m_TOT = m_mot+m_asta/2+m_ruota;
G1 = m_TOT*g*L;
Time_Campionamento = 0.001; %s

A21 = B22*G1/Delta;
A31 = -G1*B21/Delta;

A = [0,1,0;
     A21,0,0;
     A31,0,0;];
 
B = [0;-B21/Delta;B11/Delta];

C = [1,0,0; %psi
     0,1,0; %dot_psi
     0,0,1];%dot_theta
D = 0;
 
G = ss(A,B,C,D);
 
G.StateName = {'phi','dot_phi','dot_theta'};
G.InputName = {'T'};

Co = ctrb(G.A,G.B);
rankCO = rank(Co);
OB = obsv(G.A,G.C);
rankOB = rank(OB);

[Wn,zeta,P] = damp(G); %returns the poles of sys.

freq = Wn./(2*pi); %in Hz

NOISE_rms = 0.02*pi/180; %rad


%% Parametri Motori

Coppia_stallo_Kgm_MAX = 36*0.01;  %da36kg.cm a kg.m
Coppia_stalloKgm = Coppia_stallo_Kgm_MAX;  %kg*m
%Il kilogrametro è un unità di misura tecnica dell'energia.
%un kgm è pari ad un kg forza per un metro.
%Il chilogrammetro equivale quindi al lavoro necessario per sollevare
%di un metro un corpo di massa di un chilogrammo.
%devo moltiplicare quindi per 9.81 per ottenere Nm
Coppia_stalloNm_TOT = Coppia_stalloKgm*9.81;
Coppia_stalloNm = Coppia_stalloNm_TOT*3/4;
V_max = 12; %V
I_stallo = 6.5; %A DI STALLO
I_max_NOLOAD = 0.25; %A
w_max = 122*pi/30; %da rpm a rad/s

R_max = V_max/I_stallo;

Linduttanza = 0.0002; %mH

b = 0.01; %attrito viscoso
r_peggiore = 10;
K = (V_max-I_max_NOLOAD*r_peggiore)/w_max
R = r_peggiore; %CASO PEGGIORE di stallo del motore



%% Analisi Motore, Generazione Curve

punti_noti = [0,Coppia_stalloNm_TOT; w_max,0]
punti_MaxPower = [w_max/2,Coppia_stalloNm_TOT/2];
figure;
plot(punti_noti(:,1),punti_noti(:,2)); grid on;
title('Retta di Carico'); ylabel('Torque [Nm]');xlabel('Speed [rad / s]');hold on;
plot(punti_MaxPower(1,1),punti_MaxPower(1,2),'bo');

%% Funzione_Trasferimento Motore DC acceleration 

