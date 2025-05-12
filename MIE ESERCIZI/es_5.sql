--
-- Esercizio 1
--
-- Trovare identificatore, cognome e nome dei docenti che, nell’anno accademico 2010/2011, hanno tenuto un 
-- insegnamento (l’attributo da confrontare è nomeins) che non hanno tenuto nell’anno accademico precedente. 
-- Ordinare la soluzione per identificatore.
-- La soluzione ha 1031 righe. 
--
select DISTINCT persona.id, persona.nome, persona.cognome
from inserogato join docenza on docenza.id_inserogato = inserogato.id
				join persona on docenza.id_persona = persona.id
				join insegn on insegn.id = inserogato.id_insegn
where inserogato.annoaccademico = '2010/2011' AND
		(persona.id, insegn.nomeins) NOT IN ( select persona.id, insegn.nomeins
					 from inserogato join docenza on docenza.id_inserogato = inserogato.id
					 join insegn on insegn.id = inserogato.id_insegn
				join persona on docenza.id_persona = persona.id
				where inserogato.annoaccademico = '2009/2010')

--
-- Esercizio 2
--
-- Trovare i corsi di studio che non sono gestiti dalla facoltà di "Medicina e Chirurgia" 
-- e che hanno insegnamenti erogati con moduli nel 2010/2011. Si visualizzi il 
-- nome del corso e il numero di insegnamenti erogati con moduli nel 2010/2011.
--
-- Soluzione: ci sono 33 righe.
--

-- mia sbagliata
select corsostudi.nome, count(inserogato.id)
from corsoinfacolta join corsostudi on corsoinfacolta.id_corsostudi = corsostudi.id
					join facolta on facolta.id = corsoinfacolta.id_facolta
					join inserogato on corsostudi.id = inserogato.id_corsostudi
where facolta.nome <> 'Medicina e Chirurgia' AND inserogato.annoaccademico = '2010/2011' AND modulo > 0
group by corsostudi.nome


SELECT CS.nome, COUNT(IE.id) as num_ins
FROM CorsoStudi AS CS
  JOIN InsErogato AS IE ON (IE.id_corsostudi = CS.id)
WHERE CS.id NOT IN 
  ( SELECT CS1.id 
    FROM CorsoStudi AS CS1 
      JOIN CorsoInFacolta AS CIF ON (CS1.id = CIF.id_corsostudi)
      JOIN Facolta AS F ON (F.id = CIF.id_facolta)
    WHERE F.nome = 'Medicina e Chirurgia'
  )
  AND IE.annoaccademico = '2010/2011'
  AND IE.hamoduli <> '0'
GROUP BY CS.nome
ORDER BY CS.nome;
--
-- Esercizio 3
--
-- Trovare gli insegnamenti del corso di studi con id=4 che non sono mai stati 
-- offerti al secondo quadrimestre.
-- Per selezionare il secondo quadrimestre usare la condizione 
-- "abbreviazione LIKE '2%'".
--
-- La soluzione ha 14 righe.

SELECT DISTINCT nomeins
FROM Insegn AS I1
  JOIN InsErogato AS IE1 ON (IE1.id_insegn = I1.id)
  JOIN CorsoStudi AS CS1 ON (IE1.id_corsostudi = CS1.id)
WHERE CS1.id = 4 AND I1.id NOT IN
( SELECT I2.id
  FROM Insegn AS I2
    JOIN InsErogato AS IE2 ON (IE2.id_insegn = I2.id)
    JOIN CorsoStudi AS CS2 ON (IE2.id_corsostudi = CS2.id)
    JOIN InsInPeriodo AS IIP2 ON (IIP2.id_inserogato = IE2.id)
    JOIN PeriodoLez AS PL2 ON (IIP2.id_periodolez = PL2.id)
  WHERE CS2.id = 4 AND
    PL2.abbreviazione LIKE '2%'
);


--
-- Esercizio 4
-- 
-- Trovare il nome dei corsi di studio che non hanno mai erogato insegnamenti 
-- che contengono nel nome la stringa 'matematica' (usare ILIKE invece di LIKE 
-- per rendere il test non sensibile alle maiuscole/minuscole (case-insensitive)).
--
-- La soluzione ha 572 righe.
--
SELECT CS1.nome
FROM CorsoStudi as CS1 
WHERE CS1.id NOT IN
  ( SELECT CS2.id
    FROM Insegn AS I2
      JOIN InsErogato AS IE2 ON (IE2.id_insegn = I2.id)
      JOIN CorsoStudi as CS2 ON (IE2.id_corsostudi = CS2.id)
    WHERE I2.nomeins ILIKE '%matematica%')
-- 
-- Esercizio 5
-- Trovare nome, cognome e telefono dei docenti che hanno tenuto nel 
-- 2009/2010 un’occorrenza di insegnamento che non sia un'unità 
-- logistica del corso di studi con id=4 ma che non hanno mai tenuto 
-- un modulo dell'insegnamento di 'Programmazione' del medesimo corso di studi.
--
-- La soluzione ha 5 righe.
--
SELECT P.id, P.nome, P.cognome, P.telefono
FROM Docenza D
  JOIN InsErogato IE ON D. id_inserogato = IE.id
  JOIN Persona P ON D. id_persona = P.id
WHERE IE.id_corsostudi = 4 AND IE.annoaccademico = '2009/2010'
  AND IE. modulo >= 0
EXCEPT
SELECT P.id , P.nome, P.cognome, P.telefono
FROM Docenza D
  JOIN InsErogato IE ON D. id_inserogato = IE.id
  JOIN Persona P ON D. id_persona = P.id
  JOIN Insegn I ON IE. id_insegn = I.id
WHERE I. nomeins = 'Programmazione' AND IE.modulo > 0

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
SELECT F.nome , COUNT (nomeunita) AS numUnita, SUM(crediti) AS sommaCrediti
FROM InsErogato IE JOIN Facolta F ON IE. id_facolta = F.id
WHERE IE. annoaccademico = '2010/2011' AND IE. modulo < 0
GROUP BY F.nome;

