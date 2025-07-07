--
-- Esercizio 1
-- Trovare, per ogni facoltà, il docente che ha tenuto il numero massimo
-- di ore di lezione nel 2009/2010, riportando il cognome e il nome del
-- docente e la facoltà. Per la relazione tra InsErogato e Facolta
-- usare la relazione diretta.
--
-- La soluzione ha 10 righe.
--
CREATE TEMP VIEW OreDocente( docente, oreTot, facolta ) AS (
  SELECT D.id_persona, SUM( D.orelez ), F.nome
  FROM Docenza D
    JOIN InsErogato IE ON D.id_inserogato = IE.id
    JOIN Facolta F ON IE.id_facolta = F.id
  WHERE IE.annoaccademico = '2009/2010'
  GROUP BY D.id_persona, F.nome
);

SELECT DISTINCT P.id , P.cognome, P.nome, OD.facolta, OD.oreTot
FROM Persona P JOIN OreDocente OD ON P.id = OD.docente
WHERE ROW( OD.oreTot, OD.facolta ) IN (
  SELECT MAX (oreTot) AS maxOre, facolta
  FROM OreDocente
  GROUP BY facolta
)
ORDER BY cognome;

--
-- Alternativa
--
SELECT P.id, P.cognome, P.nome, OD.facolta , OD.oreTot
FROM Persona P JOIN OreDocente OD ON P.id = OD.docente JOIN (
  SELECT MAX ( oreTot ) AS maxOre, facolta
  FROM OreDocente
  GROUP BY facolta
) AS M ON M.facolta = OD.facolta AND OD.oreTot = M.maxOre
ORDER BY cognome;

--
-- Esercizio 2
-- Trovare gli insegnamenti (esclusi i moduli e le unità logistiche)
-- del corso di studi con id=240 erogati nel 2009/2010 e nel 2010/2011
-- che hanno avuto almeno un docente ma che non hanno avuto docenti di
-- nome 'Roberto', 'Alberto', 'Massimo' o 'Luca' in entrambi gli anni
-- accademici, riportando il nome, il discriminante dell'insegnamento,
-- ordinati per nome insegnamento.
--
-- La soluzione ha 22 righe.
-- "Non hanno avuto" = "non hanno avuto in quei due anni accademici".
--
SELECT I.nomeins , D.nome AS discriminante
FROM Insegn I
  JOIN InsErogato IE ON I.id = IE.id_insegn
  JOIN Discriminante D ON D.id = IE.id_discriminante
  JOIN Docenza DOC ON IE.id = DOC.id_inserogato
  JOIN Persona P ON DOC.id_persona = P.id
WHERE IE.id_corsostudi = 240
  AND IE.annoaccademico = '2009/2010 '
  AND IE.modulo = 0
  AND P.nome NOT IN('Roberto', 'Alberto', 'Massimo', 'Luca')
INTERSECT
SELECT I.nomeins , d.nome AS discriminante
FROM Insegn I
  JOIN InsErogato IE ON I.id = IE.id_insegn
  JOIN Discriminante D ON D.id = IE.id_discriminante
  JOIN Docenza DOC ON IE.id = DOC.id_inserogato
  JOIN Persona P ON DOC.id_persona = P.id
WHERE IE.id_corsostudi = 240
AND IE.annoaccademico = '2010/2011 '
AND IE.modulo = 0
AND P.nome NOT IN('Roberto', 'Alberto', 'Massimo', 'Luca')
ORDER BY nomeins;

--
-- Esercizio 3
-- Trovare le unità logistiche del corso di studi con id=420
-- erogati nel 2010/2011 e che hanno lezione o il
-- lunedì (Lezione.giorno=2) o il martedì (Lezione.giorno=3), ma non in
-- entrambi i giorni, riportando il nome dell'insegnamento e il nome
-- dell'unità ordinate per nome insegnamento.
--
-- La soluzione ha 8 righe.
--
-- L'unita logistica Sistemi operativi-Laboratorio ha una omonima
-- unità con lezioni in entrambi i giorni.
-- Quindi la soluzione corretta è la seguente.
SELECT DISTINCT I.nomeins, IE.nomeunita
FROM Insegn I JOIN InsErogato IE ON I.id = IE.id_insegn
WHERE IE.id IN (
  SELECT IE.id
  FROM InsErogato IE JOIN Lezione L ON IE.id = L.id_inserogato
  WHERE IE.id_corsostudi = 420
    AND IE.annoaccademico = '2010/2011'
    AND IE.modulo < 0
    AND (L.giorno = 2 OR L.giorno = 3)
  EXCEPT
  SELECT ie.id
  FROM InsErogato IE JOIN Lezione L1 ON IE.id = L1.id_inserogato
    JOIN Lezione L2 ON IE.id = L2.id_inserogato
  WHERE IE.id_corsostudi = 420
    AND IE.annoaccademico = '2010/2011 '
    AND IE.modulo < 0
    AND (L1.giorno = 2 AND L2.giorno = 3)
)
ORDER BY nomeins;

--
-- Esercizio 4
-- Trovare gli insegnamenti in ordine alfabetico (esclusi moduli e
-- unità logistiche) dei corsi di studi della facoltà di
-- 'Scienze Matematiche Fisiche e Naturali' che sono stati tenuti
-- dallo stesso docente per due anni accademici consecutivi riportando
-- id, nome dell'insegnamento e id, nome, cognome del docente.
-- Per la relazione tra InsErogato e Facolta non usare la relazione diretta.
-- Circa la condizione sull'anno accademico, dopo aver estratto una sua
-- opportuna parte, si può trasformare questa in un intero e, quindi,
-- usarlo per gli opportuni controlli. Oppure si può usarla direttamente
-- confrontandola con un’opportuna parte dell’altro anno accademico.
--
-- La soluzione ha 544 righe
--
CREATE TEMP VIEW InsDocAnnoAtScienze( id_insegn , id_docente, aa ) AS
  SELECT DISTINCT IE.id_insegn, D.id_persona , IE.annoaccademico
  FROM Docenza D JOIN InsErogato IE ON D.id_inserogato = IE.id
    JOIN CorsoInFacolta CF ON IE.id_corsostudi = CF.id_corsostudi
    JOIN Facolta F ON CF.id_facolta = F.id
  WHERE F.nome = 'Scienze matematiche fisiche e naturali'
    AND IE.modulo = 0;
-- sono 2598 righe
SELECT DISTINCT I.nomeins, P.id, P.nome, P.cognome
FROM Persona P JOIN Docenza D ON P.id = D.id_persona
  JOIN InsDocAnnoAtScienze I1 ON D.id_persona = I1.id_docente
  JOIN InsDocAnnoAtScienze I2 ON I1.id_Insegn = I2.id_Insegn
  JOIN Insegn I ON I1.id_insegn = I.id
WHERE I1.id_docente = I2.id_docente
  AND RIGHT (I1.aa, 4) = LEFT (I2.aa, 4)
ORDER BY I.nomeins, P.id, P.nome, P.cognome ;
-- and cast ( substring (I1.anno from 1 for 4) as integer )
-- = cast ( substring (I2.anno from 1 for 4) as integer ) -1;

--
-- Soluzione ERRATA: perché alcuni insegnamenti del corso di studi
-- (se è interfacoltà) potrebbero appartenere (IE1.id_facolta)
-- a un'altra facoltà.
--
SELECT DISTINCT I.nomeins , P.nome , P.cognome
FROM Insegn I
  JOIN Inserogato IE1 ON I.id = IE1.id_insegn
  JOIN Docenza D1 ON IE1.id = D1.id_inserogato
  JOIN Inserogato IE2 ON I.id = IE2.id_insegn
  JOIN Docenza D2 ON IE2.id = D2.id_inserogato
  JOIN Facolta F ON IE1.id_facolta = F.id
  JOIN Persona P ON D1.id_persona = P.id
WHERE IE1.id_facolta = IE2.id_facolta
  AND D1.id_persona = D2.id_persona
  AND IE1.modulo = 0
  AND IE2.modulo = 0
  AND F.nome = 'Scienze matematiche fisiche e naturali'
AND LEFT (IE1.annoaccademico, 4)::INTEGER =
    LEFT (IE2.annoaccademico, 4)::INTEGER+1;


--
-- Esercizio 5
-- Trovare per ogni docente il numero di insegnamenti o moduli o unità
-- logistiche a lui assegnate come docente nell'anno accademico
-- 2005/2006, riportare anche coloro che non hanno assegnato alcun
-- insegnamento. Nel risultato si mostri identificatore, nome e cognome
-- del docente insieme al conteggio richiesto (0 per il caso nessun
-- insegnamento/modulo/unità insegnati).
--
-- La soluzione ha 3315 righe.
--
SELECT P.id, P.nome, P.cognome, COUNT(IE.id) AS insDocente
FROM Persona P
  JOIN Docenza D ON P.id = D.id_persona
  JOIN Inserogato IE ON D.id_inserogato = IE.id
  WHERE annoaccademico = '2005/2006'
GROUP BY P.id , P.nome, P.cognome
UNION
SELECT P.id, P.nome, P.cognome, 0 AS insDocente
FROM Persona P
  JOIN Docenza D ON P.id = D.id_persona
WHERE P.id NOT IN (
  SELECT D2.id_persona
  FROM Docenza D2 JOIN Inserogato IE2 ON D2.id_inserogato = IE2.id
  WHERE annoaccademico = '2005/2006');

--
-- Soluzione ottimizzata
--
SELECT P.id, P.nome, P.cognome, COUNT(IE.id) AS insDocente
FROM Persona P JOIN Docenza D ON P.id = D.id_persona
LEFT JOIN (
  SELECT *
  FROM InsErogato
  WHERE annoaccademico = '2005/2006'
) AS IE ON D.id_inserogato = IE.id
GROUP BY P.id, P.nome, P.cognome ;
