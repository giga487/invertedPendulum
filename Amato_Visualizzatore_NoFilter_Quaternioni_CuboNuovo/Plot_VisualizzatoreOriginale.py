
import sys
import lettura_seriale
import filtraggio
from matplotlib import pyplot
from matplotlib.animation import FuncAnimation
from datetime import datetime
from matplotlib import pyplot
from matplotlib.animation import FuncAnimation
from random import randrange
from matplotlib.pylab import *
from mpl_toolkits.axes_grid1 import host_subplot
import matplotlib.animation as animation
from random import randrange

# Setup figure and subplots
f0 = figure(num = 0, figsize = (10, 6))#, dpi = 100)
f0.suptitle("Roll Pitch Yaw", fontsize=12)
ax01,ax02,ax03 = f0.subplots(nrows=1, ncols=3)

# Set titles of subplots
ax01.set_title('Yaw')
ax02.set_title('Roll')
ax03.set_title('Pitch')

# set y-limits
ax01.set_ylim(-500,500)
ax02.set_ylim(-500,500)
ax03.set_ylim(-500,500)

# sex x-limits
ax01.set_xlim(0,5.0)
ax02.set_xlim(0,5.0)
ax03.set_xlim(0,5.0)

# Turn on grids
ax01.grid(True)
ax02.grid(True)
ax03.grid(True)

# set label names
ax01.set_xlabel("t")
ax01.set_ylabel("Yaw")
ax02.set_xlabel("t")
ax02.set_ylabel("Roll")
ax03.set_xlabel("t")
ax03.set_ylabel("Pitch")

# Data Placeholders
yaw_plot =[]
roll_plot=[]
pitch_plot=[]
t=[]

# set plots
p1, = ax01.plot(t,yaw_plot,'b-', label="Yaw")
p2, = ax02.plot(t,roll_plot,'g-', label="Roll")
p3, = ax03.plot(t,pitch_plot,'g-', label="Pitch")

# Data Update
# Data Update
xmin = 0.0
xmax = 5.0
x = 0.0

def updateData(self):
    global x
    global t
    
    yaw_plot.append(imu.getYawDegree())
    roll_plot.append(imu.getRollDegree())
    pitch_plot.append(imu.getYawDegree())
    t.append(x)
    x += 0.200

    p1.set_data(t,yaw_plot)
    p2.set_data(t,roll_plot)
    p3.set_data(t,pitch_plot)

    if x >= xmax-1.00:
        p1.axes.set_xlim(x-xmax+1.0,x+1.0)
        p2.axes.set_xlim(x-xmax+1.0,x+1.0)
        p3.axes.set_xlim(x-xmax+1.0,x+1.0)

    return p1, p2, p3

if __name__ == '__main__':
    time_read = input('Tempo di esecuzione: ')
    tc = 0.001
    imu = filtraggio.filter(tc,0.014,1,4.5,0,0,0,1)  #QUATERNIONI INIZIALI 1,1,1,1 
    serial = lettura_seriale.LetturaSeriale("Lettura Seriale",time_read,imu)
    serial.start()
    intervallo = 200
    
    simulation = animation.FuncAnimation(f0, updateData, blit=False, frames=500*time_read, interval = intervallo,repeat=False)

    plt.show()

