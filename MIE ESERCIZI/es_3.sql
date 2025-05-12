/*Esercizio 1
Visualizzare il numero di corso studi presenti nella base di dati.
Soluzione: ci sono 635 corsi di studio.
*/
SELECT DISTINCT(nome)
FROM corsostudi;

/*Esercizio 2
Visualizzare il nome, il codice, l’indirizzo e l’identificatore del preside di tutte le facoltà.
Soluzione: ci sono 8 facoltà.
*/
SELECT nome, id, indirizzo, id_preside_persona
FROM Facolta

/*Esercizio 3
Trovare per ogni corso di studi che ha erogato insegnamenti nel 2010/2011 il suo nome e il nome delle
facoltà che lo gestiscono (si noti che un corso può essere gestito da più facoltà). Non usare la relazione
diretta tra InsErogato e Facoltà. Porre i risultati in ordine di nome corso studi.
*/
-- MIA SBAGLIATA:
SELECT DISTINCT(corsostudi.nome)  as nome_corso_studi, facolta.nome as nome_facolta
FROM corsostudi JOIN insErogato ON id_corsostudi = corsostudi.id
				JOIN facolta ON id_facolta = facolta.id
WHERE insErogato.annoaccademico = '2010/2011'
ORDER BY corsostudi.nome;

SELECT DISTINCT CS.nome, F.nome
FROM CorsoStudi AS CS 
JOIN InsErogato AS IE ON (CS.id = IE.id_corsostudi)
JOIN CorsoInFacolta AS CIF ON (CIF.id_corsostudi = CS.id)
JOIN Facolta AS F ON (CIF.id_facolta = F.id)
WHERE IE.annoaccademico = '2010/2011'
ORDER BY CS.nome;

/*
Esercizio 4
Visualizzare il nome, il codice e l’abbreviazione di tutti i corsi di studio gestiti dalla facoltà di Medicina e
Chirurgia.
Soluzione: ci sono 236 righe.
*/
select corsostudi.nome, corsostudi.codice, corsostudi.abbreviazione, facolta.nome
from corsostudi join corsoinfacolta on id_corsostudi = corsostudi.id
				join facolta on corsoinfacolta.id_facolta = facolta.id
where facolta.nome LIKE 'Medi%';


/*
Esercizio 5
Visualizzare il codice, il nome e l’abbreviazione di tutti corsi di studio che nel nome contengono la
sottostringa ’lingue’ (eseguire il confronto usando ILIKE invece di LIKE: in questo modo i caratteri maiuscolo
e minuscolo non sono diversi).
Soluzione: ci sono 16 righe.
*/
select corsostudi.nome, corsostudi.abbreviazione
from corsostudi 
where nome ILIKE '%lingue%';

/*
Esercizio 6
Visualizzare le sedi dei corsi di studi in un elenco senza duplicati.
Soluzione: ci sono 48 righe.
*/
select distinct sede
from corsostudi

/*
Esercizio 7
Visualizzare solo i moduli degli insegnamenti erogati nel 2010/2011 nei corsi di studi della facoltà di
Economia.
*/
-- mia sbagliata
select insegn.nomeins, inserogato.nomemodulo, inserogato.modulo
from corsostudi JOIN inserogato ON id_corsostudi = corsostudi.id
				JOIN insegn ON id_insegn = insegn.id
				JOIN Facolta ON id_facolta = Facolta.id
where modulo > 0 AND inserogato.annoaccademico = '2010/2011' AND facolta.nome = 'Economia'


SELECT I.nomeins, D.descrizione, IE.nomemodulo, IE.modulo
FROM InsErogato AS IE
JOIN Insegn as I ON (IE.id_insegn = I.id)
JOIN CorsoInFacolta AS CIF ON (CIF.id_corsostudi = IE.id_corsostudi)
JOIN Facolta AS F ON (F.id = CIF.id_facolta)
JOIN Discriminante AS D ON (IE.id_discriminante = D.id)
WHERE IE.annoaccademico = '2010/2011' AND
F.nome = 'Economia' AND 
IE.modulo > 0;


/*
Esercizio 8
Visualizzare il nome e il discriminante (attributo descrizione della tabella Discriminante) degli insegnamenti
erogati nel 2009/2010 che non sono moduli o unità logistiche e che hanno 3, 5 o 12 crediti. Si ordini il
risultato per discriminante.
Soluzione: ci sono 724 righe distinte. Le ultime 5 righe sono:
nomeins | discriminante
-- ----------------------------------+---------------
Prova finale | CInt
Laboratorio di composizione italiana | Cognomi A-K
Biologia | Cognomi A-L
Laboratorio di composizione italiana | Cognomi L-Z
Biologia
*/

-- mia sbagliata
select DISTINCT inserogato.nomeins, discriminante.descrizione 
from inserogato JOIN discriminante ON discriminante.id = inserogato.id_discriminante
where inserogato.annoaccademico = '2009/2010' AND modulo = '0' AND crediti IN (3, 5, 12) 
ORDER BY discriminante.descrizione;

SELECT DISTINCT I.nomeins, D.descrizione --, IE.nomemodulo, IE.modulo
FROM InsErogato AS IE
JOIN Insegn as I ON (IE.id_insegn = I.id)
JOIN Discriminante AS D ON (IE.id_discriminante = D.id)
WHERE IE.annoaccademico = '2009/2010' AND
IE.crediti IN (3,5,12) AND 
IE.modulo = 0
ORDER BY D.descrizione;

/*
Esercizio 9
Visualizzare l’identificatore, il nome e il discriminante degli insegnamenti erogati nel 2008/2009 che non
sono moduli o unità logistiche e con peso maggiore di 9 crediti. Ordinare per nome.
Soluzione : ci sono 1218 righe. Le 5 righe dalla MXXIII riga sono:
id | nomeins | discriminante
-- ---+----------------------------------------+-------------------
39872 | Storia del diritto medievale e moderno | Matricole pari
44440 | Storia del diritto medievale e moderno | Matricole dispari
39724 | Storia del diritto medievale e moderno | Matricole pari
44428 | Storia del diritto medievale e moderno | Matricole dispari
44441 | Storia del diritto medievale e moderno | Matricole dispari
*/
SELECT insegn.id, insegn.nomeins, discriminante.descrizione
FROM inserogato JOIN insegn ON insegn.id = inserogato.id_insegn
				JOIN discriminante ON discriminante.id = inserogato.id_discriminante
WHERE annoaccademico = '2008/2009' AND
		modulo = 0 AND
		crediti > 9
ORDER BY insegn.nomeins
		

/*
Esercizio 10
Visualizzare in ordine alfabetico di nome degli insegnamenti (esclusi i moduli e le unità logistiche) erogati nel
2010/2011 nel corso di studi in Informatica, riportando il nome, il discriminante, i crediti e gli anni di
erogazione.
Soluzione: ci sono 26 righe.
*/
SELECT insegn.nomeins, discriminante.descrizione, crediti::int, annierogazione
FROM insegn JOIN inserogato ON insegn.id = inserogato.id_insegn
				JOIN discriminante ON discriminante.id = inserogato.id_discriminante
				JOIN corsostudi ON corsostudi.id = inserogato.id_corsostudi
WHERE annoaccademico = '2010/2011' AND
		modulo = 0 AND corsostudi.nome = 'Laurea in Informatica'
ORDER BY insegn.nomeins

/*
Esercizio 11
Trovare il massimo numero di crediti associato a un insegnamento fra quelli erogati nel 2010/2011.
Soluzione: 180
*/
SELECT MAX(crediti::int) as massimo_crediti
FROM insegn JOIN inserogato ON insegn.id = inserogato.id_insegn
				JOIN corsostudi ON corsostudi.id = inserogato.id_corsostudi
WHERE annoaccademico = '2010/2011' 


-- 12
SELECT annoaccademico, MAX(crediti), MIN(crediti)
FROM InsErogato
GROUP BY annoaccademico
ORDER BY annoaccademico;


--14
--Trovare per ogni corso di studi della facoltà di Scienze Matematiche Fisiche e Naturali il numero di
--insegnamenti (esclusi i moduli e le unità logistiche) erogati nel 2009/2010.
-- mia sbagliata
SELECT corsostudi.nome, COUNT(insegn.nomeins)
FROM facolta JOIN inserogato ON inserogato.id_facolta = facolta.id
				JOIN insegn ON insegn.id = inserogato.id_insegn
				JOIN corsostudi ON corsostudi.id = inserogato.id_corsostudi
WHERE facolta.nome ILIKE '%Scienze Matematiche Fisiche%' AND annoaccademico = '2009/2010' AND modulo = 0
GROUP BY corsostudi.nome

SELECT CS.nome, COUNT(*)
FROM InsErogato AS IE 
  JOIN CorsoStudi AS CS ON (IE.id_corsostudi = CS.id )
  JOIN CorsoInFacolta AS CIF ON (CIF.id_corsostudi = CS.id )
  JOIN Facolta AS F ON (CIF.id_facolta = F.id)
WHERE LOWER(F.nome) = 'scienze matematiche fisiche e naturali' AND
IE.modulo = 0 AND IE.annoaccademico = '2009/2010'
GROUP BY CS.nome;


-- Esercizio 15
-- Trovare i corsi di studi che nel 2010/2011 hanno erogato insegnamenti con un numero di crediti pari a 4 o 6 o
-- 8 o 10 o 12 o un numero di crediti di laboratorio tra 10 e 15 escluso, riportando il nome del corso di studi e la
-- sua durata. Si ricorda che i crediti di laboratorio sono rappresentati dall’attributo creditilab della tabella
-- InsErogato.
-- Soluzione: ci sono 197 righe. 
SELECT DISTINCT corsostudi.nome
FROM inserogato JOIN corsostudi on corsostudi.id = inserogato.id_corsostudi
WHERE ( inserogato.crediti IN (4,6,8,10,12) OR ( inserogato.creditilab >= 10 AND inserogato.creditilab <= 15 ) )
		AND inserogato.annoaccademico = '2010/2011'
