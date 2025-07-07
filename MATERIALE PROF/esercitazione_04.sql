--
-- Esercizio 1
-- Trovare nome, cognome dei docenti che nell’anno accademico 2010/2011 erano docenti 
-- in almeno due corsi di studio (vale a dire erano docenti in almeno due insegnamenti 
-- o moduli A e B dove A è del corso C1 e B è del corso C2 con C1 <> C2).
--
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

-- Soluzione alternativa
SELECT P.id, P.nome, P.cognome
FROM InsErogato AS IE 
  JOIN Docenza AS D ON( D.id_inserogato = IE.id )
  JOIN Persona AS P ON( D.id_persona = P.id )    
WHERE IE.annoaccademico = '2010/2011' 
GROUP BY P.id, P.nome, P.cognome
HAVING COUNT(DISTINCT IE.id_corsostudi) > 1
ORDER BY P.id;

--
-- Esercizio 2
--
-- Trovare per ogni periodo di lezione del 2010/2011 la cui descrizione inizia con  'I semestre' o 'Primo semestre' 
-- il numero di occorrenze di insegnamento allocate in quel periodo. Si visualizzi quindi: l’abbreviazione, il discriminante, 
-- inizio, fine e il conteggio richiesto ordinati rispetto all’inizio e fine.
-- 
-- La soluzione ha 3 righe
--
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
--
SELECT S.nomestruttura, S.fax, COUNT(CS.id) AS numcorsi
FROM StrutturaServizio AS S
  JOIN CorsoStudi AS CS ON (CS.id_segreteria = S.id)
GROUP BY S.nomestruttura, S.fax;