/*
--
-- Esercizio 1
-- Trovare nome, cognome dei docenti che nell’anno accademico 2010/2011 erano docenti 
-- in almeno due corsi di studio (vale a dire erano docenti in almeno due insegnamenti 
-- o moduli A e B dove A è del corso C1 e B è del corso C2 con C1 <> C2).
--
*/
-- Mia sbagliata
SELECT nome, cognome
FROM corsostudi as C1 JOIN corsostudi as C2
						JOIN inserogato on C1.id = inserogato.id_corsostudi
						JOIN inserogato on C2.id = inserogato.id_corsostudi
WHERE C1 <> C2 AND C1.annoaccademico = '2010/2011'
				AND C1.annoaccademico = '2010/2011'
				

SELECT DISTINCT P.id, P.nome, P.cognome
FROM InsErogato AS IE1 
  JOIN Docenza AS D1 ON( D1.id_inserogato = IE1.id )
  JOIN Persona AS P ON( D1.id_persona = P.id )  
  JOIN Docenza AS D2 ON ( D2.id_persona = P.id )
  JOIN InsErogato AS IE2 ON ( D2.id_inserogato = IE2.id )
WHERE IE1.annoaccademico = '2010/2011' 
  AND IE2.annoaccademico = '2010/2011' 
  AND IE1.id_corsostudi <> IE2.id_corsostudi
ORDER BY P.id;

/*
--
-- Esercizio 2
--
-- Trovare per ogni periodo di lezione del 2010/2011 la cui descrizione inizia con  'I semestre' o 'Primo semestre' 
-- il numero di occorrenze di insegnamento allocate in quel periodo. Si visualizzi quindi: l’abbreviazione, il discriminante, 
-- inizio, fine e il conteggio richiesto ordinati rispetto all’inizio e fine.
-- 
-- La soluzione ha 3 righe
--
*/

-- Mia sbagliata
SELECT periodolez.abbreviazione, periododid.discriminante, inizio, fine, count(inserogato.id)
FROM inserogato, periododid JOIN periodolez ON periodolez.id = periododid.id
WHERE periododid.annoaccademico = '2010/2011' AND
		(periododid.descrizione ILIKE 'I semestre%' OR periododid.descrizione ILIKE 'Primo semestre%') AND
		inserogato.annoaccademico = '2010/2011'
GROUP BY periodolez.abbreviazione, periododid.discriminante, periododid.inizio, periododid.fine
ORDER BY periododid.inizio, periododid.fine;


SELECT PL.abbreviazione, PD.discriminante, PD.inizio, PD.fine, COUNT(IP.id_inserogato) as numins
FROM PeriodoLez AS PL
  JOIN PeriodoDid AS PD ON (PL.id = PD.id)  
  JOIN InsInPeriodo AS IP ON (PD.id = IP.id_periodolez)
WHERE PD.descrizione IN ('I semestre','Primo semestre') 
  AND PD.annoaccademico = '2010/2011'
GROUP BY PL.abbreviazione, PD.discriminante, PD.inizio, PD.fine 
ORDER BY PD.inizio, PD.fine;

--
-- Esercizio 3
--
-- Trovare per ogni segreteria che serve almeno un corso di studi il numero di 
-- corsi di studi serviti, riportando il nome della struttura, il suo numero di 
-- fax e il conteggio richiesto.
--
-- La soluzione ha 42 righe.

SELECT strutturaservizio.nomestruttura, strutturaservizio.fax,  COUNT(strutturaservizio.id) as corsi_serviti
FROM strutturaservizio JOIN corsostudi ON id_segreteria = strutturaservizio.id
GROUP BY strutturaservizio.nomestruttura, strutturaservizio.fax