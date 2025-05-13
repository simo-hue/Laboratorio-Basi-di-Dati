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

def esegui_query(connessione, query):
    with connessione.cursor() as cursore:
        cursore.execute(query)
        print("Esito della query: {:s}".format(cursore.statusmessage))
        if connessione.notices:
            print("Eventuali notifiche: {:s}".format(connessione.notices[-1]))

def main():
    
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

                cursore.execute("SELECT COUNT(*) FROM Spese")
                numero_righe = cursore.fetchone()[0]
                print("Numero di righe: {:d}".format(numero_righe))
                
                if numero_righe == 0:
                    aggiungi_default(connessione)   
                
                # Provo a fare una lettura
                leggi(connessione)
                
                numero_righe = cursore.fetchone()[0]
                print("Numero di righe: {:d}".format(numero_righe))
                
                if numero_righe == 0:
                    aggiungi_default(connessione)
                else:
                    print("La tabella è già presente con delle tuple e quindi nessuna tupla è stata aggiunta.")

                connessione.commit()
        leggi(connessione)

    except Exception as e:
        print("Errore:", e)
    finally:
        if 'connessione' in locals() and connessione:
            connessione.close()

if __name__ == "__main__":
    main()