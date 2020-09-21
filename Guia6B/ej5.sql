/*5.1*/
select * from alu;
select * from materia;
select * from profesor;
select * from examen;
/*todo ok*/

/*5.2*/
select nombre from alu
where exists(
    select * from materia where not exists(
        select * from examen where examen.nota >= 4 and materia.codigo = examen.codigo and alu.legajo = examen.legajo));

SELECT nombre FROM alu
WHERE legajo NOT IN (
    SELECT legajo FROM examen WHERE nota >= 4 GROUP BY legajo HAVING COUNT(*) = (
        SELECT COUNT(*) FROM materia ));

/*5.3*/
select profesor.legajo from profesor
where not exists(select * from alu where not exists(select * from examen where profesor.legajo = examen.legprof and alu.legajo
     = examen.legajo));

/*5.4*/
select legprof, codigo from examen
group by legprof, codigo
having count(distinct legajo) = (select count(*) from alu);

/*5.5*/
select distinct e1.nroacta from examen e1, examen e2, profesor p1, profesor p2
where e1.nroacta = e2.nroacta and e1.legprof <> e2.legprof;

/*5.6*/
UPDATE examen SET legProf = 239 WHERE nroActa IN (144, 111);
COMMIT;

UPDATE examen SET nroActa = 777 WHERE nroActa = 144 AND codigo= 20;
COMMIT;
UPDATE examen SET nota = 2 WHERE nroActa = 676 AND legajo= 12500;
COMMIT;

BEGIN;
INSERT INTO examen VALUES (10500, 329, 3, '2013-04-20', 20, 131);
INSERT INTO examen VALUES (10500, 329, 2, '2013-10-14', 20, 163);
INSERT INTO examen VALUES (12500, 329, 3, '2013-10-14', 20, 163);
INSERT INTO profesor VALUES(777, 'Sonia Cheng', '1975-09-21');
COMMIT;

select * from profesor;
select * from examen;

/*todo ok*/

/*5.7*/
SELECT DISTINCT legprof FROM examen
WHERE legajo IN (SELECT legajo FROM examen
                    WHERE nota >= 4
                    GROUP BY legajo
                    HAVING COUNT(DISTINCT codigo) = (SELECT COUNT(*) FROM materia));

/*5.8*/
select distinct legajo, (sum(nota)/count(*)) as promedio from examen
where legajo in (SELECT legajo FROM examen
                    WHERE nota >= 4
                    GROUP BY legajo
                    HAVING COUNT(DISTINCT codigo) = (SELECT COUNT(*) FROM materia))
group by examen.legajo;

/*5.9*/
SELECT DISTINCT nombre, nroActa FROM examen
join profesor on examen.legProf = profesor.legajo
WHERE examen.legajo IN (
    SELECT legajo FROM (
        SELECT legajo FROM examen
        WHERE nota >= 4
        GROUP BY legajo
        HAVING COUNT(DISTINCT codigo)=(
            SELECT COUNT(*) FROM materia)) AS aux)
        AND fecha = (
            SELECT MAX(fecha) FROM examen ex1
            WHERE ex1.legajo = examen.legajo);
