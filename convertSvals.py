

import os
import numpy
import pandas as pd
import sympy as sp
from sympy import symbols, Eq, solve, im
import math



def tand(x):
    return sp.tan(x * sp.pi / 180)
def sind(x):
    return sp.sin(x * sp.pi / 180)
def cosd(x):
    return sp.cos(x * sp.pi / 180)
def cotd(x):
    return sp.cot(x * sp.pi / 180)
def sqrt(x):
    return math.sqrt(x)
def cos(x):
    return math.cos(x)
def sin(x):
    return math.sin(x)

"""constants"""
pi=math.pi
j=1j
Z0= 120*pi
"""constants"""

"""Inputs"""
phaseShift= 30 #The desired phase shift we want. Real world angle shift of antenna waves
freq= 10e9 # for 10 GHz atenna, can be altered
inputAngle=0
outputAngle=80
polarization = 'TM' # can be either TM or TE
"""Inputs"""

"""Substrate Constants"""
L= 2*1.27e-3 #subtrate thickness constant specific to substrate
substratePermit= 10.2 #relative permeativity of RO3010.
"""Substrate Constants"""

c0 = 1/sqrt(4*pi*1e-7 * 8.85 * 1e-12) # velocity of light in free space (air or vaccum)
beta = sqrt(substratePermit)*2*pi/(c0/freq) # wavenumber in the substrate
Zc = Z0 /sqrt(substratePermit) # Note that due to the presence of dielectric constant, the characteristic impedance of the substrate is different than Z0.


# function to take in the two output files from HFSS in s value and return z values
def convert_svals(realfile,imgfile,trace):
    dfreal=pd.read_csv(realfile)
    dfimg=pd.read_csv(imgfile)
    
    ##have to change the column names
    s11real = dfreal.iloc[0]["re(S(FloquetPort1:1,FloquetPort1:1)) []"]
    s12real = dfreal.iloc[0]["re(S(FloquetPort1:1,FloquetPort2:1)) []"]
    s21real = dfreal.iloc[0]["re(S(FloquetPort2:1,FloquetPort1:1)) []"]
    s22real = dfreal.iloc[0]["re(S(FloquetPort2:1,FloquetPort2:1)) []"]
    s11img = dfimg.iloc[0]["im(S(FloquetPort1:1,FloquetPort1:1)) []"]
    s12img = dfimg.iloc[0]["im(S(FloquetPort1:1,FloquetPort2:1)) []"]
    s21img = dfimg.iloc[0]["im(S(FloquetPort2:1,FloquetPort1:1)) []"]
    s22img = dfimg.iloc[0]["im(S(FloquetPort2:1,FloquetPort2:1)) []"]
    Y1,Y2,Y3 = sp.symbols("Y1, Y2, Y3")
    
    s1=s11real+s11img*j
    s2=s12real+s12img*j
    s3=s21real+s21img*j
    s4=s22real+s22img*j
    
    sMat=sp.Matrix([[s1,s2],[s3,s4]])
    
    T11 = (1/(2*sMat[1,0]))*((1 + sMat[0,0])*(1 - sMat[1,1]) + sMat[0,1]*sMat[1,0]).evalf()
    T12 = (Z0/(2*sMat[1,0]))*((1 + sMat[0,0])*(1 + sMat[1,1]) - sMat[0,1]*sMat[1,0]).evalf()
    T21 = (1/(Z0*2*sMat[1,0]))*((1 - sMat[0,0])*(1 - sMat[1,1]) - sMat[0,1]*sMat[1,0]).evalf()
    T22 = (1/(2*sMat[1,0]))*((1 - sMat[0,0])*(1 + sMat[1,1]) + sMat[0,1]*sMat[1,0]).evalf()
    
    tMat=sp.Matrix([[T11,T12],[T21,T22]])
    
    T4= sp.Matrix([[cos(beta*L),j*Zc*sin(beta*L)],[j*sin(beta*L)/Zc,cos(beta*L)]])
    
    
    if(trace=="top"):
        solvedT=tMat/T4/T4
        
    if(trace=="mid"):
        solvedT=T4.inv()*T4.inv()*tMat.inv()
        
    if(trace=="bot"):
        solvedT=T4.inv()*tMat*T4.inv()
        

    Yval = solvedT[1,0].evalf()
    Impedance=(1/Yval).evalf()
    return im(Impedance)



realfile = ("C:/Users/shael/Desktop/HFSSscript/Example_Sparam_Real.csv")
imgfile= ("C:/Users/shael/Desktop/HFSSscript/Example_Sparam_Imaginary.csv")
impedance =convert_svals(realfile,imgfile,"top")
    


