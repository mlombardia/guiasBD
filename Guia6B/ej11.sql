/*1.1*/
select * from jugador;
select * from penalizacion; /*ta todo ok*/

/*1.2*/
select max(monto) from penalizacion;

/*1.3*/
select max(monto) as MAXIMO_14 from penalizacion
where fecha between date('01/01/2014') AND date('12/31/2014');

/*1.4*/
select sum(monto), nombre from jugador,penalizacion
where jugador.codigo = penalizacion.codigo
group by jugador.codigo,nombre
order by nombre;


/*1.5*/
select (sum(monto)/8.5) as DOLAR, nombre from jugador,penalizacion
where jugador.codigo = penalizacion.codigo
group by jugador.codigo, nombre
order by nombre;

/*1.6*/
select nombre, coalesce(to_char(min(fecha), 'YYYY-MM-DD'),'-') as fecha from jugador
left outer join penalizacion on jugador.codigo = penalizacion.codigo
group by jugador.codigo,nombre;

/*varias cosas: - group por codigo y nombre, no nombre y fecha;
                - con solo min(fecha) pareceria ir, pero para que aparezca null en vez de - hay que poner el coalesce
                - to_char para la fecha?
                - al left le agrega outer?*/

/*1.7*/
select nombre, coalesce(to_char(min(fecha), 'DD-MM-YYYY'),'-') as fecha from jugador
left outer join penalizacion on jugador.codigo = penalizacion.codigo
group by jugador.codigo,nombre;

/*1.8*/
create view EQUIPO
as
    select jugador.codigo, nombre, coalesce(to_char(max(fecha), 'DD-MM-YYYY'),'-') as ultima, coalesce(sum(monto),0) as acumulado
    from jugador
    left outer join penalizacion on jugador.codigo = penalizacion.codigo
    group by jugador.codigo, jugador.nombre
    order by jugador.codigo;

select * from EQUIPO;

/*unica cosa que vi distinta es que le pone los alias ya a la altura del create view*/

/*1.9 y 1.10*/

update equipo set nombre= 'Villares' where nombre='Vilar';
update equipo set acumulado = 155 where nombre='Cardoso';
/*no se ejecuta directamente, como todo viene de una junta no deja*/

/*1.11*/
insert into penalizacion values ('R07', '2014-11-30', 200);
select * from equipo;

/*1.12*/
select nombre from EQUIPO
where acumulado < (select sum(monto) from penalizacion where extract(year from fecha) = 2014) / (select count(*) from jugador);

/*1.13*/
select nombre from EQUIPO
where acumulado <
(select sum(monto) from penalizacion where extract(year from fecha) = 2014)
    /
(select count(distinct codigo) from penalizacion where extract(year from fecha) = 2014);

/*1.14*/
select nombre as codigo,
case
    when acumulado = 0 then 'TRANQUILO'
    when acumulado < 130 then 'NORMAL'
    when acumulado >=130 and acumulado < 260 then 'TEMPERAMENTAL'
    else 'VIOLENTO'
end categoria
from EQUIPO;