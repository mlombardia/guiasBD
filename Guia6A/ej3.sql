/*3.1*/
select titulo, coalesce(autor,'-') as autor, precio from libro
where genero = 'Infantil';

/*SELECT titulo, COALESCE(autor,'-'), precio FROM libro WHERE genero = 'Infantil'*/

/*3.2*/
select titulo, editorial.nombre from libro, editorial
where libro.codedit = editorial.codedit and libro.precio < 27.5;

/*3.3*/
select titulo from libro
order by titulo;

/*3.4*/
select titulo, nombre from libro, editorial
where libro.codedit = editorial.codedit and editorial.pais = 'Canada';

/*3.5*/
select distinct detalle_factura.isbn, titulo from libro, detalle_factura
where libro.isbn = detalle_factura.isbn and libro.precio > 50

/*SELECT ISBN, titulo FROM libro WHERE precio > 50 AND ISBN IN (SELECT ISBN FROM detalle_factura)*/

/*3.6*/
select nombre from editorial
join libro on editorial.codedit = libro.codedit
where libro.genero = 'Computacion' and editorial.pais = 'USA';

/*3.7*/
select distinct titulo from libro
join detalle_factura df on libro.isbn = df.isbn /*mas comodo df jeje*/
join factura f on df.codfact = f.codfact
where df.isbn = libro.isbn and df.codfact = f.codfact and f.fecha between date('09/01/2015') AND date('09/10/2015')
order by titulo;

/*para fechas puse between '2015-09-01' and '2015-09-10' pero esta me parecio mas piola y comoda*/

