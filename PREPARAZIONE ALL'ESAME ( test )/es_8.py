import os
import psycopg2
from mysecrets import dbhost, dbname, user, password


def clear():
    """ Cancella la console."""
    os.system("clear")
    
def connect():
    """ Connetti al database."""
    connessione = psycopg2.connect(host=dbhost, database=dbname, user=user, password=password)
    return connessione

def disconnect(connessione):
    """ Disconnetti dal database."""
    connessione.close()
    
def main():
    conn = connect()
    if(conn):
        print("Connessione aperta")
    else:
        print("Connessione non riuscita")
        
    query = input("Inserisci la query: ")
    
    with conn.cursor() as cursore:
        cursore.execute(query)
        risultati = cursore.fetchone()
        print(risultati)
        
        risposta = input("Vuoi continuare? (s/n): ")
        if(risposta == "s"):
            risultati = cursore.fetchall()
            for riga in risultati:
                print(riga)
            print("\n")
            
        else:
            print("Fine\n\n")
        
    disconnect(conn)
    if(conn):
        print("Connessione chiusa")
    else:
        print("Connessione non chiusa")
    
if __name__ == "__main__":
    main()