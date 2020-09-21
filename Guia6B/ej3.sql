/*3.1*/
select * from libro;
select * from editorial;
select * from factura;
select * from detalle_factura;
/*todo ok*/

/*3.2*/
/*con count*/
select codedit from libro
group by codedit
having count(codedit) = 1;

/*con calculo relacional*/
select codedit from libro
where libro.codedit is not null and not exists(select * from libro as l1 where libro.isbn <> l1.isbn and libro.codedit = l1.codedit);
/* para este faltaba sacar los que no son null y cambiar el cuantificador de distinto del isbn*/

/*3.3*/
select titulo, autor from libro
where isbn in (
    select isbn from detalle_factura group by isbn having sum(cantidad) >= all (
        select sum(cantidad) from detalle_factura group by isbn));

/*
casi casi llego pero me quede a media maquina para filtrar los mas vendidos
select titulo, autor, sum(cantidad) as acum from libro
join detalle_factura df on libro.isbn = df.isbn
group by df.isbn, titulo, autor
order by acum desc*/


/*3.4*/
select factura.codfact, to_char(factura.fecha, 'DD-MM-YYYY') from factura
join detalle_factura on factura.codfact = detalle_factura.codfact
where detalle_factura.isbn = (select isbn from libro
where precio <= all (select precio from libro));

/*3.5*/
select nombre from editorial, libro
where editorial.codedit = libro.codedit and  precio >= all (select precio from libro where libro.codedit is not null);

/*select nombre from editorial
join libro as l on editorial.codedit = l.codedit
where l = (select * from libro where precio >= all (select precio from libro where libro.codedit is not null))
    and editorial.codedit = l.codedit;*/

/*3.6*/
/*era un bardo esta*/
SELECT nombre, CAST( 0.20 * SUM(total) AS DECIMAL(10,2)) TOTAL FROM editorial,
(SELECT SUM(cantidad) * precio, codEdit FROM libro, detalle_factura
WHERE libro.ISBN = detalle_factura.ISBN
GROUP BY precio, codEdit) AS AA(total, codEdit)
WHERE AA.codEdit = editorial.codEdit
GROUP BY editorial.codEdit, nombre ORDER BY nombre DESC;

/*3.7*/
select codfact from detalle_factura
GROUP BY codfact
HAVING SUM(cantidad) >= ALL (SELECT SUM(cantidad)FROM detalle_factura GROUP BY codfact );
/*where detalle_factura.codfact = factura.codfact
group by factura.codfact
order by cant desc
limit 1*/

/*3.8*/
select codfact, sum(cantidad) as suma from detalle_factura
GROUP BY codfact
HAVING SUM(cantidad) >= ALL (SELECT SUM(cantidad)FROM detalle_factura GROUP BY codfact );

/*3.9*/
select distinct titulo from libro
join detalle_factura df on libro.isbn = df.isbn
join factura f on df.codfact = f.codfact
where f.fecha between '2015-09-15' and '2015-09-30' and df.codfact = f.codfact and df.isbn = libro.isbn;

/*3.10*/
/*de la bronca mire directo la solucion*/
SELECT libro.titulo, SUM(cantidad) AS CANTIDAD FROM libro, factura, detalle_factura
WHERE libro.isbn=detalle_factura.isbn
AND factura.codFact=detalle_factura.codFact
AND fecha= (SELECT MIN(f1.fecha)FROM detalle_factura d1, libro l1, factura f1
            WHERE d1.isbn=l1.isbn AND d1.codFact=f1.codFact
            AND EXTRACT(YEAR FROM fecha)= 2015
            AND EXTRACT(MONTH FROM fecha)= 9
            AND L1.TITULO='Blancanieves') + 6 GROUP BY libro.isbn, titulo;

/*3.11*/
SELECT 'PRIMEROS 7 DIAS', SUM(cantidad) AS Libros FROM detalle_factura
JOIN factura ON detalle_factura.codFact=factura.codFact
WHERE fecha BETWEEN '2015-09-01' AND '2015-09-07'
UNION
SELECT 'ÚLTIMOS 7 DIAS', SUM(cantidad) AS Libros FROM detalle_factura JOIN factura ON detalle_factura.codFact=factura.codFact
WHERE  fecha BETWEEN DATE('2015-09-24')AND DATE('2015-09-30');

/*3.12*/
SELECT DATE_PART('MONTH', AGE(MAX(fecha), '2015-01-01')) MESES, DATE_PART('DAY', AGE(MAX(fecha), '2015-01-01')) DIAS FROM factura
WHERE fecha BETWEEN '2015-09-01' AND '2015-09-30';

/*3.13*/
select nombre from editorial
where codedit in (
    select codedit from libro, detalle_factura
    where detalle_factura.isbn = libro.isbn
    group by libro.codedit
    having count(distinct codfact) = (select  count(*) from factura));

/*3.14*/
BEGIN;
UPDATE detalle_factura SET  ISBN = '15030109'  WHERE codFact= 1003;
SELECT nombre from editorial
where codedit in (
    select codedit from libro, detalle_factura
    where detalle_factura.isbn = libro.isbn
    group by libro.codedit
    having count(distinct codfact) = (select  count(*) from factura));
ROLLBACK;

/*ta ok salu2*/

/*3.15*/
SELECT titulo, factura.codFact, cast(100 * precio * cantidad / monto as decimal (6,2)) PORC FROM libro, detalle_factura, factura
WHERE libro.ISBN = detalle_factura.ISBN AND detalle_factura.codFact = factura.codFact AND precio * cantidad  <= 0.25 * monto
ORDER BY titulo DESC;

/*3.16*/
create view asciende(codFact, monto) as
    select codfact, CAST( SUM(cantidad * precio) as DECIMAL(5, 2) ) from detalle_factura
    JOIN libro ON detalle_factura.isbn = libro.isbn
    group by codfact;

update factura set monto = (select monto from asciende where factura.codfact = asciende.codFact);

drop view asciende;

select * from factura; /*estan los nuevos precios*/

/*3.17*/
select titulo, sum(cantidad) from libro, detalle_factura
where libro.isbn = detalle_factura.isbn
group by titulo
having sum(cantidad) <= all (select sum(cantidad) from libro, detalle_factura where libro.isbn = detalle_factura.isbn group by titulo);

/*3.18*/
select distinct factura.codfact from factura, detalle_factura d1, detalle_factura d2
where d1.codfact = factura.codfact and d2.codfact = factura.codfact and d1.nrolinea <> d2.nrolinea and d1.isbn = d2.isbn;

/*3.19*/
BEGIN;
INSERT INTO detalle_factura VALUES(1004, 3, '15030109', 5);
SELECT distinct factura.codfact from factura, detalle_factura d1, detalle_factura d2
where d1.codfact = factura.codfact and d2.codfact = factura.codfact and d1.nrolinea <> d2.nrolinea and d1.isbn = d2.isbn;
ROLLBACK;

/*ok*/

/*3.20*/
SELECT codFact FROM detalle_factura, libro
WHERE detalle_factura.ISBN = libro.ISBN
GROUP BY codFact
HAVING COUNT(DISTINCT COALESCE(codEdit, 'NULL')) = 1;

/*Lo siguiente no sirve:
  SELECT codFact FROM detalle_factura
  JOIN libro ON detalle_factura.ISBN = libro.ISBN
  GROUP BY codFact
  HAVING COUNT(DISTINCT codEdit) = 1*/

/*3.21*/
select nombre, pais,
case
    when codedit like 'BO%' then 'Boston'
    when codedit like 'WO%' then 'Waterloo'
    when codedit like 'XA%' then 'Desconocida'
    else 'No especificado'
end ciudad
from editorial;
