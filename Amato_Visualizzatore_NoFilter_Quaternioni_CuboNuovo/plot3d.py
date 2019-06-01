

import pygame
import threading
from pygame.locals import *
from OpenGL.GLUT import *
from OpenGL.GLU import *
from OpenGL.GL import *
import numpy as np
import math
import sys


a = 0.5
b = 0.3
c = 0.1

yaw_d = 0
roll_d = 0
pitch_d = 0
#rgb
colors = (
    (0,0,0),
    (0,0,1),
    (0,1,0),
    (0,1,1),
    (1,0,0),
    (1,0,1),
    (1,1,0),
    (1,1,1),
    )
	
points = np.array(
		[[-a,-b,-c], #0
		[a,-b,-c],   #1
		[a,b,-c],    #2
		[-a,b,-c],   #3
		[-a,b,c],    #4
		[a,b,c],     #5
		[a,-b,c],   #6
		[-a,-b,c]])   #7
				  

class OPENGL_PLOT:

    def __init__(self,nome,color,keyboard):
        self.nome = nome
        self.color = color
        self.i = 0
        self.right = 0
        self.up = 0
        self.keyboard = keyboard

        print("Creazione Classe Visualizzatore %s"%self.nome)
        pygame.init()
        display = (800,600)
        pygame.display.set_mode(display,DOUBLEBUF|OPENGL)
        self.font = pygame.font.SysFont("Arial",18,False)
        
        #Resize
        glViewport(0,0,800,600)
        glMatrixMode(GL_PROJECTION)
        glLoadIdentity()
        gluPerspective(30,1*800/600,0.1,80)
        glMatrixMode(GL_MODELVIEW)
        glLoadIdentity()
        
        #init
        glShadeModel(GL_SMOOTH)
        glEnable(GL_DEPTH_TEST)
        glDepthFunc(GL_LEQUAL)
        glHint(GL_PERSPECTIVE_CORRECTION_HINT,GL_NICEST)
        
        self.R_axis = np.dot(self.Rotate("x",-90), self.Rotate("z",-90))
        
    def Clear(self):
        glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT)
        glLoadIdentity()
        glTranslatef(0,0,-7)
        
    def DisplayFlip(self):
        pygame.display.flip()
     
    def Rotate(self,axis,angle):  #angle in degree
        angle2 = angle*np.pi/180.0
        if(axis == "x"):
            R = np.array([[1,0,0],[0,np.cos(angle2),-np.sin(angle2)],[0,np.sin(angle2),np.cos(angle2)]])
        elif(axis == "y"):
            R = np.array([[np.cos(angle2),0,np.sin(angle2)],[0,1,0],[-np.sin(angle2),0,np.cos(angle2)]])
        elif(axis == "z"):
            R = np.array([[np.cos(angle2),-np.sin(angle2),0],[np.sin(angle2),np.cos(angle2),0],[0,0,1]])
        
        R = np.round(R,decimals = 3)
        return R
            
    def txt_string(self,pos,string):
        textSurface = self.font.render(string, True, (255,255,255,255),(0,0,0,255))
        textData = pygame.image.tostring(textSurface,"RGBA",True)
        glRasterPos3d(*pos)
        glDrawPixels(textSurface.get_width(),textSurface.get_height(), GL_RGBA,GL_UNSIGNED_BYTE, textData)
    
    def DrawText(self,string):
        q_tot = string.split(" ")
        
        title_string = ("Visualizzatore IMU")
        self.txt_string((-0.4,1.7,0),title_string)
        
        q_string = ("q0  %s"%(np.round(float(q_tot[0]),decimals = 2)))
        self.txt_string((-2.4,1.1,0),q_string)
        
        q_string = ("q1  %s x"%(np.round(float(q_tot[1]),decimals = 2)))
        self.txt_string((-2.4,0.9,0),q_string)
        
        q_string = ("q2  %s y"%(np.round(float(q_tot[2]),decimals = 2)))
        self.txt_string((-2.4,0.7,0),q_string)
        
        q_string = ("q3  %s z"%(np.round(float(q_tot[3]),decimals = 2)))
        self.txt_string((-2.4,0.5,0),q_string)
        
        q_string = ("Rate f  %s Hz"%(np.round(float(q_tot[4]),decimals = 2)))
        self.txt_string((-2.4,0.3,0),q_string)
        
        string = ("Gig@487")
        self.txt_string((2,-1.8,0),string)
        
        spiegazione_string = ("Con l'utilizzo delle frecce direzionali e' possibile ruotare la visuale")
        self.txt_string((-1.2,-1.4,0),spiegazione_string)
        
        spiegazione_string = ("D ( senso AntiOrario ) e A ( senso Orario ) spostano la visuale intorno allo Yaw")
        self.txt_string((-1.8,-1.6,0),spiegazione_string)
        
        spiegazione_string = ("W e S spostano la visuale intorno al Pitch")
        self.txt_string((-1.8,-1.8,0),spiegazione_string)
        
        '''
        roll_string = ("Roll  %s"%(np.round(float(q_tot[5]),decimals = 2)))
        self.txt_string((-2.4,0.5,0),roll_string)
        
        pitch_string = ("Pitch  %s"%(np.round(float(q_tot[6]),decimals = 0)))
        self.txt_string((-2.4,0.3,0),pitch_string)
        
        yaw_string = ("Yaw  %s "%(np.round(float(q_tot[7]),decimals = 0)))        
        self.txt_string((-2.4,0.1,0),yaw_string)
        '''
        
    def Axes(self,R_quat):
        
        self.R_axis = np.dot(np.dot(self.R_axis,self.Rotate("z",self.keyboard.getRight())),self.Rotate("y",self.keyboard.getUp()))
        self.R = np.dot(self.R_axis,R_quat)
        
            
        x_axes = np.array([0.5,0,0]) 
        y_axes = np.array([0,0.5,0])
        z_axes = np.array([0,0,0.5])
        
        zero = np.array([0,0,0])
        
        glBegin(GL_LINES)
        
        glColor3f(1,0,0)
        glVertex3fv(zero)
        glVertex3fv(2*np.dot(self.R,x_axes))
        glColor3f(0.0,1.0,0.0)
        glVertex3fv(zero)
        glVertex3fv(2*np.dot(self.R,y_axes))
        glColor3f(0.0,0,1.0)
        glVertex3fv(zero)
        glVertex3fv(2*np.dot(self.R,z_axes))
        glEnd()
        '''
        glBegin(GL_LINES)        
        glColor3f(1,0,0)
        glVertex3fv(zero)
        glVertex3fv(2*x_axes)
        glColor3f(0,1,0.0)
        glVertex3fv(zero)
        glVertex3fv(4*y_axes)
        glColor3f(0,0,1.0)
        glVertex3fv(zero)
        glVertex3fv(6*z_axes)
        glEnd()
        '''
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                pygame.quit()
                quit()
                
    def Cube(self,R_quat):
        
        self.R_axis = np.dot(np.dot(self.R_axis,self.Rotate("z",self.keyboard.getRight())),self.Rotate("y",self.keyboard.getUp()))
        self.R = np.dot(self.R_axis,R_quat)
        
        Z = np.zeros((8,3))  #ogni elemento di Z è un vertice
        #print(self.R)
        
        for i in range(8):
            Z[i,:] = np.dot(self.R,points[i,:])
        
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)
        glMatrixMode(GL_MODELVIEW)
        
        glBegin(GL_POLYGON)
        glColor3f(0.2,0.2,0)  #bottom Verdinoscuro
        glVertex3f(Z[0,0],Z[0,1],Z[0,2])
        glVertex3f(Z[1,0],Z[1,1],Z[1,2])
        glVertex3f(Z[2,0],Z[2,1],Z[2,2])
        glVertex3f(Z[3,0],Z[3,1],Z[3,2]) 
        glEnd()

        glBegin(GL_POLYGON)  
        glColor3f(0.0,0.4,0.8) #left 
        glVertex3f(Z[2,0],Z[2,1],Z[2,2])
        glVertex3f(Z[3,0],Z[3,1],Z[3,2])
        glVertex3f(Z[4,0],Z[4,1],Z[4,2])
        glVertex3f(Z[5,0],Z[5,1],Z[5,2]) 
        glEnd()
        
        glBegin(GL_POLYGON)
        glColor3f(0.0,1.0,1.0) #top
        glVertex3f(Z[4,0],Z[4,1],Z[4,2])
        glVertex3f(Z[5,0],Z[5,1],Z[5,2])
        glVertex3f(Z[6,0],Z[6,1],Z[6,2])
        glVertex3f(Z[7,0],Z[7,1],Z[7,2])
        glEnd()

        glBegin(GL_POLYGON)
        glColor3f(1.0,1.0,1.0) #Front x+
        glVertex3f(Z[5,0],Z[5,1],Z[5,2])
        glVertex3f(Z[2,0],Z[2,1],Z[2,2])
        glVertex3f(Z[1,0],Z[1,1],Z[1,2])
        glVertex3f(Z[6,0],Z[6,1],Z[6,2])
        glEnd()
        
        glBegin(GL_POLYGON)
        glColor3f(0.5,0.5,1.0)  #back
        glVertex3f(Z[0,0],Z[0,1],Z[0,2]) 
        glVertex3f(Z[3,0],Z[3,1],Z[3,2])
        glVertex3f(Z[4,0],Z[4,1],Z[4,2]) 
        glVertex3f(Z[7,0],Z[7,1],Z[7,2]) 
        glEnd()

        glBegin(GL_POLYGON)
        glColor3f(0.5,0,0)   #right
        glVertex3f(Z[7,0],Z[7,1],Z[7,2]) 
        glVertex3f(Z[0,0],Z[0,1],Z[0,2])
        glVertex3f(Z[1,0],Z[1,1],Z[1,2])
        glVertex3f(Z[6,0],Z[6,1],Z[6,2])
        glEnd()
        
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                pygame.quit()
                quit()