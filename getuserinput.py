# -*- coding: utf-8 -*-
"""
Created on Thu Aug 29 19:14:27 2019

@author: shael
"""
from tkinter import *
import tkinter as tk

root= tk.Tk()
canvas1= tk.Canvas(root,width=475,height=200)
canvas1.pack()

entry1= tk.Entry(root)
canvas1.create_window(200,80,window=entry1)
entry2= tk.Entry(root)
canvas1.create_window(200,100,window=entry2)
entry3= tk.Entry(root)
canvas1.create_window(200,120,window=entry3)

button1=tk.Button(root,text='Find Z Matrix Given these Y Values', command=getInput)
canvas1.create_window(375, 100, window=button1)

root.mainloop()


def getInput():
    y1=entry1.get();
    y2=entry2.get();
    y3=entry3.get();
    
    print(y1)
    print(y2)
    print(y3)


