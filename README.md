# 📚 Basi di Dati — Laurea Triennale in Informatica (UniVR)

[![GitHub repo](https://img.shields.io/badge/GitHub-simo--hue-blue?logo=github)](https://github.com/simo-hue)
[![License](https://img.shields.io/badge/license-MIT-green)](LICENSE)
[![Made with ❤️](https://img.shields.io/badge/Made%20with-❤️-ff69b4)](https://github.com/simo-hue)

Benvenuto in questa repository dedicata al corso **Basi di Dati** tenuto presso l'**Università degli Studi di Verona** per la **Laurea Triennale in Informatica**.

Contiene materiale didattico, esercitazioni, tracce d'esame e appunti utili per lo studio e il superamento del corso.

**Autore:** Simone Mattioli  
**Corso di Laurea:** Informatica - Università degli Studi di Verona  
**Anno Accademico:** 2023/2024

---

## 👨‍🏫 Docenti del corso

- **Parte Teorica (Progettazione e Modellazione dei Dati):** Prof. Alberto Belussi  
- **Laboratorio e Tecnologie per le Basi di Dati:** Prof.ssa Sara Migliorini
- **Link Panopto per le video lezioni: ** https://univr.cloud.panopto.eu/Panopto/Pages/Sessions/List.aspx#folderID=%2228dae6c0-99c9-4309-81ba-b09d00ec9117%22

---
## 📦 Contenuto del Repository

### 📚 Materiale Didattico e Appunti

- `ESAME BASI DI DATI.pdf`  
  ➤ Appunti personali di **recap teorico**, con tutti i concetti chiave per l’esame.  
- `basi-lab dispensa.pdf`  
  ➤ Dispensa in **LaTeX** di Davide Bianchi e Matteo Danzi Anno Accademico 2016/2017 che riassume i contenuti del laboratorio per la preparazione pratica.

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
## 🗂️ Struttura del Progetto

```
├── LAB/                    # Esercitazioni di laboratorio e materiale teorico
├── MIE ESERCIZI/           # Esercizi svolti personalmente
├── SLIDES TEORICHE/        # Lezioni su teoria, transazioni, concorrenza, strutture dati
├── TEMI D'ESAME ED ESERCIZI/
│   ├── ...                 # Prove intermedie, esercitazioni, esami passati con soluzioni
├── README.md               # Questo file
```

---

## 📌 Contenuti Principali

- ✅ Esercitazioni SQL con soluzioni (`.sql` + `.pdf`)
- ✅ Slide ufficiali del corso
- ✅ Prove intermedie ed esami passati con testi e soluzioni
- ✅ Appunti e suggerimenti utili per superare l’esame teorico

---

## 🧠 Come usare questa repo

1. Clona il progetto:
   ```bash
   git clone https://github.com/simo-hue/basi-di-dati-informatica-univr.git
   ```
2. Apri i file `.sql` con un IDE come DBeaver, DataGrip o PgAdmin.
3. Consulta le slide e PDF per teoria e appelli passati.

---

## 📬 Feedback o Contributi

Hai suggerimenti o vuoi contribuire? Apri una **Issue** o invia una **Pull Request**!

---

## 👨‍💻 Autore

**[Simone Mattioli](https://github.com/simo-hue)**  
Studente di Informatica — Università di Verona

---

## 📄 Licenza

Questo progetto è distribuito con licenza [MIT](LICENSE).