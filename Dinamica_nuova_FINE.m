clc
clear
close all;

%Evidenzio la dinamica del pendolo inverso
L = 0.25; %lunghezza del pendolo.
% diametro_ruota = 0.15;
% m_ruota = 0.457;
diametro_ruota = 0.09; %m
m_ruota = 0.141061;
m_mot = 0.333;
m_asta = 0.05;
I_ruota = 0.0494; %SOLIDOWORKS
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

Kp = -0.01;
Kd = 0;
%con questi due parametri il sistema funziona.
%I risultati sono una coppia massima 

%% Parametri Motori

Coppia_stallo_Kgm_MAX = 36*0.01;  %kg*m
Coppia_stalloKgm = Coppia_stallo_Kgm_MAX;  %kg*m
%Il kilogrametro è un unità di misura tecnica dell'energia.
%un kgm è pari ad un kg forza per un metro.
%Il chilogrammetro equivale quindi al lavoro necessario per sollevare
%di un metro un corpo di massa di un chilogrammo.
%devo moltiplicare quindi per 9.81 per ottenere Nm
Coppia_stalloNm_TOT = Coppia_stalloKgm*9.81;
Coppia_stalloNm = Coppia_stalloNm_TOT/2;
V_max = 12; %V
I_stallo = 6.5; %A DI STALLO
I_max_NOLOAD = 0.25; %A
w_max = 122*2*pi/60/2; %rad/s

R_max = V_max/I_max_NOLOAD;

L = 2*0.001; %mH

s = tf('s');
b = 0.1; %attrito viscoso
r_peggiore = 3;
K = (V_max-I_max_NOLOAD*r_peggiore)/w_max
R = r_peggiore; %CASO PEGGIORE di stallo del motore

g = K/((I_ruota*s+b)*R+K^2)
g2 = 0.5/(s+3);
Motore_num = K;
Motore_den = [I_ruota*R, b*R+K^2];

num_dc = K;
den_dc = [(I_ruota*L) ((I_ruota*R)+(L*b)) ((b*R)+K^2)];
dcmotor = tf(num_dc,den_dc)


damp(g)
figure(1);
subplot(1,2,1);
bode(dcmotor);grid on;
subplot(1,2,2);
bode(g2);grid on;
