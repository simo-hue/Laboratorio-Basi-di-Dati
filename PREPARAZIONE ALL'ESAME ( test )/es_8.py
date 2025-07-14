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
    
def insert(connessione):
    """ Inserisci un record nel database."""
    nome = input("Inserisci il Nome: ")
    città = input("Inserisci il città: ")
    indirizzo = input("Inserisci l'indirizzo: ")
    numerotelefono = input("Inserisci il numero di telefono: ")
    giornochiusura = input("Inserisci il giorno di chiusura: ")
    prezzo = int(input("Inserisci Prezzo: "))
    sitointernet = input("Inserisci il sito internet: ")

    with connessione.cursor() as cursore:
        cursore.execute("INSERT INTO Museo (Nome, Città, Indirizzo, NumeroTelefono, GiornoChiusura, Prezzo, SitoInternet) VALUES (%s, %s, %s, %s, %s, %s, %s)", (nome, città, indirizzo, numerotelefono, giornochiusura, prezzo, sitointernet))
        
        connessione.commit()
        
        print("Record inserito correttamente")

def stampaTutto(connessione):
    """ Stampa tutti i record del database."""
    with connessione.cursor() as cursore:
        cursore.execute("SELECT * FROM Museo")
        risultati = cursore.fetchall()
        
        if(risultati):
            for risultato in risultati:
                print(risultato)
        else:
            print("Non ci sono record nel database")

def remove(connessione):
    """ Inserisci un record nel database."""
    nome = input("Inserisci il Nome: ")
    città = input("Inserisci il città: ")
    indirizzo = input("Inserisci l'indirizzo: ")
    numerotelefono = input("Inserisci il numero di telefono: ")
    giornochiusura = input("Inserisci il giorno di chiusura: ")
    prezzo = int(input("Inserisci Prezzo: "))
    sitointernet = input("Inserisci il sito internet: ")
    
    with connessione.cursor() as cursore:
        cursore.execute("DELETE FROM Museo WHERE Nome = %s AND Città = %s AND Indirizzo = %s AND NumeroTelefono = %s AND GiornoChiusura = %s AND Prezzo = %s AND SitoInternet = %s", (nome, città, indirizzo, numerotelefono, giornochiusura, prezzo, sitointernet))
        
        connessione.commit()
        
        print("Record eliminato correttamente")

def main():
    conn = connect()
    if(conn):
        print("Connessione aperta")
    else:
        print("Connessione non riuscita")
        
    #query = input("Inserisci la query: ")
    
    with conn.cursor() as cursore:
        #cursore.execute(query)
        #risultati = cursore.fetchone()
        #print(risultati)
        
        #risposta = input("Vuoi continuare? (s/n): ")
        #if(risposta == "s"):
            #risultati = cursore.fetchall()
            #for riga in risultati:
            #    print(riga)
            #print("\n")
            
        #else:
            #print("Fine\n\n")
            
        #conn.commit()
        
        #print("Esito della query: {:s}".format(cursore.statusmessage))
        #if conn.notices:
            #print("Eventuali notifiche: {:s}".format(conn.notices[-1]))
        stampaTutto(conn)  
          
        x = input("")
        
        insert(conn)
        
        stampaTutto(conn)  
        
        x = input("")
        
        remove(conn)
        
        stampaTutto(conn)  
        
        x = input("")
        
        clear()
    
    # Qui viene fatto il COMMIT in automatico ( Ma connessione ANCORA APERTA )  
        
    disconnect(conn)
    if(conn):
        print("Connessione chiusa")
    else:
        print("Connessione non chiusa")
    
if __name__ == "__main__":
    main()