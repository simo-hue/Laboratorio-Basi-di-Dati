/*
    
*/
SELECT nome, città, giornochiusura
FROM Museo
WHERE città ILIKE 'Verona%'

/*
    
*/
SELECT titolo || ' ' || città
FROM Mostra
WHERE titolo ILIKE 'r%'

/*
    
*/
SELECT titolo || ' e rimangono ' || fine - CURRENT_DATE || ' Giorni'
FROM Mostra
WHERE fine > CURRENT_DATE;


select * from museo;
/*
    
*/
SELECT nome, orario_apertura, orario_chiusura, giornochiusura
FROM Museo
WHERE giornochiusura <> 'Martedì';
