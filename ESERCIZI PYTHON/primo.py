from time import sleep
import psycopg2
from datetime import date
from decimal import Decimal
from mysecrets import DB_HOST, DB_NAME, DB_USER, DB_PASSWORD

# nuove entry nella tabella di default
def aggiungi_default(connessione):
    with connessione.cursor() as cursore:
        cursore.execute("""
                            INSERT INTO Spese(data, voce, importo) VALUES
                            (%s, %s, %s),
                            (%s, %s, %s),
                            (%s, %s, %s),
                            (%s, %s, %s)
                        """, (
                            date(2016, 2, 24), "Stipendio", Decimal("0.1"),
                            date(2016, 2, 24), "Stipendio 'Bis'", Decimal("0.1"),
                            date(2016, 2, 24), "Stipendio 'Tris'", Decimal("0.1"),
                            date(2016, 2, 27), "Affitto", Decimal("-0.3")
                        ))
    
    print("Esito dell'inserimento delle 4 tuple: {:s}".format(cursore.statusmessage))
    
    if connessione.notices:
        print("Eventuali notifiche: {:s}".format(connessione.notices[-1]))

def leggi(connessione):
    with connessione.cursor() as lettore:
            lettore.execute("SELECT id, data, voce, importo FROM Spese")
            print("Esito della selezione di tutte le tuple: {:s}".format(lettore.statusmessage))
            print('=' * 55)
            pattern_riga = "| {:>2s} | {:10s} | {:<20s} | {:>10s} |"
            print(pattern_riga.format("N", "Data", "Voce", "Importo"))
            print('-' * 55)
            tot = Decimal("0")
            pattern_riga = "| {:>2d} | {:10s} | {:<20s} | {:>10.2f} |"
            for tupla in lettore:
                print(pattern_riga.format(tupla[0], tupla[1].isoformat(), tupla[2], tupla[3]))
                tot += tupla[3]
            print('-' * 55)
            print("{:>40s} {:10.2f}".format("Totale", tot))

def aggiungi(connessione):
    with connessione.cursor() as cursore:
        data = input("Inserisci la data (AAAA-MM-GG): ")
        voce = input("Inserisci la voce: ")
        importo = input("Inserisci l'importo: ")
        cursore.execute("INSERT INTO Spese(data, voce, importo) VALUES (%s, %s, %s)", (data, voce, importo))
        print("Esito dell'inserimento della tupla: {:s}".format(cursore.statusmessage))
        
        if connessione.notices:
            print("Eventuali notifiche: {:s}".format(connessione.notices[-1]))
        connessione.commit()
        
        leggi(connessione)
        
def esegui_query(connessione, query):
    with connessione.cursor() as cursore:
        cursore.execute(query)
        print("Esito della query: {:s}".format(cursore.statusmessage))
        if connessione.notices:
            print("Eventuali notifiche: {:s}".format(connessione.notices[-1]))
            
        for tupla in cursore:
            print(tupla)

        sleep(3)

def rimuovi_entry(connessione):
    
    with connessione.cursor() as cursore:
        id = int(input("Inserisci l'id dell'entry da eliminare: "))
        cursore.execute("DELETE FROM Spese WHERE id=%s", (id,))
        print("Esito dell'eliminazione dell'entry: {:s}".format(cursore.statusmessage))
        
        if connessione.notices:
            print("Eventuali notifiche: {:s}".format(connessione.notices[-1]))
        
        connessione.commit()

def main():
    connessione = None
    try:
        connessione = psycopg2.connect(
        host=DB_HOST,
        database=DB_NAME,
        user=DB_USER,
        password=DB_PASSWORD
        )
        print("Connessione aperta")

        with connessione:
            with connessione.cursor() as cursore:
                # creazione della tabella se NON esiste
                cursore.execute("""
                    CREATE TABLE IF NOT EXISTS Spese (
                        id SERIAL PRIMARY KEY,
                        data DATE NOT NULL,
                        voce VARCHAR NOT NULL,
                        importo NUMERIC NOT NULL
                    )
                """)
                print('Esito della creazione della tabella Spese: {:s}'.format(cursore.statusmessage))
                if connessione.notices:
                    print('Eventuali notifiche: {:s}'.format(connessione.notices[-1]))
                connessione.commit()

        while True:
            print("Menu:")
            print("situazione attuale:\n")
            leggi(connessione)
            print("\n")
            
            print("0. Aggiungi default")
            print("1. Aggiungi personalizzata")
            print("2. Leggi tutte le tuple")
            print("3. Esegui una query specifica")
            print("4. Eliminare una entry")
            print("5. Esci")
            
            scelta = input("Scegli un'opzione: ")
            if scelta == "0":
                aggiungi_default(connessione)
            if scelta == "1":
                aggiungi(connessione)
            elif scelta == "2":
                leggi(connessione)
            elif scelta == "3":
                query = input("Inserisci la query: ")
                esegui_query(connessione, query)
            elif scelta == "4":
                rimuovi_entry(connessione)
            elif scelta == "5":
                connessione.close()
                print("Connessione chiusa")
                break
            else:
                print("Scelta non valida. Riprova.")

    except Exception as e:
        print("Errore:", e)
    finally:
        if 'connessione' in locals() and connessione:
            connessione.close()

if __name__ == "__main__":
    main()