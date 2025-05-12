--
-- Esercizio 1
--
-- Trovare identificatore, cognome e nome dei docenti che, nell’anno accademico 2010/2011, hanno tenuto un 
-- insegnamento (l’attributo da confrontare è nomeins) che non hanno tenuto nell’anno accademico precedente. 
-- Ordinare la soluzione per identificatore.
-- La soluzione ha 1031 righe. 
--



--
-- Esercizio 2
--
-- Trovare i corsi di studio che non sono gestiti dalla facoltà di "Medicina e Chirurgia" 
-- e che hanno insegnamenti erogati con moduli nel 2010/2011. Si visualizzi il 
-- nome del corso e il numero di insegnamenti erogati con moduli nel 2010/2011.
--
-- Soluzione: ci sono 33 righe.
--

--
-- Esercizio 3
--
-- Trovare gli insegnamenti del corso di studi con id=4 che non sono mai stati 
-- offerti al secondo quadrimestre.
-- Per selezionare il secondo quadrimestre usare la condizione 
-- "abbreviazione LIKE '2%'".
--
-- La soluzione ha 14 righe.
--

--
-- Esercizio 4
-- 
-- Trovare il nome dei corsi di studio che non hanno mai erogato insegnamenti 
-- che contengono nel nome la stringa 'matematica' (usare ILIKE invece di LIKE 
-- per rendere il test non sensibile alle maiuscole/minuscole (case-insensitive)).
--
-- La soluzione ha 572 righe.
--

-- 
-- Esercizio 5
-- Trovare nome, cognome e telefono dei docenti che hanno tenuto nel 
-- 2009/2010 un’occorrenza di insegnamento che non sia un'unità 
-- logistica del corso di studi con id=4 ma che non hanno mai tenuto 
-- un modulo dell'insegnamento di 'Programmazione' del medesimo corso di studi.
--
-- La soluzione ha 5 righe.
--



--
-- Esercizio 6
-- Trovare, per ogni facoltà, il numero di unità logistiche erogate 
-- (modulo < 0) e il numero corrispondente di crediti totali erogati 
-- nel 2010/2011, riportando il nome della facoltà e i conteggi richiesti. 
-- Usare pure la relazione diretta tra InsErogato e Facolta.
--
-- La soluzione ha 8 righe. La riga relativa a 'Medicina e Chirurgia' 
-- ha valori 253 e 979,50.
--


