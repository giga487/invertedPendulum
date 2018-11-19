function [A_l,B_l,C_l,D_l] = SSDinamica_Corretta(B,C,G,R,mr)

Mpsi = B(1,1);
Mtheta = B(2,2);
B12 = B(1,2);
B21 = B(2,1);

G1 = G(1);

A_l = [0,1;
      -G1/Mpsi,0];
       

B_l = [0;
       -mr*R*R/Mpsi;];
   
C_l = [1,0;
       0,1];
   
D_l = 0;

end