import threading
from threading import Thread
import time
import pygame
import numpy as np


class Input(Thread):
    def __init__(self,nome,tempo_letto,keyboard):
        Thread.__init__(self)
        self.nome = nome
        self.tempo_letto = tempo_letto
        self.lock = threading.Lock()
        self.KeyBoard = keyboard
    
    def run(self):
        print("Thread %s avviato"%self.nome)
        
        pygame.key.set_repeat(10, 10)
        
        tempo_iniziale = time.time()
        tempo_finale = tempo_iniziale + float(self.tempo_letto)
        deltat = float(tempo_finale - tempo_iniziale)

        while deltat > 0:
            self.lock.acquire()
            
            self.Read_K(self.KeyBoard)
            #print(self.KeyBoard.getRight())
            #print(self.KeyBoard.getUp())
            
            self.lock.release()
            
            time.sleep(0.05)  #60fps
            #pygame.event.clear()
            now = time.time()
            deltat = float(tempo_finale - now)
            
        print("Fine Processo %s"%self.nome)
    
    def Read_K(self,key):
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                pygame.quit()
                sys.exit()
                
            if event.type == pygame.KEYDOWN and event.key == pygame.K_w:
                key.up = key.up - 2
            elif event.type == pygame.KEYDOWN and event.key == pygame.K_s:
                key.up = key.up + 2
            elif event.type == pygame.KEYDOWN and event.key == pygame.K_d:
                key.right = key.right + 2
            elif event.type == pygame.KEYDOWN and event.key == pygame.K_a:
                key.right = key.right - 2
            elif event.type == pygame.KEYDOWN and event.key == pygame.K_SPACE:
                key.zero()
        
        #print(key.right,key.up)
        

class Angle_View:
    def __init__(self, up = 0, right = 0):
        self.up = up
        self.right = right
    
    def getRight(self):
        return self.right
        
    def getUp(self):
        return self.up
        
    def zero(self):
        self.right = 0
        self.up = 0
    
   # def ResetConf(self):
        
        