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


	-- Esercizio 1
	-- Trovare nome, cognome dei docenti che nell’anno accademico 2010/2011 erano docenti 
	-- in almeno due corsi di studio (vale a dire erano docenti in almeno due insegnamenti 
	-- o moduli A e B dove A è del corso C1 e B è del corso C2 con C1 <> C2).

*/

SELECT persona.id, persona.nome, persona.cognome 
FROM docenza join persona on persona.id = docenza.id_persona
				join inserogato i1 on i1.id = docenza.id_inserogato
					join corsostudi cs1 on cs1.id = i1.id_corsostudi
						join corsostudi cs2 on cs2.id = i1.id_corsostudi
WHERE i1.annoaccademico = '2010/2011' AND
		cs1.id <> cs2.id AND
		i1.crediti = 6;

/*
    Trovare per ogni periodo di lezione del 2010/2011 la cui 
	descrizione inizia con ’I semestre’ o ’Primo
	semestre’ il numero di occorrenze di insegnamento allocate in quel periodo. 
	Si visualizzi quindi:
	l’abbreviazione, il discriminante, inizio, fine e il conteggio richiesto ordinati 
	rispetto all’inizio e fine.
*/

SELECT periodolez.id, abbreviazione, discriminante, inizio, fine, COUNT(distinct )
FROM periododid join periodolez on periodolez.id = periododid.id
					join insinperiodo on insinperiodo.id_periodolez = periodolez.id
WHERE periododid.descrizione LIKE 'Primo semestre%' OR
		periododid.descrizione LIKE 'I semestre%' OR
GROUP BY periodolez.id











/*
	Trovare per ogni segreteria che serve almeno un corso di studi il numero di corsi 
	di studi serviti, riportando il
	nome della struttura, il suo numero di fax e il conteggio richiesto.	
*/


select strutturaservizio.nomestruttura, strutturaservizio.fax , COUNT(*)
from corsostudi JOIN strutturaservizio on corsostudi.id_segreteria = strutturaservizio.id
group by strutturaservizio.nomestruttura, strutturaservizio.fax 











