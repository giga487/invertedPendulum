
function dxdt = odefunctionpendulum(t,x)
    m = 1;
    l = 0.5;
    b = 0.05;
    
    dxdt = zeros(2,1);
    dxdt(1) = x(2);
    dxdt(2) = -9.81/1*sin(x(1))-b/(m*l^2)*x(2);
end