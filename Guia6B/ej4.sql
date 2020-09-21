/*4.1*/
select * from prov;
select * from producto;
select * from cliente;
select * from pedido;
/*ok*/

/*4.2*/
SELECT  DISTINCT nombre FROM prov, pedido
WHERE prov.nroProv = pedido.nroProv
GROUP BY prov.nroProv, nombre
HAVING COUNT ( DISTINCT nroCli) >= ALL ( SELECT COUNT(DISTINCT nroCli)FROM pedido GROUP BY nroProv);

/*aca notar que CANTIDAD DE PEDIDOS no quiere decir CANTIDAD DE CLIENTES*/

/*4.3*/
select distinct nombre from prov, pedido
where prov.nroprov = pedido.nroprov and not exists(
    select * from pedido p1, producto
    where p1.codprod = producto.codprod and pedido.nroprov = p1.nroprov and producto.genero = 'Ingles');

/*4.4*/
SELECT DISTINCT nombre, direccion, ciudad FROM cliente
JOIN pedido ON cliente.nroCli = pedido.nroCli
WHERE fecha = (SELECT MIN(fecha) FROM pedido);

/*4.5*/
SELECT DISTINCT nombre, direccion, ciudad FROM cliente
JOIN pedido ON cliente.nroCli = pedido.nroCli
WHERE fecha = (SELECT MIN(fecha) FROM pedido join producto on pedido.codprod = producto.codprod where producto.genero = 'Chismes');

/*4.6*/
select distinct nombre, genero from (select nrocli from pedido, producto where pedido.codprod=producto.codprod group by nrocli having count(distinct genero)=1) as auxi(cod), cliente,pedido, producto
where cod = cliente.nrocli and cliente.nrocli = pedido.nrocli and producto.codprod = pedido.codprod;

/*4.7*/
select distinct cl1.nombre, cl2.nombre, p1.fecha from cliente cl1, cliente cl2, pedido p1, pedido p2
where cl1.nrocli = p1.nrocli and cl2.nrocli = p2.nrocli and Cl1.nrocli < cl2.nrocli and p1.fecha = p2.fecha;
/*habia que sacar lo de p1.codprod = p2.codprod, no pedian EL MISMO*/

/*4.8*/
/*con los activos*/
select nombre, sum(cantidad) from cliente, pedido
where pedido.nrocli = cliente.nrocli
group by cliente.nombre
having sum(cantidad) > (select (sum(total)/count(*)) as promedio from (select distinct nombre, sum(cantidad) as total from cliente
join pedido p on cliente.nrocli = p.nrocli
group by nombre
order by total desc) as lista);

/*tiro la de la sol
  SELECT nombre, SUM(cantidad) CANT
FROM cliente JOIN pedido ON cliente.nroCli = pedido.nroCli
GROUP BY cliente.nroCli, nombre
HAVING SUM(cantidad) > (SELECT AVG(v)
FROM (SELECT CAST( SUM(cantidad) AS decimal(5,2))
FROM pedido
GROUP BY nroCli) AS auxi(v))*/

/*con los no activos incluidos*/
select nombre, sum(cantidad) from cliente, pedido
where pedido.nrocli = cliente.nrocli
group by cliente.nombre
having sum(cantidad) > (select (sum(total)/count(*)) as promedio from (select distinct nombre, sum(cantidad) as total from cliente
left outer join pedido p on cliente.nrocli = p.nrocli
group by nombre
order by total desc) as lista);

/*
SELECT nombre, SUM(cantidad)
FROM cliente JOIN pedido ON cliente.nroCli = pedido.nroCli
GROUP BY cliente.nroCli, nombre
HAVING SUM(cantidad) >
(SELECT AVG(v)
FROM (SELECT CAST( SUM(COALESCE(cantidad, 0)) AS decimal(5,2))
FROM cliente LEFT OUTER JOIN pedido
ON cliente.nroCli = pedido.nroCli
GROUP BY cliente.nroCli) AS auxi(v)
)*/

/*4.9*/
update pedido set nroprov = (select nroprov from prov where nombre='Distribuidora PPP')
where nroprov = (select nroprov from prov where nombre='Importaciones ABC') and codprod in (
    select codprod from producto where descripcion in ('Revista Gente', 'Pagina 12')
    );

select * from pedido;  /*todo joya*/

/*4.10*/
SELECT nombre FROM prov
WHERE nroProv IN (SELECT prov.nroProv FROM pedido, producto
                    WHERE pedido.nroProv = prov.nroProv AND pedido.codProd = producto.codProd
                    GROUP BY prov.nroProv
                    HAVING COUNT(DISTINCT genero) > 2)