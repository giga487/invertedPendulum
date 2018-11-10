
function [B,C] = Eq_Dinamica(ms,mr,L,R)
% Equazioni della dinamica
% Scrivo le equazioni del moto nella forma B*ddot(q)+C*dot(q)+G = T
% dove B forze di inerzia corrispondenti ad accelerazioni tangenziali
% C forze d'inerzia corrispondenti ad accelerazioni centrifughe e di Coriolis
% G forze gravitazionali e/o elastiche in dipendenza della forma di U
% T forze generazlizzate attive non conservative degli attuatori sui giunti

% K = 1/2*ms*vB^2 + 1/2*mr*vG^2 + 1/2*Is*dot(psi)+1/2*Id*(dot(psi)-dot(tetha))^2;
% Visto che si ipotizza la ruota più cava possibile con le masse
% disposte maggiormente lungo il bordo Is diviene:
% Is = mr*R^2; 
% Id = 1/12*ms*L^2;
% la velocità vB = L/2*\dot(psi)*[-sin(psi); cos(psi); 0];
% mentre la vG = 2*vB;
% vB^T*vB = L^2/4*\dot(psi)^2 e vG = L^2*\dot(psi)^2
% allora K diventa:
% K = % 1/2*ms*L^2/4*\dot(psi)^2+1/2*mr*L^2*\dot(psi)^2+ 1/2*1/24*L^2*\dot(psi)^2+ 1/2*mr*R^2*(\dot(psi)^2+\dot(theta)^2-2(\dot(psi)*\dot(theta));
% allora B, ottenuta dalla derivazione rispetto ad una variabile \dot(psi)
% e \dot(theta) diviene:

g = 9.81; %gravità generica, non localizzata, servirebbe farlo [m/s^2]

B11 = 0.25*ms*L*L+mr*L*L+0.0833*ms*L*L+mr*R*R;
B12 = -mr*R*R;
B21 = -mr*R*R;
B22 =  mr*R*R;

% G1 = -ms*g*L/2*sind(phi)-mr*g*L*sind(phi);
% G2 = 0;

B = [B11 B12;
     B21 B22];
 
C = [0;0];
end
