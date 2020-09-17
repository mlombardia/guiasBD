/*2.1*/
select distinct nombre from alumno
join inscripcion on alumno.legajo = inscripcion.legajo
where inscripcion.anio = 2014;

/*2.2*/
select distinct i1.legajo from inscripcion i1, inscripcion i2
where i1.legajo = i2.legajo and i1.codigo <> i2.codigo;

/*2.3*/
select nombre from curso
where codigo not in (select codigo from inscripcion where legajo = (select legajo from alumno where alumno.nombre = 'Lopez, Ana'));

/*2.4*/
select distinct alumno.nombre from alumno
join inscripcion on alumno.legajo = inscripcion.legajo
join curso on inscripcion.codigo = curso.codigo
where alumno.legajo=inscripcion.legajo and inscripcion.codigo = curso.codigo and curso.nombre like 'Programacion%';