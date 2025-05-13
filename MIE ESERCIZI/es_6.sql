--
-- Esercizio 1
-- Trovare, per ogni facoltà, il docente che ha tenuto il numero massimo
-- di ore di lezione nel 2009/2010, riportando il cognome e il nome del
-- docente e la facoltà. Per la relazione tra InsErogato e Facolta
-- usare la relazione diretta.
--
-- La soluzione ha 10 righe.
--
-- Mia sbagliata
select distinct persona.nome, persona.cognome, facolta.nome, COUNT(inserogato.id)
from facolta join inserogato on inserogato.id_facolta = facolta.id
					join corsostudi on inserogato.id_corsostudi = corsostudi.id
					join docenza on inserogato.id = docenza.id_inserogato
					join persona on docenza.id_persona = persona.id
where inserogato.annoaccademico = '2009/2010'
group by persona.nome, persona.cognome, facolta.nome
order by persona.cognome ASC;
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



-- OPPURE --

SELECT P.id, P.cognome, P.nome, OD.facolta , OD.oreTot
FROM Persona P JOIN OreDocente OD ON P.id = OD.docente JOIN (
  SELECT MAX ( oreTot ) AS maxOre, facolta
  FROM OreDocente
  GROUP BY facolta
) AS M ON M.facolta = OD.facolta AND OD.oreTot = M.maxOre
ORDER BY cognome;


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

