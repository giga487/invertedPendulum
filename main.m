% Questo Pendolo è monodimensionale
% Scrivo le equazioni del moto nella forma B*ddot(q)+C*dot(q)+G = T
% dove B forze di inerzia corrispondenti ad accelerazioni tangenziali
% C forze d'inerzia corrispondenti ad accelerazioni centrifughe e di Coriolis
% G forze gravitazionali e/o elastiche in dipendenza della forma di U
% T forze generazlizzate attive non conservative degli attuatori sui giunti
B11 = ms*L^2/4+ms*L^2/12+mr*L^2+1/2*mr*R^2;
B12 = -1/2*mr*R^2;
B21 = -1/2*mr*R^2;
B22 = +1/2*mr*R^2;
G1 = -ms*g*L/2*sind(phi)-mr*g*L*sind(phi);
G2 = 0;

B = [B11 B12;
     B21 B22];
 
C = [0;0];

G = [ G1;
      G2 ]; 