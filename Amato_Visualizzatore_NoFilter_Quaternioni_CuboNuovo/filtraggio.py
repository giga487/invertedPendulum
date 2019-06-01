#Questo file python fa il filtraggio di Mahony o di Madwick 
import time
import numpy as np
import math

#imu = Filtraggio(10,1,0.01)  #Tcampionamneto = 10ms Kp = 1  Ki = 0.01

class filter:
    def __init__(self,tCampionamento,beta,Ki,Deviazione = 0,q1 = 0,q2 = 0,q3 = 0,q4 = 0):
        #se la posizione iniziale non è zero, per qualche motivo
        self.tC = tCampionamento
        self.beta = beta
        self.Ki = Ki
        self.q1 = q1
        self.q2 = q2
        self.q3 = q3
        self.q4 = q4
        self.yaw = 0
        self.pitch = 0
        self.roll = 0
        self.yawD = 0
        self.pitchD = 0
        self.rollD = 0
        self.DeviazioneDegree = Deviazione #4° 40' equivale ad 4 e 40'/60' =  4.67 formato N-E
        self.rate = 0
        self.R = 0
        self.r21 = 0
        self.r11 = 0
        self.r31 = 0
        self.r32 = 0
        self.r33 = 0
        
        print("Generazione Dispositivo con %s ms di campionamento KP = %s KI = %s"%(self.tC,self.beta,self.Ki))
       
    def get_tC(self):
        return self.tC
        
    
    def MadgwickQuaternionUpdate(self , ax, ay, az, gx, gy, gz, mx, my, mz):
        #definizioni variabili
        #print("q1 = %s q2 = %s q3 = %s q4 = %s "%(self.q1,self.q2,self.q3,self.q4))
        deltat = self.tC
        beta = self.beta
        q1 = self.q1
        q2 = self.q2
        q3 = self.q3
        q4 = self.q4
        hx = hy = 0
        norm = 0
        #Auxiliary variables to avoid repeated arithmetic
        _2q1mx = 0
        _2q1my = 0
        _2q1mz = 0
        _2q2mx = 0
        _4bx = 0
        _4bz = 0
        _2q1 = 2.0 * self.q1
        _2q2 = 2.0 * self.q2;
        _2q3 = 2.0 * self.q3;
        _2q4 = 2.0 * self.q4;
        _2q1q3 = 2.0 * self.q1 * self.q3;
        _2q3q4 = 2.0 * self.q3 * self.q4;
        q1q1 = self.q1 * self.q1;
        q1q2 = self.q1 * self.q2;
        q1q3 = self.q1 * self.q3;
        q1q4 = self.q1 * self.q4;
        q2q2 = self.q2 * self.q2;
        q2q3 = self.q2 * self.q3;
        q2q4 = self.q2 * self.q4;
        q3q3 = self.q3 * self.q3;
        q3q4 = self.q3 * self.q4;
        q4q4 = self.q4 * self.q4;
        
        #Normalise accelerometer measurement
        norm = math.sqrt(ax * ax + ay * ay + az * az);
        try:
            norm = 1.0/norm;
        except:
            print("Errore, Norma nulla Accellerometro")
            
        ax *= norm;
        ay *= norm;
        az *= norm;
        
        #Normalise magnetometer measurement
        norm = math.sqrt(mx * mx + my * my + mz * mz);
        try:
            norm = 1.0/norm;
        except:
            print("Errore, Norma nulla Magnetometro")
        
        mx *= norm;
        my *= norm;
        mz *= norm;

        #Reference direction of Earth's magnetic field
        _2q1mx = 2.0 * self.q1 * mx;
        _2q1my = 2.0 * self.q1 * my;
        _2q1mz = 2.0 * self.q1 * mz;
        _2q2mx = 2.0 * self.q2 * mx;
        hx = mx * q1q1 - _2q1my * q4 + _2q1mz * q3 + mx * q2q2 + _2q2 * my * q3 + _2q2 * mz * q4 - mx * q3q3 - mx * q4q4;
        hy = _2q1mx * q4 + my * q1q1 - _2q1mz * q2 + _2q2mx * q3 - my * q2q2 + my * q3q3 + _2q3 * mz * q4 - my * q4q4;
        
        _2bx = math.sqrt(hx * hx + hy * hy);
        _2bz = -_2q1mx * q3 + _2q1my * q2 + mz * q1q1 + _2q2mx * q4 - mz * q2q2 + _2q3 * my * q4 - mz * q3q3 + mz * q4q4;
        _4bx = 2.0 * _2bx;
        _4bz = 2.0 * _2bz;
        
        
        #Gradient decent algorithm corrective step
        s1 = -_2q3 * (2.0 * q2q4 - _2q1q3 - ax) + _2q2 * (2.0 * q1q2 + _2q3q4 - ay) - _2bz * q3 * (_2bx * (0.5 - q3q3 - q4q4) + _2bz * (q2q4 - q1q3) - mx) + (-_2bx * q4 + _2bz * q2) * (_2bx * (q2q3 - q1q4) + _2bz * (q1q2 + q3q4) - my) + _2bx * q3 * (_2bx * (q1q3 + q2q4) + _2bz * (0.5 - q2q2 - q3q3) - mz);
        s2 = _2q4 * (2.0 * q2q4 - _2q1q3 - ax) + _2q1 * (2.0 * q1q2 + _2q3q4 - ay) - 4.0 * q2 * (1.0 - 2.0 * q2q2 - 2.0 * q3q3 - az) + _2bz * q4 * (_2bx * (0.5 - q3q3 - q4q4) + _2bz * (q2q4 - q1q3) - mx) + (_2bx * q3 + _2bz * q1) * (_2bx * (q2q3 - q1q4) + _2bz * (q1q2 + q3q4) - my) + (_2bx * q4 - _4bz * q2) * (_2bx * (q1q3 + q2q4) + _2bz * (0.5 - q2q2 - q3q3) - mz);
        s3 = -_2q1 * (2.0 * q2q4 - _2q1q3 - ax) + _2q4 * (2.0 * q1q2 + _2q3q4 - ay) - 4.0 * q3 * (1.0 - 2.0 * q2q2 - 2.0 * q3q3 - az) + (-_4bx * q3 - _2bz * q1) * (_2bx * (0.5 - q3q3 - q4q4) + _2bz * (q2q4 - q1q3) - mx) + (_2bx * q2 + _2bz * q4) * (_2bx * (q2q3 - q1q4) + _2bz * (q1q2 + q3q4) - my) + (_2bx * q1 - _4bz * q3) * (_2bx * (q1q3 + q2q4) + _2bz * (0.5 - q2q2 - q3q3) - mz);
        s4 = _2q2 * (2.0 * q2q4 - _2q1q3 - ax) + _2q3 * (2.0 * q1q2 + _2q3q4 - ay) + (-_4bx * q4 + _2bz * q2) * (_2bx * (0.5 - q3q3 - q4q4) + _2bz * (q2q4 - q1q3) - mx) + (-_2bx * q1 + _2bz * q3) * (_2bx * (q2q3 - q1q4) + _2bz * (q1q2 + q3q4) - my) + _2bx * q2 * (_2bx * (q1q3 + q2q4) + _2bz * (0.5 - q2q2 - q3q3) - mz);
        
        #print(s1,s2,s3,s4)
        
        #normalise step magnitude
        norm = math.sqrt(s1 * s1 + s2 * s2 + s3 * s3 + s4 * s4);   
        try:
            norm = 1.0/norm;
        except ZeroDivisionError:
            print("Errore, Norma nulla Gradienti")
            
        s1 *= norm;
        s2 *= norm;
        s3 *= norm;
        s4 *= norm;
        
        #Compute rate of change of quaternion
        qDot1 = 0.5 * (-q2 * gx - q3 * gy - q4 * gz) - beta * s1;
        qDot2 = 0.5 * (q1 * gx + q3 * gz - q4 * gy) - beta * s2;
        qDot3 = 0.5 * (q1 * gy - q2 * gz + q4 * gx) - beta * s3;
        qDot4 = 0.5 * (q1 * gz + q2 * gy - q3 * gx) - beta * s4;

        #Integrate to yield quaternion
        q1 += qDot1 * deltat;
        q2 += qDot2 * deltat;
        q3 += qDot3 * deltat;
        q4 += qDot4 * deltat;
        norm = math.sqrt(q1 * q1 + q2 * q2 + q3 * q3 + q4 * q4);    #normalise quaternion
        try:
            norm = 1.0/norm;
        except ZeroDivisionError:
            print("Errore, Norma nulla Quaternioni")
            
        self.q1 = q1 * norm;
        self.q2 = q2 * norm;
        self.q3 = q3 * norm;
        self.q4 = q4 * norm;
    
    def setYawDegree(self,yaw):
        self.yawD = yaw
    
    def setRollDegree(self,roll):
        self.rollD = roll
        
    def setPitchDegree(self,pitch):
        self.pitchD = pitch
    
    def getRfromQ(self):  #attenzione che secondo i miei calcoli è il Roll
        self.r32 = self.R1[1,2]
        self.r33 = self.R1[2,2]
        return math.atan2(self.r32,self.r33)*180/np.pi
    
    def getPfromQ(self):  #attenzione che secondo i miei calcoli è il pitch
        self.r31 = self.R1[2,0]
        self.r33 = self.R1[2,2]
        self.r32 = self.R1[2,1]
        return math.atan2(-self.r31,math.sqrt(self.r32*self.r32+self.r33*self.r33))*180/np.pi
        
    def getYfromQ(self):
        self.r21 = self.R1[1,0]
        self.r11 = self.R1[0,0]
        return math.atan2(self.r21,self.r11)*180/np.pi

    def Yaw(self):
        q1 = self.q1
        q2 = self.q2
        q3 = self.q3
        q4 = self.q4
        
        self.yaw = math.atan2(2*(q2*q3+q1*q4),q1*q1+q2*q2-q3*q3-q4*q4)
        return self.yaw+self.DeviazioneDegree
    
    def Roll(self):
        q1 = self.q1
        q2 = self.q2
        q3 = self.q3
        q4 = self.q4
        
        self.roll = math.atan2( 2.0 * (q1 * q1 + q3 * q4),q1*q1+q2*q2-q3*q3-q4*q4)
        return self.roll
    
    def Pitch(self):
        q1 = self.q1
        q2 = self.q2
        q3 = self.q3
        q4 = self.q4
        
        self.pitch = math.asin(2.0 * (q2 * q4 - q1 * q3))
        return self.pitch
    
    def getRotateMatrix(self, key):
        q1 = self.q1
        q2 = self.q2
        q3 = self.q3
        q4 = self.q4
        
        n2 = q1*q1
        qx2 = q2*q2
        qy2 = q3*q3
        qz2 = q4*q4
        nqx = q1*q2
        nqy = q1*q3
        nqz = q1*q4
        qxqy = q2*q3
        qxqz = q2*q4
        qyqz = q3*q4
        
        yaw2 = key.getRight()
        pitch2 = key.getUp()
        
        self.R1 = np.array([[1-2*(qy2+qz2),2*(qxqy-nqz),2*(qxqz+nqy)],[2*(qxqy+nqz),1-2*(qx2+qz2),2*(qyqz-nqx)],[2*(qxqz-nqy),2*(qyqz+nqx),1-2*(qx2+qy2)]])

        return self.R1
        
        
    def getRollFloat(self):
        return self.Roll()
        
    def getPitchFloat(self):
        return self.Pitch()
        
    def getYawFloat(self):
        return self.Yaw()
        
    def getRollDegree(self):
        return self.rollD
    def getPitchDegree(self):
        return self.pitchD
    def getYawDegree(self):      
        return self.yawD
'''Correzione dovuta alla declinazione magnetica.
    Latitude: 43° 23' 30'' North (43.3917° North)
    Longitude: 10° 26' 32'' East (10.4422° East)
    Date: 2018-04-27
    Magnetic declination: 2° 46.62' East
    Annual Change (minutes/year): 7.2 '/y East
'''

        
        




