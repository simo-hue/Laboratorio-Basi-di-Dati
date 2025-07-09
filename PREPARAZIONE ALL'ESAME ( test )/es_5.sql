/*
   CorsoStudi(id, nome, codice, abbreviazione, durataAnni, sede, informativa, id_segreteria)
    Facolta(id, nome, codice, indirizzo, informativa, id_preside_persona, id_segreteria)
    Insegn(id, nomeins, codiceins)
    Discriminante(id, nome, descrizione)
    InsErogato(id, annoaccademico, id_insegn, id_corsostudi, id_discriminante, modulo, discriminantemodulo,
    nomemodulo, crediti, programma, id_facolta, hamoduli, id_inserogato_padre, nomeunità, annierogazione)
    CorsoInFacolta(id, id_corsostudi, id_facolta)
    Persona(id, cognome, nome, sesso, telefono, email)
    Docenza(id, id_inserogato, id_persona, id_settore, creditilez, orelez)
    InsInPeriodo(id, id_inserogato, id_periodolez)
    PeriodoLez(id, abbreviazione)
    PeriodoDid(id, annoaccademico, descrizione, discriminante, inizio, fine)
    Lezione(id, id_periodolez, id_inserogato, giorno, orainizio, datainizio, orafine, datafine)
    StrutturaServizio(id, nomestruttura, orarioapertura, telefono1, telefono2, fax, email, compiti)


*/
SELECT p1.id, p1.nome, p1.cognome
FROM persona p1 JOIN docenza d1 on  d1.id_persona = p1.id
				JOIN inserogato on inserogato.id = d1.id_inserogato
					JOIN insegn i1 on i1.id = inserogato.id_insegn
WHERE annoaccademico = '2010/2011' AND (i1.nomeins NOT IN ( 
												SELECT nomeins
												FROM persona p2 JOIN docenza d2 on  d2.id_persona = p2.id
												JOIN inserogato on inserogato.id = d2.id_inserogato
													JOIN insegn i2 on i2.id = inserogato.id_insegn
												WHERE annoaccademico = '2009/2010' 
												) 
										)
ORDER BY p1.id;


SELECT distinct persona.id, persona.nome, persona.cognome, nomeins
FROM persona JOIN docenza on docenza.id_persona = persona.id
				JOIN inserogato on inserogato.id = docenza.id_inserogato
					JOIN insegn on insegn.id = inserogato.id_insegn
WHERE annoaccademico = '2010/2011'
GROUP BY persona.id, persona.nome, persona.cognome, nomeins
HAVING insegn.nomeins NOT IN (SELECT nomeins
								FROM persona JOIN docenza on docenza.id_persona = persona.id
								JOIN inserogato on inserogato.id = docenza.id_inserogato
									JOIN insegn on insegn.id = inserogato.id_insegn
								WHERE annoaccademico = '2009/2010');


SELECT DISTINCT P1.id, P1.nome, P1.cognome
FROM Persona AS P1
  JOIN Docenza as D1 ON (P1.id = D1.id_persona)
  JOIN InsErogato AS IE1 ON (IE1.id = D1.id_inserogato)
  JOIN Insegn AS I1 ON (I1.id = IE1.id_insegn)
WHERE IE1.annoaccademico = '2010/2011' 
  AND D1.id_persona NOT IN
    ( SELECT D2.id_persona
      FROM Docenza AS D2 
        JOIN InsErogato AS IE2 ON (IE2.id = D2.id_inserogato) 
        JOIN Insegn AS I2 ON (I2.id = IE2.id_insegn)
      WHERE IE2.annoaccademico = '2009/2010'  
        AND I2.nomeins = I1.nomeins )
ORDER BY P1.id;        
/*
       CorsoStudi(id, nome, codice, abbreviazione, durataAnni, sede, informativa, id_segreteria)
    Facolta(id, nome, codice, indirizzo, informativa, id_preside_persona, id_segreteria)
    Insegn(id, nomeins, codiceins)
    Discriminante(id, nome, descrizione)
    InsErogato(id, annoaccademico, id_insegn, id_corsostudi, id_discriminante, modulo, discriminantemodulo,
    nomemodulo, crediti, programma, id_facolta, hamoduli, id_inserogato_padre, nomeunità, annierogazione)
    CorsoInFacolta(id, id_corsostudi, id_facolta)
    Persona(id, cognome, nome, sesso, telefono, email)
    Docenza(id, id_inserogato, id_persona, id_settore, creditilez, orelez)
    InsInPeriodo(id, id_inserogato, id_periodolez)
    PeriodoLez(id, abbreviazione)
    PeriodoDid(id, annoaccademico, descrizione, discriminante, inizio, fine)
    Lezione(id, id_periodolez, id_inserogato, giorno, orainizio, datainizio, orafine, datafine)
    StrutturaServizio(id, nomestruttura, orarioapertura, telefono1, telefono2, fax, email, compiti)



*/
SELECT corsostudi.nome, count(inserogato.id) as numinsegn 
FROM corsoinfacolta JOIN corsostudi ON corsostudi.id = corsoinfacolta.id_corsostudi
					JOIN facolta ON facolta.id = corsoinfacolta.id_facolta
					JOIN inserogato on inserogato.id_corsostudi = corsostudi.id
WHERE annoaccademico = '2010/2011' AND facolta.nome <> 'Medicina e Chirurgia' AND inserogato.hamoduli <> '0'
GROUP BY corsostudi.nome
ORDER BY corsostudi.nome;


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


/*
       CorsoStudi(id, nome, codice, abbreviazione, durataAnni, sede, informativa, id_segreteria)
    Facolta(id, nome, codice, indirizzo, informativa, id_preside_persona, id_segreteria)
    Insegn(id, nomeins, codiceins)
    Discriminante(id, nome, descrizione)
    InsErogato(id, annoaccademico, id_insegn, id_corsostudi, id_discriminante, modulo, discriminantemodulo,
    nomemodulo, crediti, programma, id_facolta, hamoduli, id_inserogato_padre, nomeunità, annierogazione)
    CorsoInFacolta(id, id_corsostudi, id_facolta)
    Persona(id, cognome, nome, sesso, telefono, email)
    Docenza(id, id_inserogato, id_persona, id_settore, creditilez, orelez)
    InsInPeriodo(id, id_inserogato, id_periodolez)
    PeriodoLez(id, abbreviazione)
    PeriodoDid(id, annoaccademico, descrizione, discriminante, inizio, fine)
    Lezione(id, id_periodolez, id_inserogato, giorno, orainizio, datainizio, orafine, datafine)
    StrutturaServizio(id, nomestruttura, orarioapertura, telefono1, telefono2, fax, email, compiti)



*/
SELECT distinct nomeins
FROM insegn JOIN inserogato ON inserogato.id_insegn = insegn.id
			JOIN corsostudi ON corsostudi.id = inserogato.id_corsostudi
			JOIN insinperiodo on insinperiodo.id_inserogato = inserogato.id
			JOIN periodolez ON periodolez.id = insinperiodo.id_periodolez
WHERE corsostudi.id = 4

EXCEPT 

SELECT distinct nomeins
FROM insegn JOIN inserogato ON inserogato.id_insegn = insegn.id
			JOIN corsostudi ON corsostudi.id = inserogato.id_corsostudi
			JOIN insinperiodo on insinperiodo.id_inserogato = inserogato.id
			JOIN periodolez ON periodolez.id = insinperiodo.id_periodolez
WHERE periodolez.abbreviazione LIKE '2%' AND corsostudi.id = 4;




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

/*
       CorsoStudi(id, nome, codice, abbreviazione, durataAnni, sede, informativa, id_segreteria)
    Facolta(id, nome, codice, indirizzo, informativa, id_preside_persona, id_segreteria)
    Insegn(id, nomeins, codiceins)
    Discriminante(id, nome, descrizione)
    InsErogato(id, annoaccademico, id_insegn, id_corsostudi, id_discriminante, modulo, discriminantemodulo,
    nomemodulo, crediti, programma, id_facolta, hamoduli, id_inserogato_padre, nomeunità, annierogazione)
    CorsoInFacolta(id, id_corsostudi, id_facolta)
    Persona(id, cognome, nome, sesso, telefono, email)
    Docenza(id, id_inserogato, id_persona, id_settore, creditilez, orelez)
    InsInPeriodo(id, id_inserogato, id_periodolez)
    PeriodoLez(id, abbreviazione)
    PeriodoDid(id, annoaccademico, descrizione, discriminante, inizio, fine)
    Lezione(id, id_periodolez, id_inserogato, giorno, orainizio, datainizio, orafine, datafine)
    StrutturaServizio(id, nomestruttura, orarioapertura, telefono1, telefono2, fax, email, compiti)



*/
SELECT corsostudi.nome 
FROM corsostudi
WHERE corsostudi.id NOT IN (
							SELECT c.id
							FROM corsostudi c JOIN inserogato ie ON ie.id_corsostudi = c.id
												JOIN insegn ins ON ins.id = ie.id_insegn
							WHERE ins.nomeins ILIKE '%matematica%'
							);


SELECT CS1.nome
FROM CorsoStudi as CS1 
WHERE CS1.id NOT IN
  ( SELECT CS2.id
    FROM Insegn AS I2
      JOIN InsErogato AS IE2 ON (IE2.id_insegn = I2.id)
      JOIN CorsoStudi as CS2 ON (IE2.id_corsostudi = CS2.id)
    WHERE I2.nomeins ILIKE '%matematica%')







