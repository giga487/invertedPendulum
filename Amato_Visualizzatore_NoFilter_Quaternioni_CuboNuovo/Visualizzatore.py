
import sys
import lettura_seriale
import filtraggio
from datetime import datetime
import plot3d
import Thread_Grafico
import KeyBoard

if __name__ == '__main__':
    time_read = input('Tempo di esecuzione: ')
    tc = 1/512
    imu = filtraggio.filter(tc,5,0,0,0,0,0,0)  #QUATERNIONI INIZIALI 1,1,1,1 
    key_board = KeyBoard.Angle_View()
    opengl = Thread_Grafico.VisualizzatoreGrafico('OpenGL',time_read,imu,key_board)
    serial = lettura_seriale.LetturaSeriale("Lettura Seriale",time_read,imu)
    key_thread = KeyBoard.Input("KeyBoard Input",time_read,key_board)
    
    serial.start()
    opengl.start()
    key_thread.start()

