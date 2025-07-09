
# Laboratorio di Basi di Dati – Università degli Studi di Verona

**Autore:** Simone Mattioli  
**Corso di Laurea:** Informatica - Università degli Studi di Verona  
**Anno Accademico:** 2023/2024

---

## 👨‍🏫 Docenti del corso

- **Parte Teorica (Progettazione e Modellazione dei Dati):** Prof. Alberto Belussi  
- **Laboratorio e Tecnologie per le Basi di Dati:** Prof.ssa Sara Migliorini

---

## 📁 Descrizione del Repository

Questo repository raccoglie **materiale, appunti, esercitazioni ed esempi di codice** relativi al corso di _Basi di Dati_, comprendente sia la **parte teorica** sia il **laboratorio** e il **modulo di tecnologie**. È pensato come supporto allo studio, alla preparazione degli esami e all’interazione pratica con i database.

---

## 📦 Contenuto del Repository

### 📚 Materiale Didattico e Appunti

- `ESAME BASI DI DATI.pdf`  
  ➤ Appunti personali di **recap teorico**, con tutti i concetti chiave per l’esame.  
- `basi-lab dispensa.pdf`  
  ➤ Dispensa in **LaTeX** che riassume i contenuti del laboratorio per la preparazione pratica.

---

### 💻 Esercitazioni SQL (Laboratorio con PostgreSQL)

- `es_1.sql` → Query di base (SELECT, WHERE)
- `es_2.sql` → JOIN e interrogazioni multi-tabella
- `es_3.sql` → Aggregazioni e GROUP BY
- `es_4.sql` → Subquery e funzioni di aggregazione
- `es_5.sql` → Manipolazione dei dati (INSERT, UPDATE, DELETE)
- `es_6.sql` → Creazione e gestione di tabelle
- `es_7.sql` → Vincoli, chiavi primarie/esterne
- `es_9.sql` → Esercizi di riepilogo e livello avanzato

> ⚠️ Gli esercizi sono ordinati progressivamente e sono stati svolti durante il laboratorio.

---

### 🐍 Script Python

- `es_8.py`  
  ➤ Script Python per la **connessione a PostgreSQL** tramite `psycopg2`.  
  Richiede l’accesso al DB Server di Ateneo (es. tramite **pgAdmin4**).

> 💡 Da eseguire **solo se connessi alla VPN dell’Università di Verona**.

---

### 🔐 File di Configurazione (Privato)

- `mysecrets.py`  
  ➤ Contiene **credenziali di accesso** al database. Deve essere **escluso dal versionamento pubblico** (`.gitignore`).

- `__pycache__/mysecrets.cpython-311.pyc`  
  ➤ File compilato da Python: **non necessario** per l’utente.

---

### 🧪 Ambiente Virtuale Python (Facoltativo)

- `pi/` → Ambiente virtuale locale con:
  - Eseguibili (`python`, `pip`, ecc.)
  - Librerie installate (tra cui `psycopg2`)
  - File di attivazione per sistemi Windows, Linux, macOS

---

## 🛠 Requisiti Tecnici

- **PostgreSQL** (consigliato tramite [pgAdmin 4](https://www.pgadmin.org/))
- **Python 3.11+**
- Libreria Python `psycopg2`
- **VPN UNIVR attiva** per accedere al database universitario da remoto

---

## 🎓 Obiettivi del Corso

- Comprensione dei **modelli relazionali** e progettazione concettuale/logica/fisica
- Sviluppo di **query SQL complesse**
- Interazione programmatica con basi di dati (Python + SQL)
- Comprensione dei vincoli, normalizzazione, transazioni

---

## 🔗 Collegamenti Utili

- [Università di Verona](https://www.univr.it)
- [VPN UNIVR](https://www.univr.it/it/servizi/connessione-remota-vpn)
- [pgAdmin4 Download](https://www.pgadmin.org/download/)

---

## 📜 Licenza

Il contenuto di questo repository è fornito a **scopo didattico**.  
Gli appunti e il codice sono **personali**, consultabili liberamente ma **non distribuibili** senza autorizzazione dell’autore.

---

**Simone Mattioli – Università degli Studi di Verona**
