/*
   Esercizio 1
	Si assume che la tabella Museo possa essere aggiornata da applicazioni diverse, non sincronizzate fra loro.
	Scrivere una transazione che aggiunga un museo e dimostrare cosa succede se due applicazioni aggiungono
	lo stesso museo nello stesso istante usando lo schema della transazione proposta. 
*/
BEGIN
INSERT INTO Museo (nome, città, indirizzo, numerotelefono, giornochiusura, prezzo, sitointernet) VALUES ('Sound Dreamer', 'Verona' ,'via pinco pallo', '3347985325', 'MER', 99.99, 'https://sounddreamers.com');
END;

BEGIN
INSERT INTO Museo (nome, città, indirizzo, numerotelefono, giornochiusura, prezzo, sitointernet) VALUES ('Sound Dreamer', 'Verona' ,'via pinco pallo', '3347985325', 'MER', 99.99, 'https://sounddreamers.com');
END;






/*
    Esercizio 2
	Si assuma che una transazione deve visualizzare i prezzi dei musei di Verona che hanno parte decimale
	diversa da 0 e, poi, aggiornare tali prezzi del 10% arrotondando alla seconda cifra decimale. L’altra
	transazione (concorrente) deve aggiornare il prezzo dei musei di Verona aumentandoli del 10% e
	arrotondando alla seconda cifra decimale.
*/
BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;
	SELECT * FROM Museo
	WHERE prezzo <> ceil ( prezzo ) AND città ILIKE 'Verona';
	
	UPDATE Museo SET prezzo = round( prezzo * 1.10, 2 )
	WHERE prezzo <> ceil ( prezzo ) AND città ILIKE 'Verona' ;
COMMIT;

BEGIN;
	UPDATE Museo SET prezzo = round ( prezzo * 1.10, 2 )
	WHERE città ILIKE 'Verona';
COMMIT;







	
select * from Mostra;
/*
   Esercizio 3
	In una transazione si deve inserire una nuova mostra al museo di Castelvecchio di Verona con prezzo
	d’ingresso a 40 euro e prezzo ridotto a 20. Nell’altra transazione (concorrente) si deve calcolare il prezzo
	medio delle mostre di Verona prima considerando solo i prezzi ordinari e, in un’interrogazione separata,
	considerando solo i prezzi ridotti. 
*/
BEGIN;
	INSERT INTO Mostra (titolo, inizio, fine, museo, città, prezzointero, prezzoridotto) VALUES ('Sound Dreamer','2027-01-01', '2027-07-01', 'CastelVecchio', 'Verona', 40, 20);
	
END;

BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;
	SELECT AVG(prezzointero) as media_prezzo_intero
	FROM mostra
	WHERE città ILIKE 'Verona'
	GROUP BY città;

	SELECT AVG(prezzoridotto) as media_prezzo_ridotto
	FROM mostra
	WHERE città ILIKE 'Verona'
	GROUP BY città;
END;







	
/*
  Esercizio 4
	In una transazione si deve aumentare il prezzo intero di tutte le mostre di Verona del 10% mentre, nell’altra,
	si devono ridurre i prezzi ridotti di tutte le mostre del 5%. In entrambi i casi, l’importo finale si deve
	arrotondare alla seconda cifra decimale.  
*/
BEGIN
 UPDATE Mostra WHERE città ILIKE 'Verona' SET prezzo = prezzo * 1.10
END;

BEGIN

END;




/*
   Esercizio 5
	In una transazione, calcolare la media dei prezzi dei musei di Vicenza ed aggiungere un nuovo museo a
	Verona (’Museo moderno’) con prezzo uguale alla media calcolata. In un’altra transazione calcolare la media
	dei prezzi dei musei di Verona e aggiungere un nuovo museo a Vicenza con prezzo uguale alla media
	calcolata sui musei di Verona.
	Si segnala che:
	1. Con SELECT si possono anche creare colonne con valori costanti.
	Esempio: SELECT ’Museo Moderno’, ’Verona’, ecc FROM ...
	2. INSERT accetta di inserire anche risultati ottenuti da SELECT interne.
	Esempio: INSERT INTO Museo (nome, citta, ...) SELECT ’Museo Moderno’, ’Verona’, ... FROM... 
*/
BEGIN
	CREATE TEMP VIEW media AS SELECT AVG(prezzoridotto) as media_prezzo_ridotto
	FROM mostra
	WHERE città ILIKE 'Vicenza';

	INSERT INTO Museo (nome, città, indirizzo, numerotelefono, giornochiusura, prezzo, sitointernet) VALUES ('Museo Moderno', 'Verona', 'Umberti', '324234', 'SAB', SELECT AVG(prezzoridotto) as media_prezzo_ridotto
	FROM mostra
	WHERE città ILIKE 'Vicenza';);
END;

select * from museo;
BEGIN

END;
