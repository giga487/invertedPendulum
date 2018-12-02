
syms wx wy wz real
w = [wx; wy; wz];

Ixx = 1514303.58;
Ixy = -107.07;
Ixz = 0.19;
Iyx = -107.07;
Iyy = 764137.53;
Iyz = 0.00;
Izx = 0.19;
Izy = 0.00;
Izz = 764069.07;

I = [Ixx,Iyx,Izx;
     Ixy,Iyy,Izy;
     Ixz,Iyz,Izz;];
 
wy = 0;
wz = 0;
w = [wx; wy; wz];
T = simplify((w')*I*w)
 

 