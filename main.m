% Questo Pendolo � monodimensionale

clc;
clear;
close all;

ms = 0.033;%massa asta [Kg]
mr = 0.58;%massa rotore [Kg]
L =  0.20;%braccio pendolo [m]
Raggio_Ruota =  0.30;%raggio della ruota inerziale [m]
I_Ruota = mr*Raggio_Ruota*Raggio_Ruota;
g = 9.81; %gravit� m/s^2
%Phi � immesso nella dinamica in modo da calcolare la posizione senza
%linearizzazione.
phi = 0;%� l'angolo di inclinazione relativo all'asse Y [deg]. ATTENZIONE
Cd = 0; %Coefficiente di viscosit�.

% [B_EnergiaCinetica,C] = Eq_Dinamica(ms,mr,L,Raggio_Ruota);
% [B_EnergiaCinetica,C,G] = Eq_Dinamica_corretta(ms,mr,L,Raggio_Ruota);

[B_EnergiaCinetica,C,G] = Dinamica(ms,mr,L,Raggio_Ruota);

%[A_l,B_l,C_l,D_l] = SSDinamica_Corretta(B_EnergiaCinetica,C,G,Raggio_Ruota,mr);

% [A_l,B_l,C_l,D_l] = SSDinamica_RANGO2(B_EnergiaCinetica,C,G,Raggio_Ruota,mr);
[A_l,B_l,C_l,D_l] = SSDinamica_3(B_EnergiaCinetica,C,G,Raggio_Ruota,mr)


Time_Campionamento = 0.001;
T_fine = 10;
G = ss(A_l,B_l,C_l,D_l,Time_Campionamento);

%G.StateName = {'phi','dot_phi','theta','dot_theta','ddot_theta'};
% G.StateName = {'phi','dot_phi'};
G.StateName = {'phi','dot_phi','dot_theta'};
G.InputName = {'dot_theta'};

Co = ctrb(G.A,G.B);
rankCO = rank(Co);
OB = obsv(G.A,G.C);
rankOB = rank(OB);

eig(G.A)

NOISE_rms = 0.02*pi/180; %rad


%% Parametri Motori

Coppia_stallo = 36*0.01/2;  %kg*m
V_max = 12; %V
I_stallo = 6.5; %A DI STALLO
I_max_NOLOAD = 0.25; %A
w_max = 122*2*pi/60/2; %rad/s

R_max = V_max/I_max_NOLOAD;
K = V_max/w_max;

b = 0.1; %N*m*s
L = 2*0.001; %mH
T_fine = 15;

%% MOTORE

A_m = [-R_max/L, -K/L, 0;
       -K/I_Ruota, 0.1/I_Ruota, 0;
       0, 1, 0];
 
B_m = [1/L;0;0];

C_m = [ 0 1 0;
        0 0 1;];
  
D_m = 0;

Motore_SS = ss(A_m,B_m,C_m,D_m,'TimeUnit','seconds','Ts',Time_Campionamento);

%% 
model = 'inv_Pendulum_L';
load_system(model)
sim(model)

%% PLOT RESULTs

L = 1;
dt = 0;

min_Torque = min(Torque);
max_Torque = max(Torque);
min_w = min(w_rad_at_s);
max_w = max(w_rad_at_s);

figure;
subplot(2,1,1);
Motor_Speed_animL = animatedline;
axis([0 100 min_w*1.5 max_w*1.5]);
xlabel('time [s]');ylabel('Speed rad/s');

subplot(2,1,2);
Torque_animL = animatedline;
axis([0 100 min_Torque*1.5 max_Torque*1.5]);
xlabel('time [s]');ylabel('Torque Kg/m');

% figure;
for i = 1:1:size(angle_degree)
    dt = dt + Time_Campionamento;

    addpoints(Motor_Speed_animL,dt,w_rad_at_s(i));
    addpoints(Torque_animL,dt,Torque(i));
    drawnow limitrate;
    
%     drawnow limitrate;
%     clf;
%     angle = angle_degree(i);
%     xf = L*sind(angle);
%     yf = L*cosd(angle);
%     x = [0,xf];
%     y = [0,yf];
%     line(x,y); hold on; grid on;
%     viscircles([xf yf],0.05,'color','black');
%     axis([-1 1 -0.2 1.2]);
%     hold off;
    pause(Time_Campionamento);
%     
end
