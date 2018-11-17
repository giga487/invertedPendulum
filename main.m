% Questo Pendolo è monodimensionale

clc;
clear;
close all;

ms = 0.5;%massa asta [Kg]
mr = 2;%massa rotore [Kg]
L =  0.5;%braccio pendolo [m]
Raggio_Ruota =  0.15;%raggio della ruota inerziale [m]
I_Ruota = mr*Raggio_Ruota*Raggio_Ruota;
g = 9.81; %gravità m/s^2
%Phi è immesso nella dinamica in modo da calcolare la posizione senza
%linearizzazione.
phi = 0;%è l'angolo di inclinazione relativo all'asse Y [deg]. ATTENZIONE
Cd = 0; %Coefficiente di viscosità.

[B_EnergiaCinetica,C] = Eq_Dinamica(ms,mr,L,Raggio_Ruota);
G1 = (-ms*g*L/2-mr*g*L);

[A_l,B_l,C_l,D_l] = SSDinamica(B_EnergiaCinetica,C,G1);

Time_Campionamento = 0.0001;
G = ss(A_l,B_l,C_l,D_l,'TimeUnit','seconds','Ts',Time_Campionamento);

G.StateName = {'phi','dot_phi'};
G.InputName = {'Coppia'};


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


%% LAUNCH SIMULINK PROJECT
s = tf('s');
G_w = K/(I_Ruota*s+b)*(R_max)+K^2;

%% SIMULINK LAUNCH
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

% figure;
% subplot(2,1,1);
% Motor_Speed_animL = animatedline;
% axis([0 100 min_w*1.5 max_w*1.5]);
% xlabel('time [s]');ylabel('Speed rad/s');
% 
% subplot(2,1,2);
% Torque_animL = animatedline;
% axis([0 100 min_Torque*1.5 max_Torque*1.5]);
% xlabel('time [s]');ylabel('Torque Kg/m');

figure;
for i = 1:1:size(angle_degree)
    dt = dt + Time_Campionamento;
    %drawnow limitrate;
    addpoints(Motor_Speed_animL,dt,w_rad_at_s(i));
    addpoints(Torque_animL,dt,Torque(i));
    
    clf;
    angle = angle_degree(i);
    xf = L*sind(angle);
    yf = L*cosd(angle);
    x = [0,xf];
    y = [0,yf];
    line(x,y); hold on; grid on;
    viscircles([xf yf],0.05,'color','black')
    axis([-1 1 -0.2 1.2]);
    hold off;
    pause(0.01);
    
end
