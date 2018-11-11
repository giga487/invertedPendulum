
function [dxdt] = ode_pendulum_NOWHEEL(t,x)

    ms = 1;%massa asta [Kg]
    mr = 0;%massa rotore [Kg]
    L =  0.5;%braccio pendolo [m]
    R =  0;%raggio della ruota inerziale [m]
    b = 0.01;
    g = 9.81; %gravità generica, non localizzata, servirebbe farlo [m/s^2]
    
    T = 0;
    Cd = -b/((ms+mr)*L^2);
    
    B11 = 0.25*ms*L*L+mr*L*L+0.0833*ms*L*L+mr*R*R;
    
    G = (-ms*g*L/2-mr*g*L);
    
    dxdt = zeros(3,1);

    dxdt(1) = x(2);
    dxdt(2) =(Cd*x(2)+G*sin(x(1)))/B11; %sarebbe x3?

    
end