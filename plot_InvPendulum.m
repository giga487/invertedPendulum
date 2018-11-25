%% 
model = 'inv_Pendulum_L';
load_system(model)
sim(model)

%% PLOT RESULTs

L = 1;
dt = 0;

min_Torque = min(Torque);
max_Torque = max(Torque);
min_w = min(w_rad_at_s);
max_w = max(w_rad_at_s);
max_angle = max(angle_rad);
min_angle = min(angle_rad);

figure;
subplot(3,1,1);
Motor_Speed_animL = animatedline;
axis([0 100 min_w*1.5 max_w*1.5]);
xlabel('time [s]');ylabel('Speed rad/s');

subplot(3,1,2);
Torque_animL = animatedline;
axis([0 100 min_Torque*1.5 max_Torque*1.5]);
xlabel('time [s]');ylabel('Torque Kg/m');

subplot(3,1,3);
Angle_animL = animatedline;
axis([0 100 min_angle*1.5 max_angle*1.5]);
xlabel('time [s]');ylabel('Angle rad');

figure;
for i = 1:1:size(angle_rad)
    dt = dt + Time_Campionamento;
% 
%     addpoints(Motor_Speed_animL,dt,w_rad_at_s(i));
%     addpoints(Torque_animL,dt,Torque(i));
%     addpoints(Angle_animL,dt,angle_rad(i));
%     drawnow limitrate;
    
    %clf;
    angle = angle_rad(i);
    xf = L*sin(angle);
    yf = L*cos(angle);
    x = [0,xf];
    y = [0,yf];
    line(x,y); hold on; grid on;
    viscircles([xf yf],0.05,'color','black');
    axis([-1 1 -0.2 1.2]);
    hold off;
    pause(0.001);
    drawnow limitrate;
%     
end
