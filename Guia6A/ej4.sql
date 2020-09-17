/*4.1*/
SELECT DISTINCT nombre FROM cliente, pedido, producto
WHERE ciudad = 'Capital Federal' AND descripcion = 'Pagina 12'
AND cliente.nroCli = pedido.nroCli and pedido.codProd =producto.codProd;

/* aca dejo la mia pero me enrosque mal, la de la sol es mas simple
select nombre from cliente
join pedido on cliente.nrocli = pedido.nrocli
join producto on pedido.codprod = producto.codprod
where cliente.ciudad = 'Capital Federal' and pedido.codprod = (select producto.codprod from producto where producto.descripcion='Pagina 12')*/

/*4.2*/
select c1.nombre, c2.nombre from cliente c1, cliente c2
where c1.ciudad = c2.ciudad and c1.nrocli < c2.nrocli;

/*4.3*/
select nroprov as col1, nombre, ciudad from prov
where ciudad = 'Capital Federal'

union

select nrocli, nombre, ciudad from cliente
where ciudad = 'Capital Federal';


/*4.4*/
select nroprov from prov
where ciudad = 'Capital Federal'

union

select nrocli from cliente
where ciudad = 'Capital Federal'

/*porque los 2 tienen 10, y no se repite*/
