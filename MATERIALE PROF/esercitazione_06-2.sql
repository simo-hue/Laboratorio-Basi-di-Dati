--
-- Esercizio 1
-- Visualizzare in nomi dei corsi di studio che finiscono con la stringa ’informatica’ senza considerare maiuscole/minuscole.

-- EXPLAIN SELECT nome FROM corsostudi WHERE nome ILIKE '% informatica '; -- ilike è case - insesitive

-- QUERY PLAN
-- ------------------------------------------------------------
-- Seq Scan ON corsostudi (cost=0.00..96.94 ROWS=5 width=86)
-- Filter:((nome)::TEXT~~*'% informatica'::TEXT)

-- Creando un indice su nome, il numero di accessi a disco non diminuisce perché il pattern di ricerca inizia con '%'.
-- Quindi nessun indice può migliorare la query.

----------------------------------------------------------------------------------------

--
-- Esercizio 2
-- Visualizzare in nomi degli insegnamenti che iniziano per ’Teoria...’
-- Soluzione: da ~198 accessi si passa a 47. Gli indici creati sono: ....
--

-- EXPLAIN SELECT id , nomeins FROM Insegn WHERE nomeins LIKE 'Teoria %';

-- QUERY PLAN
-- ----------------------------------------------------------
-- Seq Scan ON insegn (cost=0.00..198.11 ROWS=55 width=39)
-- Filter:((nomeins)::TEXT~~*'teoria %'::TEXT)

-- Si crea un indice su nomeins.

-- CREATE INDEX nomeinsErrato_idx ON Insegn ( nomeins ); 
-- ANALYZE Insegn;
-- EXPLAIN SELECT id , nomeins FROM Insegn WHERE nomeins LIKE 'Teoria %';

-- QUERY PLAN
-- ----------------------------------------------------------
-- Seq Scan ON insegn(cost=0.00..198.11 ROWS=55 width=39)
-- Filter:((nomeins)::TEXT~~*'teoria %'::TEXT )

-- L’indice non è stato usato perché l’operatore LIKE può usare solo indici creati con l’opzione varchar_pattern_ops
-- quando il 'collate' del base di dati è diverso da 'C'.

-- CREATE INDEX nomeins_idx ON Insegn ( nomeins varchar_pattern_ops );
-- ANALYZE Insegn;
-- EXPLAIN SELECT id , nomeins FROM Insegn WHERE nomeins LIKE 'Teoria %';

-- QUERY PLAN
-- ------------------------------------------------------------------------------------------------------
-- Bitmap Heap Scan ON insegn (cost=1.94..47.03 ROWS=55 width=39)
-- Filter:((nomeins)::TEXT~~'Teoria %'::TEXT)
-- -> Bitmap INDEX Scan ON nomeins_idx (cost=0.00..1.92 ROWS=54 width=0)
-- INDEX Cond:(((nomeins)::TEXT~>=~'Teoria '::TEXT ) AND ((nomeins)::TEXT~<~'Teorib '::TEXT))

----------------------------------------------------------------------------------------

--
-- Esercizio 3
-- Trovare, per ogni insegnamento erogato dell’a.a. 2013/2014, il suo nome e id della facoltà che lo 
-- gestisce usando la relazione assorbita con facoltà.
-- Soluzione: da ~6398 accessi si passa a ~3981 con la creazione di due indici di cui uno di tipo hash.
--

-- EXPLAIN SELECT DISTINCT i. nomeins , ie.id_facolta 
-- FROM insegn i JOIN inserogato ie ON i.id=ie.id_insegn
-- WHERE annoaccademico ='2013/2014';

-- QUERY PLAN
-- ------------------------------------------------------------------------------
-- HashAggregate(cost=6346.67..6398.22 ROWS=5155 width=43)
-- GROUP KEY: i.nomeins, ie.id_facolta
-- -> Hash JOIN(cost=279.80..6320.90 ROWS=5155 width=43)
-- Hash Cond: (ie.id_insegn=i.id)
-- -> Seq Scan ON inserogato ie (cost=0.00..5970.21 ROWS=5155 width=8)
-- Filter:((annoaccademico)::TEXT='2013/2014'::TEXT)
-- -> Hash (cost=177.69..177.69 ROWS=8169 width=43)
-- -> Seq Scan ON insegn i (cost=0.00..177.69 ROWS=8169 width=43)

----------------------------------------------------------------------------------------

-- Creando un indice su annoaccademico, il numero di accessi a disco diminuisce:
-- CREATE INDEX ON inserogato(annoaccademico); 
-- ANALYZE inserogato ;
-- EXPLAIN SELECT DISTINCT i.nomeins, ie.id_facolta 
-- FROM insegn i JOIN inserogato ie ON i.id=ie.id_insegn
-- WHERE annoaccademico ='2013/2014';

-- QUERY PLAN
-- ----------------------------------------------------------------------------------------------------------
-- HashAggregate (cost=3995.65..4047.20 ROWS=5155 width=43)
-- GROUP KEY:i.nomeins, ie.id_facolta
-- -> Hash JOIN (cost=343.27..3969.87 ROWS=5155 width=43)
-- Hash Cond:(ie.id_insegn = i.id)
-- -> Bitmap Heap Scan ON inserogato ie (cost=63.47..3619.19 ROWS=5155 width=8)
-- Recheck Cond:((annoaccademico)::TEXT='2013/2014'::TEXT)
-- -> Bitmap INDEX Scan ON inserogato_annoaccademico_idx (cost=0.00..62.18 ROWS=5155 width=0)
-- INDEX Cond:((annoaccademico)::TEXT='2013/2014'::TEXT) 
-- -> Hash(cost=177.69..177.69 ROWS=8169 width=43)
-- -> Seq Scan ON insegn i(cost=0.00..177.69 ROWS=8169 width=43)

-- Creando un indice di tipo hash su insegn.id, si può migliorare anche la seconda foglia del hash join;
-- CREATE INDEX ON insegn USING hash(id); 
-- ANALYZE insegn;
-- EXPLAIN SELECT DISTINCT i.nomeins, ie.id_facolta 
-- FROM insegn i JOIN inserogato ie ON i.id=ie.id_insegn
-- WHERE annoaccademico ='2013/2014';

-- QUERY PLAN
-- ----------------------------------------------------------------------------------------------------------
-- HashAggregate (cost=3929.73..3981.28 ROWS=5155 width=43)
-- GROUP KEY : i. nomeins , ie. id_facolta
-- -> Nested Loop(cost=63.47..3903.95 ROWS=5155 width=43)
-- -> Bitmap Heap Scan ON inserogato ie (cost=63.47..3619.19 ROWS=5155 width=8)
-- Recheck Cond:((annoaccademico)::TEXT='2013/2014'::TEXT)
-- -> Bitmap INDEX Scan ON inserogato_annoaccademico_idx (cost=0.00..62.18 ROWS=5155 width=0)
-- INDEX Cond:((annoaccademico)::TEXT='2013/2014'::TEXT)
-- -> INDEX Scan USING insegn_id_idx ON insegn i (cost=0.00..0.05 ROWS=1 width=43)
-- INDEX Cond:(id = ie.id_insegn)

----------------------------------------------------------------------------------------

-- 
-- Esercizio 4
-- Visualizzare il codice, il nome e l'abbreviazione di tutti corsi di studio che nel nome contengono la sottostringa
-- 'lingue' (eseguire un test case-insensitive: usare ILIKE invece di LIKE).
-- Soluzione: da ~96 accessi si passa a...
-- 

-- EXPLAIN SELECT cs.codice, cs.nome, cs. abbreviazione FROM corsostudi cs WHERE cs.nome ILIKE '%lingue%';

-- QUERY PLAN
-- --------------------------------------------------------------
-- Seq Scan ON corsostudi cs (cost=0.00..96.94 ROWS=16 width=98)
-- Filter:((nome)::TEXT~~* '% lingue %'::TEXT)
-- Il fatto che il pattern di ricerca abbia ’%’ all’inzio è sufficiente per dire che nessun indice può essere usato.

----------------------------------------------------------------------------------------

--
-- Esercizio 5
-- Visualizzare identificatori e numero modulo dei moduli reali (modulo>0) degli insegnamenti erogati nel
-- 2010/2011 associati alla facoltà con id=7 tramite la relazione diretta.
-- Soluzione: da ~6310 accessi si passa a ~1460 creando 3 indici.
--

-- EXPLAIN SELECT ie.id, ie.modulo 
-- FROM inserogato ie 
-- WHERE ie.annoaccademico ='2010/2011' AND ie.id_facolta=7 AND modulo > 0;

-- QUERY PLAN
-- ---------------------------------------------------------------------------------------------------------
-- Seq Scan ON inserogato ie ( cost=0.00..6310.30 ROWS=861 width=7)
-- Filter:((modulo>'0'::NUMERIC) AND ((annoaccademico)::TEXT='2010/2011'::TEXT ) AND (id_facolta=7))

-- Creando indice su annoaccademico:

-- CREATE INDEX ON inserogato(annoaccademico); 
-- ANALYZE inserogato ;
-- EXPLAIN SELECT ie.id, ie.modulo 
-- FROM inserogato ie 
-- WHERE ie.annoaccademico='2010/2011' AND ie.id_facolta=7 AND modulo>0;

-- QUERY PLAN
-- --------------------------------------------------------------------------
-- Bitmap Heap Scan ON inserogato ie (cost=84.74..4444.88 ROWS=861 width=7)
-- Recheck Cond: ((annoaccademico)::TEXT='2010/2011'::TEXT)
-- Filter: ((modulo>'0'::NUMERIC) AND (id_facolta=7))
-- -> Bitmap INDEX Scan ON inserogato_annoaccademico_idx (cost=0.00..84.53 ROWS=7108 width=0)
-- INDEX Cond: ((annoaccademico )::TEXT='2010/2011'::TEXT)


-- Creando indice su id_facolta:
-- CREATE INDEX ON inserogato(id_facolta); 
-- EXPLAIN SELECT ie.id , ie.modulo 
-- FROM inserogato ie 
-- WHERE ie.annoaccademico ='2010/2011' AND ie.id_facolta=7 AND modulo > 0;

-- QUERY PLAN
-- -----------------------------------------------------------------------------------
-- Bitmap Heap Scan ON inserogato ie ( cost=408.07..2973.51 ROWS=861 width=7 )
-- Recheck Cond: (((annoaccademico )::TEXT='2010/2011'::TEXT) AND (id_facolta=7))
-- Filter:( modulo>'0'::NUMERIC)
-- -> BitmapAnd (cost=408.07..408.07 ROWS=3192 width=0)
-- -> Bitmap INDEX Scan ON inserogato_annoaccademico_idx (cost=0.00..84.53 ROWS=7108 width=0)
-- INDEX Cond: ((annoaccademico)::TEXT='2010/2011'::TEXT)
-- -> Bitmap INDEX Scan ON inserogato_id_facolta_idx (cost=0.00..322.87 ROWS=30543 width=0)
-- INDEX Cond: (id_facolta=7)

-- Creando indice su modulo:

-- CREATE INDEX ON inserogato(modulo); 
-- EXPLAIN SELECT ie.id, ie.modulo 
-- FROM inserogato ie 
-- WHERE ie.annoaccademico ='2010/2011' AND ie.id_facolta=7 AND modulo > 0;

-- QUERY PLAN
-- --------------------------------------------------------------------------------------
-- Bitmap Heap Scan ON inserogato ie (cost=602.53..1460.77 ROWS=861 width=7)
-- Recheck Cond: (((annoaccademico)::TEXT='2010/2011'::TEXT) AND (modulo>'0'::NUMERIC) AND (id_facolta=7))
-- -> BitmapAnd (cost=602.53..602.53 ROWS=861 width=0)
-- -> Bitmap INDEX Scan ON inserogato_annoaccademico_idx (cost=0.00..84.53 ROWS=7108 width=0)
-- INDEX Cond: ((annoaccademico)::TEXT='2010/2011'::TEXT)
-- -> Bitmap INDEX Scan ON inserogato_modulo_idx (cost=0.00..193.99 ROWS=18347 width=0)
-- INDEX Cond: (modulo>'0'::NUMERIC)
-- -> Bitmap INDEX Scan ON inserogato_id_facolta_idx (cost=0.00..322.87 ROWS=30543 width=0)
-- INDEX Cond: (id_facolta=7)


-- Si può anche costruire un unico indice a 3 attributi.

-- CREATE INDEX ON inserogato(annoaccademico, id_facolta, modulo);
-- ANALYZE inserogato;
-- EXPLAIN SELECT ie.id , ie.modulo 
-- FROM inserogato ie 
-- WHERE ie.annoaccademico ='2010/2011' AND ie.id_facolta=7 AND modulo > 0;

-- QUERY PLAN
-- -----------------------------------------------------------------------------------------------------
-- Bitmap Heap Scan ON inserogato ie (cost=21.40..1313.19 ROWS=861 width=7)
-- Recheck Cond: (((annoaccademico)::TEXT='2010/2011'::TEXT) AND (id_facolta=7) AND (modulo>'0'::NUMERIC))
-- -> Bitmap INDEX Scan ON inserogato_annoaccademico_id_facolta_modulo_idx (cost=0.00..21.18 ROWS=861 width=0)
-- INDEX Cond: (((annoaccademico)::TEXT='2010/2011'::TEXT) AND (id_facolta=7) AND (modulo>'0'::NUMERIC))

----------------------------------------------------------------------------------------

-- 
-- Esercizio 6
-- Visualizzare il nome e il discriminante (attributo descrizione della tabella Discriminante) degli insegnamenti
-- erogati nel 2009/2010 che non sono moduli e che hanno 3, 5 o 12 crediti.
-- Soluzione: da ~6743 accessi si passa a 1192 creando un indice btree e un indice hash.
--

-- EXPLAIN SELECT DISTINCT I.nomeins, D.descrizione
-- FROM Insegn I JOIN InsErogato IE ON I.id = IE.id_insegn 
-- JOIN Discriminante D ON IE.id_discriminante = D.id
-- WHERE IE. annoaccademico = '2009/2010'
-- AND IE. modulo = 0
-- AND IE. crediti IN (3, 5, 12);

-- QUERY PLAN
-- ---------------------------------------------------------------------------------------------------------------------
-- UNIQUE (cost=6738.48..6743.41 ROWS=657 width=60)
-- -> Sort (cost=6738.48..6740.12 ROWS=657 width=60)
-- Sort KEY: i.nomeins, d.descrizione
-- -> Hash JOIN (cost=292.86..6707.73 ROWS=657 width=60)
-- Hash Cond: (ie.id_insegn = i.id)
-- -> Hash JOIN (cost=5.06..6410.90 ROWS=657 width=25)
-- Hash Cond: (ie.id_discriminante = d.id)
-- -> Seq Scan ON inserogato ie (cost=0.00..6395.32 ROWS=1053 width=8)
-- Filter: (((annoaccademico)::TEXT='2009/2010'::TEXT) AND (modulo='0'::NUMERIC) AND (crediti=ANY('{3 ,5 ,12}'::NUMERIC[])))
-- -> Hash (cost=3.36..3.36 ROWS=136 width=25)
-- -> Seq Scan ON discriminante d (cost=0.00..3.36 ROWS=136 width=25)
-- -> Hash (cost=185.69..185.69 ROWS=8169 width=43)
-- -> Seq Scan ON insegn i (cost=0.00..185.69 ROWS=8169 width=43)

-- Creando un indice a tre attributi, si ottiene
-- CREATE INDEX ON inserogato( annoaccademico, crediti, modulo ); 
-- ANALYZE inserogato;

-- EXPLAIN SELECT DISTINCT I.nomeins, D.descrizione
-- FROM Insegn I JOIN InsErogato IE ON I.id = IE.id_insegn 
-- JOIN Discriminante D ON IE.id_discriminante = D.id
-- WHERE IE.annoaccademico = '2009/2010'
-- AND IE.modulo = 0
-- AND IE.crediti IN (3, 5, 12);

-- QUERY PLAN
-- --------------------------------------------------------------------------------------------------------------------
-- HashAggregate(cost=1369.55..1376.12 ROWS=657 width=60)
-- GROUP KEY: i.nomeins , d.descrizione
-- -> Hash JOIN (cost=293.28..1366.26 ROWS=657 width=60)
-- Hash Cond: (ie.id_insegn = i.id)
-- -> Hash JOIN (cost=5.48..1069.42 ROWS=657 width=25)
-- Hash Cond : (ie.id_discriminante = d.id)
-- -> INDEX Scan USING inserogato_annoaccademico_crediti_modulo_idx ON inserogato ie(cost=0.42..1053.85 ROWS=1053 width=8)
-- INDEX Cond: (((annoaccademico)::TEXT='2009/2010'::TEXT ) AND (crediti=ANY('{3 ,5 ,12}'::NUMERIC[])) AND (modulo='0'::NUMERIC))
-- -> Hash (cost=3.36..3.36 ROWS=136 width=25)
-- -> Seq Scan ON discriminante d (cost=0.00..3.36 ROWS=136 width=25)
-- -> Hash (cost=185.69..185.69 ROWS=8169 width=43)
-- -> Seq Scan ON insegn i (cost=0.00..185.69 ROWS=8169 width=43)

-- Poi si crea indice hash su insegn.id.
-- CREATE INDEX ON insegn USING hash(id); 
-- ANALYZE insegn;

-- EXPLAIN SELECT DISTINCT I.nomeins, D.descrizione
-- FROM Insegn I JOIN InsErogato IE ON I.id = IE.id_insegn 
-- JOIN Discriminante D ON IE.id_discriminante = D.id
-- WHERE IE.annoaccademico = '2009/2010'
-- AND IE.modulo = 0
-- AND IE.crediti IN (3, 5, 12);

-- QUERY PLAN
-- --------------------------------------------------------------------------------------------------------------------
-- HashAggregate(cost=1185.49..1192.06 ROWS=657 width=60)
-- GROUP KEY: i.nomeins, d.descrizione
-- -> Nested Loop (cost=5.48..1182.20 ROWS=657 width=60)
-- -> Hash JOIN (cost=5.48..1069.42 ROWS=657 width=25)
-- Hash Cond: (ie.id_discriminante = d.id)
-- -> INDEX Scan USING inserogato_annoaccademico_crediti_modulo_idx ON inserogato ie (cost=0.42..1053.85 ROWS=1053 width=8)
-- INDEX Cond: (((annoaccademico)::TEXT='2009/2010'::TEXT) AND (crediti=ANY('{3,5,12}'::NUMERIC[])) AND (modulo='0'::NUMERIC))
-- -> Hash (cost=3.36..3.36 ROWS=136 width=25)
-- -> Seq Scan ON discriminante d (cost=0.00..3.36 ROWS=136 width=25)
-- -> INDEX Scan USING insegn_id_idx ON insegn i (cost=0.00..0.16 ROWS=1 width=43)
-- INDEX Cond: (id=ie.id_insegn )

-- Creando tre indici separati, non si ottengono le stesse prestazioni;
-- EXPLAIN SELECT DISTINCT I.nomeins, D.descrizione
-- FROM Insegn I JOIN InsErogato IE ON I.id=IE.id_insegn JOIN Discriminante D ON IE.id_discriminante=D.id
-- WHERE IE.annoaccademico = '2009/2010'
-- AND IE.modulo = 0
-- AND IE.crediti IN (3, 5, 12);
-- 
-- HashAggregate (cost=2649.27..2655.84 ROWS=657 width=60)
-- GROUP KEY: i.nomeins, d.descrizione
-- -> Hash JOIN (cost=589.24..2645.98 ROWS=657 width=60)
-- Hash Cond: (ie.id_insegn=i.id)
-- -> Hash JOIN (cost=301.44..2349.15 ROWS=657 width=25)
-- Hash Cond: (ie.id_discriminante=d.id)
-- -> Bitmap Heap Scan ON inserogato ie (cost=296.38..2333.57 ROWS=1053 width=8)
-- Recheck Cond: ((( annoaccademico )::TEXT='2009/2010'::TEXT) AND (crediti=ANY('{3 ,5 ,12}'::NUMERIC[])))
-- Filter: ( modulo='0'::NUMERIC )
-- -> BitmapAnd (cost=296.38..296.38 ROWS=1556 width=0)
-- -> Bitmap INDEX Scan ON inserogato_annoaccademico_idx (cost=0.00..120.89 ROWS=7796 width=0)
-- INDEX Cond: ((annoaccademico)::TEXT='2009/2010':: TEXT)
-- -> Bitmap INDEX Scan ON inserogato_crediti_idx (cost=0.00..174.71 ROWS=13578 width=0)
-- INDEX Cond: (crediti=ANY('{3 ,5 ,12}'::NUMERIC[]))
-- -> Hash (cost=3.36..3.36 ROWS=136 width=25)
-- -> Seq Scan ON discriminante d (cost=0.00..3.36 ROWS=136 width=25)
-- -> Hash (cost=185.69..185.69 ROWS=8169 width=43)
-- -> Seq Scan ON insegn i (cost=0.00..185.69 ROWS=8169 width=43)

----------------------------------------------------------------------------------------

--
-- Esercizio 7
-- Visualizzare il nome e il discriminante degli insegnamenti erogati nel 2008/2009 senza moduli e con crediti
-- maggiore di 9.
-- Soluzione: da ~6633 accessi si deve passare a meno di 760...
--
-- SELECT DISTINCT I.nomeins AS nome, D.descrizione AS descrizione
-- FROM InsErogato IE JOIN Discriminante D ON IE.id_discriminante = D.id
-- JOIN Insegn I ON IE.id_insegn = I.id
-- WHERE IE.annoaccademico = '2008/2009'
-- AND IE.hamoduli = '0'
-- AND IE.crediti > 9;

-- Indici:

-- CREATE INDEX idx_where ON InsErogato (annoaccademico, hamoduli, crediti);
-- ANALYZE InsErogato;

-- CREATE INDEX idx_insegn ON Insegn USING hash(id);
-- ANALYZE Insegn;

-- Da circa 6633 accessi si passa a circa 760 accessi. Inserito indice "triplo" sulle condizioni del WHERE e
-- poi su Insegn.id per migliorare anche la foglia del hash join.

----------------------------------------------------------------------------------------

--
-- Esercizio 8
-- Visualizzare in ordine alfabetico di nome degli insegnamenti (esclusi di moduli e le unità logistiche) erogati
-- nel 2013/2014 nel corso di 'Laurea in Informatica', riportando il nome, il discriminante, i crediti e gli anni di
-- erogazione.
-- Soluzione: da ~6494 accessi si deve passare a meno di 66...
--
-- SELECT I.nomeins AS nome, D.descrizione AS descrizione, IE.crediti AS crediti, IE.annierogazione AS annierogazione
-- FROM InsErogato IE JOIN Discriminante D ON IE.id_discriminante = D.id
-- JOIN Insegn I ON IE. id_insegn = I.id
-- JOIN CorsoStudi CS ON CS.id = IE.id_corsostudi
-- WHERE IE.modulo = 0
-- AND IE.annoaccademico = '2013/2014'
-- AND CS.nome = 'Laurea in informatica'
-- ORDER BY I. nomeins ;

-- Indici :

-- CREATE INDEX idx_corsostudi ON InsErogato USING hash( id_corsostudi );
-- ANALYZE InsErogato;

-- CREATE INDEX idx_insegn ON Insegn USING hash(id);
-- ANALYZE Insegn;

-- CREATE INDEX idx_discriminante ON Discriminante USING hash(id);
-- ANALYZE Discriminante;

-- CREATE INDEX idx_where1 ON InsErogato( annoaccademico , modulo );
-- ANALYZE InsErogato;

-- CREATE INDEX idx_where2 ON CorsoStudi( nome );
-- ANALYZE CorsoStudi;

-- da circa 6494 accessi si passa a circa 66 accessi

----------------------------------------------------------------------------------------

-- 
-- Esercizio 9
-- Trovare il massimo numero di crediti degli insegnamenti erogati dall’ateneo nell’a.a. 2013/2014.
-- Soluzione: meno di 6635 accessi.

-- SELECT MAX(IE.crediti) AS massimocrediti
-- FROM InsErogato IE
-- WHERE IE.annoaccademico = '2013/2014';

-- Indici :

-- CREATE INDEX idx_annoaccademico ON InsErogato ( annoaccademico );
-- ANALYZE InsErogato ;

-- da circa 5983 accessi si passa a circa 3632 accessi.

----------------------------------------------------------------------------------------

-- 
-- Esercizio 10
-- Trovare, per ogni anno accademico, il massimo e il minimo numero di crediti erogati in un insegnamento.
-- Soluzione: meno di 6315 accessi.
--

-- SELECT IE.annoaccademico AS annoaccademico, MAX(IE.crediti) AS massimocrediti, MIN(IE.crediti) AS minimocrediti
-- FROM InsErogato IE
-- GROUP BY IE.annoaccademico
-- ORDER BY IE.annoaccademico;

-- Indici :

-- EXPLAIN SELECT IE.annoaccademico AS annoaccademico, MAX(IE.crediti) AS massimocrediti, MIN(IE.crediti) AS minimocrediti
-- FROM InsErogato IE
-- GROUP BY IE.annoaccademico
-- ORDER BY IE.annoaccademico;

-- da circa 6310 accessi si passa a circa 6310 accessi .
-- Creando indice su annoaccademico e/o su crediti NON cambia nulla.

----------------------------------------------------------------------------------------

--
-- Esercizio 11
-- Trovare il nome dei corsi di studio che non hanno mai erogato insegnamenti che contengono nel nome la stringa
-- 'matematica' (usare ILIKE invece di LIKE per rendere il test non sensibile alle maiuscole/minuscole).
-- Soluzione: meno di 942 accessi.
--

-- SELECT DISTINCT CS.nome AS nome
-- FROM CorsoStudi CS
-- WHERE CS.id NOT IN ( SELECT DISTINCT IE.id_corsostudi
-- FROM InsErogato IE JOIN INSEGN I ON I.id = IE.id_insegn
-- WHERE I. nomeins ILIKE '% matematica %'
-- );

-- Indici :

-- CREATE INDEX idx_insegn ON Insegn USING hash(id);
-- ANALYZE Insegn;

-- CREATE INDEX idx_insegn_2 ON InsErogato USING hash(id_insegn);
-- ANALYZE InsErogato;

-- da circa 6404 accessi si passa a circa 942 accessi.
-- Creando indici su id_corsostudi e id di corsostudi NON cambia nulla .

----------------------------------------------------------------------------------------

-- 
-- Esercizio 12
-- Trovare, per ogni anno accademico e per ogni corso di laurea, la somma dei crediti erogati (esclusi i moduli e le
-- unità logistiche: vedi nota sopra) e il massimo e minimo numero di crediti degli insegnamenti erogati sempre
-- escludendo i moduli e le unità logistiche.
-- Soluzione: da ~7408 accessi si passa a...
--

-- EXPLAIN SELECT IE.annoaccademico, CS.nome , SUM(IE.crediti) AS sommaCrediti, MAX(IE.crediti) AS maxCrediti, MIN(IE.crediti) AS minCrediti
-- FROM InsErogato IE JOIN CorsoStudi CS ON IE.id_corsostudi = CS.id
-- WHERE IE.modulo = 0
-- GROUP BY IE.annoaccademico, CS.nome;

-- QUERY PLAN
-- ---------------------------------------------------------------------------------
-- HashAggregate(cost=7281.03..7408.03 ROWS=10160 width=192)
-- GROUP KEY: ie.annoaccademico, cs.nome
-- -> Hash JOIN(cost=103.29..6706.01 ROWS=46001 width=100)
-- Hash Cond: (ie.id_corsostudi=cs.id)
-- -> Seq Scan ON inserogato ie (cost=0.00..5970.21 ROWS=46001 width=18)
-- Filter: (modulo='0'::NUMERIC)
-- -> Hash (cost=95.35..95.35 ROWS=635 width=90)
-- -> Seq Scan ON corsostudi cs (cost=0.00..95.35 ROWS=635 width=90)

-- Creando indici su modulo, id_corsostudi e id di corsostudi NON cambia nulla.

