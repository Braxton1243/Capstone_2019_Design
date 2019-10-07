# -*- coding: utf-8 -*-
"""
Created on Sun Sep 15 14:09:24 2019

@author: shael

Create our dogbone z value database to store all of our values
"""
import mysql
import mysql.connector
import pandas

def insert_zvals(dogbonewidth,z1,z2,z3):
    if db_exists('dogboneZvals'):
    
        mydb = mysql.connector.connect(
                host='localhost',
                user='root',
                passwd='',
                database='dogboneZvals'
                )
        mycursor = mydb.cursor()
        query= "INSERT INTO zvals (dogbone_size,z1,z2,z3) VALUES (%s,%s,%s,%s)"
        val=(dogbonewidth,z1,z2,z3)
        mycursor.execute(query,val)
        mydb.commit()
        

def db_exists(db_name):
    
    try:
        mydb= mysql.connector.connect(
        
        host="localhost",
        user='root',
        passwd='',
        database=db_name
        )
        return True
    except:
        return False
    




if not db_exists('dogboneZvals'):
    mydb= mysql.connector.connect( 
           host="localhost",
           user='root',
           passwd=''
            )
    
    mycursor = mydb.cursor()
    
    mycursor.execute("CREATE DATABASE dogboneZvals")
    
###creating the table for our vals#

def create_table(tablename):
    if db_exists(tablename):
        
        mydb = mysql.connector.connect(
                host='localhost',
                user='root',
                passwd='',
                database='dogboneZvals'
                )
        mycursor = mydb.cursor()
        mycursor.execute("CREATE TABLE %s (id INT AUTO_INCREMENT PRIMARY KEY, dogbone_size FLOAT(7,5), z1 FLOAT(9,6),z2 FLOAT(9,6) , z3 FLOAT(9,6))") %(tablename)
insert_zvals(1,1,1,1)  ## test   


