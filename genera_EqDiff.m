function dxdt = genera_EqDiff(t,x)

    ms = 0.10;%massa asta [Kg]
    mr = 1;%massa rotore [Kg]
    L =  0.50;%braccio pendolo [m]
    R =  0.1;%raggio della ruota inerziale [m]
    g = 9.81; %gravità m/s^2
    %Phi è immesso nella dinamica in modo da calcolare la posizione senza
    %linearizzazione.
    %phi = 0;%è l'angolo di inclinazione relativo all'asse Y [deg]. ATTENZIONE
    [B,C] = Eq_Dinamica(ms,mr,L,R);
    
    g = (ms*g*L/2+mr*g*L);
    A = -B(1,2)/B(1,1);
    C = -B(2,1)/B(2,2);
    T = 0;
    
    dxdt = zeros(4,1);
    
    dxdt(1,1) = x(2);
    dxdt(2,1) = A*x(5) -g*sin(x(1));
    dxdt(3,1) = x(4);
    dxdt(4,1) = C*x(3) - T;
    dxdt(5,1) = 1;
    
    
end
