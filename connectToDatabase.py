# -*- coding: utf-8 -*-
"""
Created on Sun Sep 15 14:09:24 2019

@author: shael

Create our dogbone z value database to store all of our values
"""
import mysql
import mysql.connector
import pandas

mydb = None

def insert_zvals(dogbonewidth,z1,z2,z3):
    if db_connected():
        mycursor = mydb.cursor()
        query= "INSERT INTO zvals (dogbone_size,z1,z2,z3) VALUES (%s,%s,%s,%s)"
        val=(dogbonewidth,z1,z2,z3)
        mycursor.execute(query,val)
        mydb.commit()
        

def db_connected():
    global mydb
    return not mydb == None
    
def connect_to_db(db, hostname, username, password):
    if not db_connected():
        mydb = mysql.connector.connect(
                host=hostname,
                user=username,
                passwd=password,
                database=db)
        
connect_to_db("metasurface_design", "localhost", "msurf-script", "Capstone#2019")

print(db_connected())


