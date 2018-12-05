function [B,G1] = calcolo_elementi_dinamica()

rho_alluminio = 2.7*0.001; %g/mm^3

mr = 457.51*10^-3;% kg
Volume = 169449.89*10^-9; %m^3

g = 9.81; %m/s^2

%Matrice delle inerzie grams *  square millimeters

Ixx = 1514303.58;
Ixy = -107.07;
Ixz = 0.19;
Iyx = -107.07;
Iyy = 764137.53;
Iyz = 0.00;
Izx = 0.19;
Izy = 0.00;
Izz = 764069.07;

%RUOTA
I = 10^-8*[Ixx,Iyx,Izx;
     Ixy,Iyy,Izy;
     Ixz,Iyz,Izz;];
 
IG = I(1,1);
%ASTA
%Densità legno 600 Kg/m^3
ms = 0.053; %kg
L = 0.25; %m 
IB = 667677*10^-8;

IT = ms*L^2/4+mr*L^2+IB+IG;

B = [IT,IG; IG,IG];

%% Calcolo G

G1 = [ms*g*L/2+mr*g*L;
      0];


end