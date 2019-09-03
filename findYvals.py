# -*- coding: utf-8 -*-
"""
Created on Tue Sep  3 16:15:35 2019
@author: Puyan Mojabi, Shael Minuk
This is a python version of the code sent by Dr. Puyan Mojabi. We will be using 
for our Design project in 2019 for metasurface design. The code will take a 
design phase shift for the design in degrees, and calculates Y1,Y2,Z1,Z2,Z3 
that would be required for the real world design of this surface. We hope to
extrpolate this and use machine learning to approximate the deisng to get
as close to these experimental values as we can
"""

import math
import numpy as np
import sympy as sp
from sympy import symbols, Eq, solve

"""functions""" # writing these to make the code more readable
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

"""functions"""

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

"""constants"""
pi=math.pi
j=1j
"""constants"""

Z0= 120*pi

if polarization == 'TM':
    ZL = Z0*cosd(outputAngle)
    ZS= Z0*cosd(inputAngle)
elif polarization == 'TE':
    ZL = Z0/cosd(outputAngle)
    ZS= Z0/cosd(inputAngle)

c0 = 1/sqrt(4*pi*1e-7 * 8.85 * 1e-12) # velocity of light in free space (air or vaccum)
beta = sqrt(substratePermit)*2*pi/(c0/freq) # wavenumber in the substrate
Zc = Z0 /sqrt(substratePermit) # Note that due to the presence of dielectric constant, the characteristic impedance of the substrate is different than Z0.

# Calculating the ABCD Parameters of the impedance sheets
# Defining three symbols in MATLAB. Note that Y1, Y2, and Y3 are ADMITTANCES, NOT impedances
# using sympy6 for matrix ops, good documentation online
Y1,Y2,Y3 = sp.symbols("Y1, Y2, Y3")
T1= sp.Matrix([[1,0],[Y1,1]])
T3= sp.Matrix([[1,0],[Y2,1]])
T5= sp.Matrix([[1,0],[Y3,1]])

T4= sp.Matrix([[cos(beta*L),j*Zc*sin(beta*L)],[j*sin(beta*L)/Zc,cos(beta*L)]])
T2 = T4

T = T1 * T2 * T3 * T4 * T5 ;

phi= -phaseShift
Z11 = -j * ZS * cotd(phi)
Z12 = -j * sqrt(ZS * ZL) / sind(phi)
Z21 = Z12 # this is due to the reciprocity.
Z22 = -j * ZL * cotd(phi)

Z=sp.Matrix([[Z11,Z12],[Z21,Z22]])

A = Z11/Z21
B = Z.det()/Z21
C = 1/Z21
D = Z22/Z21

eqns=sp.Matrix([A==T[0,0],B==T[0,1],D==T[1,1]])

eq1=Eq(A-T[0,0]) 
eq2=Eq(B-T[0,1])
eq3=Eq(D-T[1,1])


sol=sp.nonlinsolve((eq1,eq2,eq3),(Y1,Y2,Y3))
(Y1,Y2,Y3)=next(iter(sol))

Y1=Y1.evalf()
Y2=Y2.evalf()
Y3=Y3.evalf()

ObtainedZ1 = 1/Y1 # this is the inverse of Y1. Therefore, it is Z1.
ObtainedZ2 = 1/Y2 # this is the inverse of Y2. Therefore, it is Z2.
ObtainedZ3 = 1/Y3 # this is the inverse of Y2. Therefore it is Z3.

solutionstatement= "The Solutions for Z1,Z2,Z3 are:Z1:%s,Z2:%s,Z3:%s" % (ObtainedZ1 ,ObtainedZ2 ,ObtainedZ3)
print(solutionstatement)
      













