
function [B,C,G] = Dynamic_Sim(q,dq)
    
    L = 0.25;
    g = 9.81;
    m_1 = 0.05;
    m_2 = 0.400;
    m_3 = 0.300;
    I_zz1 = 2.604e-04;
    I_zz2 = 0.00124;
    I_zz3 = 0.0208125;

    x1 = q(1);
    x2 = q(2);
    dx1 = dq(1);
    dx2 = dq(2);

    G = [ -(L*g*sin(x1)*(m_1 + 2*m_2 + 2*m_3))/2;
                                              0];
                                          
    B = [ Izz1 + Izz2 + Izz3 + (L^2*m_1)/4 + L^2*m_2 + L^2*m_3, Izz2;
                                                          Izz2, Izz2];

    C =   [0, 0;
           0, 0];

end
                                      