/*2.1*/
select * from alumno;
select * from curso;
select * from inscripcion;

/*2.2*/
select legajo from inscripcion
group by legajo
having count( distinct codigo) >= 2;

/*dato, pareceria que no se puede usar where con el count, tiene que ser con having*/

/*2.3*/
/*hice primero con count*/
select nombre from alumno
join inscripcion on alumno.legajo = inscripcion.legajo
group by inscripcion.legajo, alumno.nombre
having count(distinct codigo) = (select count(distinct codigo) from curso);

/*aca lo que paso fue que levanta from inscripcion y joinea con alumno, al reves nomas*/

/*la de algebra relacional te la debo, fue en parte por paja de pensarla*/
SELECT nombre FROM alumno
WHERE NOT EXISTS (SELECT * FROM curso
                  WHERE NOT EXISTS(SELECT * FROM inscripcion
                  WHERE alumno.legajo = inscripcion.legajo AND inscripcion.codigo = curso.codigo));

/*2.4*/
begin;
insert into inscripcion values (4, 30002, 2013);
insert into inscripcion values (4, 30003, 2013);
commit;

select * from inscripcion; /*todo ok*/

/*2.5*/
select distinct anio from inscripcion as i1
where not exists(
    select * from alumno, inscripcion
    where sexo = 'F'
        and alumno.legajo = inscripcion.legajo
        and inscripcion.anio = i1.anio
    );
/*copiada derecho de la respuesta*/

/*2.6*/
SELECT anio FROM inscripcion
GROUP BY anio
HAVING COUNT(*) >= ALL (SELECT COUNT(*) FROM inscripcion
                        GROUP BY anio)
/* aca va la mia, medio sacada de la galera y anda a chequearla sabes donde no?
   select anio from inscripcion
    group by anio
    limit 1*/

/*2.7*/
select nombre, count(codigo) as total from inscripcion
join alumno on inscripcion.legajo = alumno.legajo
group by alumno.legajo, nombre
order by nombre;
/*es una boludez pero no me tira los resultados igual que en el ejemplo >:(; UPDATE lo habia ordenado la sol jeje*/
/*                                              ^
                                                |
                                                |
                    En estas dos, tener en cuenta que se ordena por legajo por repeticion de nombre
                                                |
                                                |                                                                   */
/*2.8   <---------------------------------------|                                                                   */
select nombre, count(distinct codigo) as SINREPETIR from inscripcion
join alumno on inscripcion.legajo = alumno.legajo
group by alumno.legajo, nombre
order by nombre;

/*2.9*/
select nombre, count(distinct codigo) as SINREPETIR from inscripcion
join alumno on inscripcion.legajo = alumno.legajo
where alumno.carrera = 'electronica'
group by alumno.legajo, nombre
order by nombre;

/*2.10*/
select distinct carrera, count(*) from alumno as a1
where a1.carrera = carrera
group by a1.carrera;

/*2.11*/
/*2.12*/
/*2.13*/
/*2.14*/