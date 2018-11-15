function [A_l,B_l,C_l,D_l] = SSDinamica(B,C,G)

%scrittura nello spazio degli stati linearizzato in psi = 0
%B*dotdotq + G = [0;T]

x1 = 0;

A_l = [ 0        , 1, 0, 0, 0, 0;
        G*cos(x1), 0, 0, 0, 0, -B(1,2)/B(1,1);
        0        , 0, 0, 0, 0, 0;
        0        , 0, 0, 0, 1, 0;
        0        , 0, -B(2,1)/B(2,2), 0, 0, 0;
        0        , 0, 0, 0, 0, 0];
        
B_l = [0;0;0;0;-1/B(2,2);0];

C_l = [1,0,0,0,0,0;
       0,1,0,0,0,0;
       0,0,0,1,0,0;
       0,0,0,0,1,0];
   
D_l = 0;
        
end