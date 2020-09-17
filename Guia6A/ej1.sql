/*1.1*/
select codigo,fecha from penalizacion
where fecha >= '2015-01-10' and fecha <= '2015-12-31';

/*1.2*/
select distinct nombre from jugador
join penalizacion on jugador.codigo = penalizacion.codigo;

/*1.3*/
select nombre from jugador
where codigo not in (select codigo from penalizacion);

/*1.4*/
select nombre, penalizacion.fecha  from jugador
left join penalizacion on penalizacion.codigo = jugador.codigo
order by nombre,fecha;

/*1.5*/
delete from jugador where nombre = 'ANdradE'; /*no se borro ninguna, sera por case sensitive?*/

/*1.6*/
select * from penalizacion; /*tiene 7 tuplas*/
delete from jugador where nombre = 'Andrade';
select * from penalizacion;/*ahora tiene 5*/

/*1.7*/
select * from jugador
where telefono like '4314%'
order by telefono desc;