%main pendolo
clc;
clear;
close all;

%LA simulazione funziona bene, è stato inserito un coefficiente di
%smorzamento b/(m*l^2)*w;


x = ode45(@odefunctionpendulum,[0 20],[0.5;0]);

plot(x.x,x.y(1,:),'k',x.x,x.y(2,:),'b');

