import serial
import threading
from threading import Thread
import filtraggio
import time
import math


class LetturaSeriale(Thread):
    def __init__(self,nome,time_read,imu):
        Thread.__init__(self)
        self.nome = nome
        self.time_read = time_read
        self.imu = imu
        self.lock = threading.Lock()
        
        self.ax = 0
        self.ay = 0
        self.az = 0
        self.gx = 0
        self.gy = 0
        self.gz = 0
        self.mx = 0
        self.my = 0
        self.mz = 0
        self.yaw = 0
        self.roll = 0
        self.pitch = 0
        self.q1 = 0
        self.q2 = 0
        self.q3 = 0
        self.q4 = 0
        
    def convert(self,elemento,old):
        try:
            data_conversion = float(elemento)
            return data_conversion
        except:
            return old
        
    def run(self):
        i = 0
        ser = serial.Serial("com7", 38400, timeout= 0.010)	
        
        tempo_iniziale = time.time()
        tempo_finale = tempo_iniziale + float(self.time_read)
        deltat = float(tempo_finale - tempo_iniziale)
        
        dati = [0]
        d = 0
        while deltat > 0:
            d = d + 1
            i = i + 1
            dati.append(ser.readline())
            
            stringa_esame = str(dati[d])
            #stringa_esame = "string_ q1 0 q2 0.4 q3 0.5 q4 0"
            
            stringa_lista = stringa_esame.split(" ")
            #print(stringa_lista)
            
            self.lock.acquire()
            if stringa_esame.find("string_") != -1:	
                self.imu.q1 = float(stringa_lista[3])
                self.imu.q2 = float(stringa_lista[5])
                self.imu.q3 = float(stringa_lista[7])
                self.imu.q4 = float(stringa_lista[9])
                self.imu.rate = float(stringa_lista[11])
                
            
            #print("q1 %s q2 %s q3 %s q4 %s rate %s"%(self.imu.q1,self.imu.q2,self.imu.q3,self.imu.q4, self.imu.rate))
            self.lock.release()
            
            time.sleep(self.imu.get_tC())
            now = time.time()
            deltat = float(tempo_finale - now)
            
        print("Fine Processo %s"%self.nome)
        
