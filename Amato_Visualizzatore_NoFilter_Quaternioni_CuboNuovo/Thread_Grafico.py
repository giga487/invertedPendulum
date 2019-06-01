import plot3d
import threading
from threading import Thread
import time
import pygame

class VisualizzatoreGrafico(Thread):
    def __init__(self,nome,tempo_letto,imu,keyBoard):
        Thread.__init__(self)
        self.nome = nome
        self.tempo_letto = tempo_letto
        self.imu = imu
        self.lock = threading.Lock()
        self.R = 0
        self.up = 0
        self.right = 0
        self.keyboard = keyBoard
        
    def run(self):
        print("Thread %s avviato"%self.nome)
        graf = plot3d.OPENGL_PLOT("Cube",0,self.keyboard)
        i = 0
        R = 0
        tempo_iniziale = time.time()
        tempo_finale = tempo_iniziale + float(self.tempo_letto)
        deltat = float(tempo_finale - tempo_iniziale)

        while deltat > 0:
            graf.Clear()
            i = i+1
            self.lock.acquire()
            
            self.R = self.imu.getRotateMatrix(self.keyboard)

            string = ("%s %s %s %s %s %s %s %s"%(self.imu.q1,self.imu.q2,self.imu.q3,self.imu.q4, self.imu.rate,self.imu.getRfromQ(),self.imu.getPfromQ(),self.imu.getYfromQ()))
            
            graf.Cube(self.R)
            graf.Axes(self.R)
            graf.DrawText(string)

            self.lock.release()
            
            graf.DisplayFlip()
            
            self.keyboard.zero()            
            time.sleep(0.015)  #60fps
            
            now = time.time()
            deltat = float(tempo_finale - now)
            
        print("Fine Processo %s"%self.nome)
