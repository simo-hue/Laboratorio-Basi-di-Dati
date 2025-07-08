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






















