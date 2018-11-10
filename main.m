% Questo Pendolo è monodimensionale

ms = 1;%massa asta [Kg]
mr = 1;%massa rotore [Kg]
L =  1;%braccio pendolo [m]
R =  1;%raggio della ruota inerziale [m]
%Phi è immesso nella dinamica in modo da calcolare la posizione senza
%linearizzazione.
phi = 0;%è l'angolo di inclinazione relativo all'asse Y [deg]. ATTENZIONE

[B,C,G] = Eq_Dinamica(ms,mr,L,R,phi);