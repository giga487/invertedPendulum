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


class PlotRPY:
    def __init__(self,tPlot,tempoTotale,imu):
        self.tC = tPlot #Refresh dell immagine
        self.tMax = tempoTotale
        self.imu = imu
        self.t = 0
        
        # Data Update
        # Data Update
        self.xmin = 0.0
        self.xmax = 5.0
        self.x = 0.0
        
        # Setup figure and subplots
        self.f0 = figure(num = 0, figsize = (10, 6))#, dpi = 100)

        self.f0.suptitle("Roll Pitch Yaw", fontsize=12)
        self.ax01,self.ax02,self.ax03 = self.f0.subplots(nrows=1, ncols=3)

        # Set titles of subplots
        self.ax01.set_title('Yaw')
        self.ax02.set_title('Roll')
        self.ax03.set_title('Pitch')

        # set y-limits
        self.ax01.set_ylim(-360,360)
        self.ax02.set_ylim(-360,360)
        self.ax03.set_ylim(-360,360)

        # sex x-limits
        self.ax01.set_xlim(0,5.0)
        self.ax02.set_xlim(0,5.0)
        self.ax03.set_xlim(0,5.0)

        # Turn on grids
        self.ax01.grid(True)
        self.ax02.grid(True)
        self.ax03.grid(True)

        # set label names
        self.ax01.set_xlabel("t")
        self.ax01.set_ylabel("Yaw")
        self.ax02.set_xlabel("t")
        self.ax02.set_ylabel("Roll")
        self.ax03.set_xlabel("t")
        self.ax03.set_ylabel("Pitch")

        # Data Placeholders
        self.yaw_plot =[]
        self.roll_plot=[]
        self.pitch_plot=[]
        self.t=[]

        # set plots
        self.p1, = self.ax01.plot(self.t,self.yaw_plot,'b-', label="Yaw")
        self.p2, = self.ax02.plot(self.t,self.roll_plot,'g-', label="Roll")
        self.p3, = self.ax03.plot(self.t,self.pitch_plot,'g-', label="Pitch")

    def updateData(self):
        self.yaw_plot.append(self.imu.getYawDegree())
        self.roll_plot.append(self.imu.getRollDegree())
        self.pitch_plot.append(self.imu.getYawDegree())
        self.t.append(self.x)
        self.x += 0.017

        self.p1.set_data(t,yaw_plot)
        self.p2.set_data(t,roll_plot)
        self.p3.set_data(t,pitch_plot)

        if x >= xmax-1.00:
            self.p1.axes.set_xlim(x-xmax+1.0,x+1.0)
            self.p2.axes.set_xlim(x-xmax+1.0,x+1.0)
            self.p3.axes.set_xlim(x-xmax+1.0,x+1.0)

        return self.p1, self.p2, self.p3