--
-- Esercizio 1
-- Visualizzare in nomi dei corsi di studio che finiscono con la stringa ’informatica’ senza considerare maiuscole/minuscole.


--
-- Esercizio 2
-- Visualizzare in nomi degli insegnamenti che iniziano per ’Teoria...’
-- Soluzione: da ~198 accessi si passa a 47. Gli indici creati sono: ....
--


--
-- Esercizio 3
-- Trovare, per ogni insegnamento erogato dell’a.a. 2013/2014, il suo nome e id della facoltà che lo 
-- gestisce usando la relazione assorbita con facoltà.
-- Soluzione: da ~6398 accessi si passa a ~3981 con la creazione di due indici di cui uno di tipo hash.
--


-- 
-- Esercizio 4
-- Visualizzare il codice, il nome e l'abbreviazione di tutti corsi di studio che nel nome contengono la sottostringa
-- 'lingue' (eseguire un test case-insensitive: usare ILIKE invece di LIKE).
-- Soluzione: da ~96 accessi si passa a...
-- 



--
-- Esercizio 5
-- Visualizzare identificatori e numero modulo dei moduli reali (modulo>0) degli insegnamenti erogati nel
-- 2010/2011 associati alla facoltà con id=7 tramite la relazione diretta.
-- Soluzione: da ~6310 accessi si passa a ~1460 creando 3 indici.
--



-- 
-- Esercizio 6
-- Visualizzare il nome e il discriminante (attributo descrizione della tabella Discriminante) degli insegnamenti
-- erogati nel 2009/2010 che non sono moduli e che hanno 3, 5 o 12 crediti.
-- Soluzione: da ~6743 accessi si passa a 1192 creando un indice btree e un indice hash.
--


--
-- Esercizio 7
-- Visualizzare il nome e il discriminante degli insegnamenti erogati nel 2008/2009 senza moduli e con crediti
-- maggiore di 9.
-- Soluzione: da ~6633 accessi si deve passare a meno di 760...
--


--
-- Esercizio 8
-- Visualizzare in ordine alfabetico di nome degli insegnamenti (esclusi di moduli e le unità logistiche) erogati
-- nel 2013/2014 nel corso di 'Laurea in Informatica', riportando il nome, il discriminante, i crediti e gli anni di
-- erogazione.
-- Soluzione: da ~6494 accessi si deve passare a meno di 66...
--



-- 
-- Esercizio 9
-- Trovare il massimo numero di crediti degli insegnamenti erogati dall’ateneo nell’a.a. 2013/2014.
-- Soluzione: meno di 6635 accessi.



-- 
-- Esercizio 10
-- Trovare, per ogni anno accademico, il massimo e il minimo numero di crediti erogati in un insegnamento.
-- Soluzione: meno di 6315 accessi.
--


--
-- Esercizio 11
-- Trovare il nome dei corsi di studio che non hanno mai erogato insegnamenti che contengono nel nome la stringa
-- 'matematica' (usare ILIKE invece di LIKE per rendere il test non sensibile alle maiuscole/minuscole).
-- Soluzione: meno di 942 accessi.
--


-- 
-- Esercizio 12
-- Trovare, per ogni anno accademico e per ogni corso di laurea, la somma dei crediti erogati (esclusi i moduli e le
-- unità logistiche: vedi nota sopra) e il massimo e minimo numero di crediti degli insegnamenti erogati sempre
-- escludendo i moduli e le unità logistiche.
-- Soluzione: da ~7408 accessi si passa a...
--
