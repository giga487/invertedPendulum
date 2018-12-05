function [A_l,B_l,C_l,D_l] = SSDinamica_3(B,G)

IT = B(1,1);
IG = B(2,2);
IG = B(1,2);
IG = B(2,1);
G1 = G(1);

%Scrivo il sistema in questo modo:
%M_psi*ddot(psi) + mr*R^2*ddot(theta) = G1*sin(psi)
%mr*R^2*ddot(psi) + Mtheta*ddot(theta) = Tau
%trovo la soluzione del sistema con Cramer
%Delta = Mpsi*Mtheta-(mr*R^2)^2 
%ddot(psi) = 1/Delta*(G1sin(psi)*Mtheta-Tau*mr*R^2);
%ddot(theta) = 1/Delta*(-G1sin(psi)*mr*R^2+Mpsi*Tau);
%

Delta = IT*IG-IG*IG;
%linearizzo.

A_l = [0,1,0;
      G1*IG/Delta,0,0;
      -G1*IG/Delta,0,0];
       

B_l = [0;
      -IG/Delta;
      IT/Delta];
   
C_l = [1,0,0;
       0,1,0;
       0,0,1];
   
D_l = 0;

end