import os
import psycopg2


def clear():
    """ Cancella la console."""
    os.system("clear")
    
def connect():
    """ Connetti al database."""
    connessione = psycopg2.connect(
        
    )
    return connessione