
function [dxdt] = ode_pendulum_WHEEL(t,x)

    ms = 0.5;%massa asta [Kg]
    mr = 0;%massa rotore [Kg]
    L =  1;%braccio pendolo [m]
    R =  0;%raggio della ruota inerziale [m]
    b = 0.05;
    g = 9.81; %gravità generica, non localizzata, servirebbe farlo [m/s^2]
    
    T = 0;
    Cd = -b/((ms+mr)*L^2);
    
    B11 = 0.25*ms*L*L+mr*L*L+0.0833*ms*L*L+mr*R*R;
    
    G = (-ms*g*L/2-mr*g*L);
    
    dxdt = zeros(3,1);

    dxdt(1) = x(2); %v
    x(3) = (Cd*x(2)+G*sin(x(1)))/B11; %a
    dxdt(2) = x(3);
    
end