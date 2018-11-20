function [B,C,G] = Dinamica(ms,mr,L,R)

g = 9.81;

B11 = ms*L*L/4+mr*L*L+1/12*ms*L*L+mr*R*R;
B12 = mr*R*R; 
B21 = mr*R*R;
B22 = mr*R*R;

B = [B11,B12;
     B21,B22;];

C = [0;
     0];
G = [ms*g*L/2+mr*g*L;
      0];
end