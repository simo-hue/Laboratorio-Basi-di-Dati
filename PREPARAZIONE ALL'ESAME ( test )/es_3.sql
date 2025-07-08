/*
    • CorsoStudi(id, nome, codice, abbreviazione, durataAnni, sede, informativa, id_segreteria) 
    • Insegn(id, nomeins, codiceins) 
    • Discriminante(id, nome, descrizione) 
    • InsErogato(id, annoaccademico, id_insegn, id_corsostudi, id_discriminante, modulo, discriminantemodulo, 
        nomemodulo, crediti, programma, id_facolta, hamoduli, id_inserogato_padre, nomeunità, annierogazione)


    Visualizzare in nomi dei corsi di studio che finiscono con la stringa ’informatica’ senza considerare 
    maiuscole/minuscole. 
    Soluzione: da ~97 accessi si passa a... . Gli indici creati sono: ....         
*/
SELECT nome
FROM corsostudi
WHERE nome ILIKE '%informatica';
HAVING

/*
    CorsoStudi(id, nome, codice, abbreviazione, durataAnni, sede, informativa) 
    Facolta(id, nome, codice, indirizzo, informativa, id_preside_persona, id_segreteria) 
    Insegn(id, nomeins, codiceins) 
    Discriminante(id, nome, descrizione) 
    InsErogato(id, annoaccademico, id_insegn, id_corsostudi, id_discriminante, modulo, discriminantemodulo, 
    nomemodulo, crediti, programma, id_facolta, hamoduli, id_inserogato_padre,  
    nomeunità, annierogazione) 
    CorsoInFacolta(id, id_corsostudi, id_facolta)

    Trovare, per ogni insegnamento erogato dell’a.a. 2013/2014, il suo nome e id della facoltà che lo gestisce 
    usando la relazione assorbita con facoltà. 
    Soluzione: da ~6398 accessi si passa a ~3981 con la creazione di due indici di cui uno di tipo hash.
*/
SELECT nomeins, id_facolta
FROM inserogato JOIN insegn ON insegn.id = inserogato.id_insegn
WHERE annoaccademico = '2013/2014';


/*
    CorsoStudi(id, nome, codice, abbreviazione, durataAnni, sede, informativa) 
    Facolta(id, nome, codice, indirizzo, informativa, id_preside_persona, id_segreteria) 
    Insegn(id, nomeins, codiceins) 
    Discriminante(id, nome, descrizione) 
    InsErogato(id, annoaccademico, id_insegn, id_corsostudi, id_discriminante, modulo, discriminantemodulo, 
    nomemodulo, crediti, programma, id_facolta, hamoduli, id_inserogato_padre,  
    nomeunità, annierogazione) 
    CorsoInFacolta(id, id_corsostudi, id_facolta)

        
*/

SELECT COUNT(*)
FROM corsostudi

/*
    CorsoStudi(id, nome, codice, abbreviazione, durataAnni, sede, informativa) 
    Facolta(id, nome, codice, indirizzo, informativa, id_preside_persona, id_segreteria) 
    Insegn(id, nomeins, codiceins) 
    Discriminante(id, nome, descrizione) 
    InsErogato(id, annoaccademico, id_insegn, id_corsostudi, id_discriminante, modulo, discriminantemodulo, 
    nomemodulo, crediti, programma, id_facolta, hamoduli, id_inserogato_padre,  
    nomeunità, annierogazione) 
    CorsoInFacolta(id, id_corsostudi, id_facolta)

    Trovare per ogni corso di studi che ha erogato insegnamenti nel 2010/2011 il suo nome e il nome delle 
    facoltà che lo gestiscono (si noti che un corso può essere gestito da più facoltà). Non usare la relazione 
    diretta tra InsErogato e Facoltà. Porre i risultati in ordine di nome corso studi.
*/

SELECT DISTINCT CS.nome, F.nome
FROM CorsoStudi AS CS 
JOIN InsErogato AS IE ON (CS.id = IE.id_corsostudi)
JOIN CorsoInFacolta AS CIF ON (CIF.id_corsostudi = CS.id)
JOIN Facolta AS F ON (CIF.id_facolta = F.id)
WHERE IE.annoaccademico = '2010/2011'
ORDER BY CS.nome;

/*
    CorsoStudi(id, nome, codice, abbreviazione, durataAnni, sede, informativa) 
    Facolta(id, nome, codice, indirizzo, informativa, id_preside_persona, id_segreteria) 
    Insegn(id, nomeins, codiceins) 
    Discriminante(id, nome, descrizione) 
    InsErogato(id, annoaccademico, id_insegn, id_corsostudi, id_discriminante, modulo, discriminantemodulo, 
    nomemodulo, crediti, programma, id_facolta, hamoduli, id_inserogato_padre,  
    nomeunità, annierogazione) 
    CorsoInFacolta(id, id_corsostudi, id_facolta)

    Visualizzare il nome, il codice e l’abbreviazione di tutti i corsi di studio gestiti dalla facoltà di Medicina e 
    Chirurgia
    
*/

SELECT CS.nome, CS.codice, CS.abbreviazione
FROM CorsoInFacolta JOIN CorsoStudi AS CS ON (CS.id = CorsoInFacolta.id_corsostudi)
                    JOIN Facolta AS F ON (F.id = CorsoInFacolta.id_facolta)     
WHERE F.nome ILIKE '%Medicina e Chirurgia%';



/*
    CorsoStudi(id, nome, codice, abbreviazione, durataAnni, sede, informativa) 
    Facolta(id, nome, codice, indirizzo, informativa, id_preside_persona, id_segreteria) 
    Insegn(id, nomeins, codiceins) 
    Discriminante(id, nome, descrizione) 
    InsErogato(id, annoaccademico, id_insegn, id_corsostudi, id_discriminante, modulo, discriminantemodulo, 
    nomemodulo, crediti, programma, id_facolta, hamoduli, id_inserogato_padre,  
    nomeunità, annierogazione) 
    CorsoInFacolta(id, id_corsostudi, id_facolta)

    Visualizzare il codice, il nome e l’abbreviazione di tutti corsi di studio che nel nome contengono la 
	sottostringa ’lingue’ (eseguire il confronto usando ILIKE invece di LIKE: in questo modo i caratteri maiuscolo 
	e minuscolo non sono diversi). 
	Soluzione: ci sono 16 righe.
*/
select codice, nome, abbreviazione
from corsostudi
WHERE nome ILIKE '%lingue%'


/*
    CorsoStudi(id, nome, codice, abbreviazione, durataAnni, sede, informativa) 
    Facolta(id, nome, codice, indirizzo, informativa, id_preside_persona, id_segreteria) 
    Insegn(id, nomeins, codiceins) 
    Discriminante(id, nome, descrizione) 
    InsErogato(id, annoaccademico, id_insegn, id_corsostudi, id_discriminante, modulo, discriminantemodulo, 
    nomemodulo, crediti, programma, id_facolta, hamoduli, id_inserogato_padre,  
    nomeunità, annierogazione) 
    CorsoInFacolta(id, id_corsostudi, id_facolta)

    SEDI NO DUPLICATI
*/

select distinct sede
from corsostudi


	/*
	/*
    CorsoStudi(id, nome, codice, abbreviazione, durataAnni, sede, informativa) 
    Facolta(id, nome, codice, indirizzo, informativa, id_preside_persona, id_segreteria) 
    Insegn(id, nomeins, codiceins) 
    Discriminante(id, nome, descrizione) 
    InsErogato(id, annoaccademico, id_insegn, id_corsostudi, id_discriminante, modulo, discriminantemodulo, 
    nomemodulo, crediti, programma, id_facolta, hamoduli, id_inserogato_padre,  
    nomeunità, annierogazione) 
    CorsoInFacolta(id, id_corsostudi, id_facolta)    
*/
	Visualizzare solo i moduli degli insegnamenti erogati nel 2010/2011 nei corsi di studi della facoltà di 
	Economia.
	
	Si visualizzi il nome dell’insegnamento, il discriminante (attributo descrizione della tabella Discriminante), il 
	nome del modulo e l’attributo modulo. 
	Soluzione: ci sono 27 righe. 

	*/

select insegn.nomeins
from inserogato JOIN insegn ON insegn.id = inserogato.id_insegn
					JOIN facolta ON inserogato.id_facolta = facolta.id
where inserogato.annoaccademico = '2010/2011' AND
		facolta.nome = 'Economia' AND
		modulo > 0;


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
    CorsoStudi(id, nome, codice, abbreviazione, durataAnni, sede, informativa) 
    Facolta(id, nome, codice, indirizzo, informativa, id_preside_persona, id_segreteria) 
    Insegn(id, nomeins, codiceins) 
    Discriminante(id, nome, descrizione) 
    InsErogato(id, annoaccademico, id_insegn, id_corsostudi, id_discriminante, modulo, discriminantemodulo, 
    nomemodulo, crediti, programma, id_facolta, hamoduli, id_inserogato_padre,  
    nomeunità, annierogazione) 
    CorsoInFacolta(id, id_corsostudi, id_facolta)

    Visualizzare il nome e il discriminante (attributo descrizione della tabella Discriminante) 
	degli insegnamenti
	erogati nel 2009/2010 che non sono moduli o unità logistiche e che hanno 3, 5 o 12 crediti. 
	Si ordini il	risultato per discriminante.
*/

select distinct insegn.nomeins, discriminante.descrizione
from insegn join inserogato on inserogato.id_insegn = insegn.id
			join discriminante on discriminante.id = inserogato.id_discriminante
where inserogato.annoaccademico = '2009/2010' AND
		inserogato.crediti IN (3, 5, 12) AND
			inserogato.modulo = 0
order by discriminante.descrizione;



/*
    CorsoStudi(id, nome, codice, abbreviazione, durataAnni, sede, informativa) 
    Facolta(id, nome, codice, indirizzo, informativa, id_preside_persona, id_segreteria) 
    Insegn(id, nomeins, codiceins) 
    Discriminante(id, nome, descrizione) 
    InsErogato(id, annoaccademico, id_insegn, id_corsostudi, id_discriminante, modulo, discriminantemodulo, 
    nomemodulo, crediti, programma, id_facolta, hamoduli, id_inserogato_padre,  
    nomeunità, annierogazione) 
    CorsoInFacolta(id, id_corsostudi, id_facolta)

    peso maggiore > 9
*/

select  insegn.id, insegn.nomeins, discriminante.nome
from insegn join inserogato on inserogato.id_insegn = insegn.id
			join discriminante on discriminante.id = inserogato.id_discriminante
where inserogato.annoaccademico = '2008/2009' AND
		inserogato.crediti > 9 AND
			inserogato.modulo = 0
order by insegn.nomeins;


/*
    CorsoStudi(id, nome, codice, abbreviazione, durataAnni, sede, informativa) 
    Facolta(id, nome, codice, indirizzo, informativa, id_preside_persona, id_segreteria) 
    Insegn(id, nomeins, codiceins) 
    Discriminante(id, nome, descrizione) 
    InsErogato(id, annoaccademico, id_insegn, id_corsostudi, id_discriminante, modulo, discriminantemodulo, 
    nomemodulo, crediti, programma, id_facolta, hamoduli, id_inserogato_padre,  
    nomeunità, annierogazione) 
    CorsoInFacolta(id, id_corsostudi, id_facolta)

    
*/
select nomeins, discriminante.nome, crediti, annierogazione
from inserogato join insegn on insegn.id = inserogato.id_insegn
				join discriminante on discriminante.id = inserogato.id_discriminante
				join corsostudi on corsostudi.id = inserogato.id_corsostudi
where	inserogato.annoaccademico = '2010/2011' AND
		corsostudi.nome = 'Laurea in Informatica' AND
		inserogato.modulo = 0
order by nomeins



select MAX(InsErogato.crediti)
from inserogato
where inserogato.annoaccademico = '2010/2011'



select annoaccademico, MAX(crediti) as "Massimo", MIN(crediti) as "Minimo"
from inserogato
group by annoaccademico


select annoaccademico, corsostudi.id, SUM(crediti) as "Somma dei Crediti"
from inserogato JOIN corsostudi ON corsostudi.id = inserogato.id_corsostudi
where modulo = 0
group by annoaccademico, corsostudi.id


select corsostudi.nome, COUNT(*)
from inserogato JOIN corsostudi on corsostudi.id = inserogato.id_corsostudi
				JOIN facolta on facolta.id = inserogato.id_facolta
where  inserogato.annoaccademico = '2009/2010' AND 
		modulo = 0 AND 
		facolta.nome ILIKE '%scienze matematiche fisiche e naturali%'
group by corsostudi.nome

SELECT CS.nome, COUNT(*)
FROM InsErogato AS IE 
  JOIN CorsoStudi AS CS ON (IE.id_corsostudi = CS.id )
  JOIN CorsoInFacolta AS CIF ON (CIF.id_corsostudi = CS.id )
  JOIN Facolta AS F ON (CIF.id_facolta = F.id)
WHERE LOWER(F.nome) = 'scienze matematiche fisiche e naturali' AND
IE.modulo = 0 AND IE.annoaccademico = '2009/2010'
GROUP BY CS.nome;



explain select distinct nome, durataAnni
from inserogato join corsostudi on inserogato.id_corsostudi = corsostudi.id
where annoaccademico = '2010/2011' AND
		(crediti IN (4 ,6, 8, 10, 12) OR
			creditilab BETWEEN 10 AND 15)


select nome from corsostudi





