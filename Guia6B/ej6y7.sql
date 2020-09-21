/*6.1*/
. R0(X,Y) <- Tabla1(Persona, ParienteDe)

. para i perteneciente a N>0 Ri(X,Y) <- Ri-1(X,Y) U {Persona, ParienteDe2 | (existe ParienteDe) Ri-1(Persona, ParienteDe) ^ Ri-1(ParienteDe, ParienteDe2)}

/*6.2 y 6.3*/
WITH RECURSIVE
Familiar(X, Y) AS
(SELECT persona, ParienteDe FROM tabla1
UNION
SELECT familiar.X, tabla1.ParienteDe
FROM Familiar, tabla1
WHERE familiar.Y = tabla1.Persona)
SELECT X, Y FROM Familiar;

/*--------------------------*/

/*7.1*/
. R0(X,Y) <- Tabla1(Persona, HizoNegociosCon)
. para i perteneciente a N>0 Ri(X,Y) <- Ri-1(X,Y) U {(Persona, SocioDe) | (existe h) Ri-1(Persona, h) ^ Tabla2(h, socioDe)}

/*7.2*/
WITH  RECURSIVE
Negocios(X, Y) AS
(SELECT persona, hizoNegociosCon FROM  Tabla1
UNION
SELECT Negocios.X, tabla2.SocioDe
FROM Negocios, tabla2
WHERE Negocios.Y = tabla2.Persona)
SELECT X, Y FROM Negocios

/*7.3*/
WITH RECURSIVE
ClausuraAcuerdo(X, Y) AS
(SELECT persona, hizoNegociosCon FROM table1
UNION
SELECT ClausuraAcuerdo.X, table1.hizoNegociosCon
FROM ClausuraAcuerdo, table1
WHERE ClausuraAcuerdo.Y = table1.Persona),
ClausuraSociedad(X,Y) AS
(Select x, y from ClausuraAcuerdo
UNION
SELECT ClausuraSociedad.x, Table2.SocioDe
FROM ClausuraSociedad, Table2
WHERE ClausuraSociedad.y = table2.Persona)
SELECT X, Y FROM ClausuraSociedad
