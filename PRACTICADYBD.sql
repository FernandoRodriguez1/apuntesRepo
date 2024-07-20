#EJERCICIO1 PRACTICA 2
SET @dni_busca="29345777";
select P.nombre, P.apellido, C.sueldo, P.dni
FROM personas P 
inner join contratos C on P.dni=C.dni
where(P.dni=@dni_busca);
#EJERCICIO2
SELECT C.dni, C.nro_contrato, C.fecha_incorporacion, C.fecha_solicitud, 
ifnull(C.fecha_caducidad, "Sin Fecha")
FROM contratos C 
inner join empresas E on C.cuit = E.cuit
where(E.razon_social ="Viejos amigos" or E.razon_social="Traigame Eso")
order by(fecha_incorporacion and E.razon_social);
#EJERCICIO3
SELECT E.razon_social, E.direccion, E.e_mail, CA.desc_cargo,SE.anios_experiencia
FROM empresas E 
INNER JOIN solicitudes_empresas SE on E.cuit=SE.cuit
INNER JOIN cargos CA on SE.cod_cargo = CA.cod_cargo
ORDER BY SE.fecha_solicitud, CA.desc_cargo;
#EJERCICIO4
SELECT P.dni, P.nombre, P.apellido, T.desc_titulo
FROM personas P 
INNER JOIN personas_titulos PTI on P.dni=PTI.dni
INNER JOIN titulos T on PTI.cod_titulo=T.cod_titulo
where(T.cod_titulo = "4" or T.cod_titulo="6" or T.cod_titulo="8")
order by (P.apellido);
#EJERCICIO5
SELECT P.nombre, P.apellido, T.desc_titulo
from personas P 
INNER JOIN personas_titulos PTI on P.dni=PTI.dni
INNER JOIN titulos T on PTI.cod_titulo=T.cod_titulo
order by (P.apellido);
#EJERCICIO6
SELECT concat(P.nombre,"",P.apellido), concat("tiene como referencia a ", ifnull(A.persona_contacto, "No tiene contacto")),
concat("cuando trabajo en ", EM.razon_social)
FROM personas P 
INNER JOIN antecedentes A on P.dni=A.dni
INNER JOIN empresas EM on A.cuit=EM.cuit
where(A.persona_contacto="Armando Esteban Quito" or A.persona_contacto="Felipe Rojas" or A.persona_contacto=null);

#EJERCICIO 10
#Listar las empresas solicitantes mostrando la razón social y fecha de cada solicitud,
#y descripción del cargo solicitado. Si hay empresas que no hayan solicitado que salga la
#leyenda: Sin Solicitudes en la fecha y en la descripción del cargo.

SELECT E.cuit, E.razon_social, ifnull(SE.fecha_solicitud, "Sin solicitudes") AS "Fecha Solicitud", ifnull(C.desc_cargo,"Sin solicitudes") AS "Cargo"
FROM empresas E 
LEFT JOIN solicitudes_empresas SE on E.cuit=SE.cuit
LEFT JOIN cargos C ON SE.cod_cargo=C.cod_cargo;

#EJERCICIO 11
#Mostrar para todas las solicitudes la razón social de la empresa solicitante, el cargo
#y si se hubiese realizado un contrato los datos de la(s) persona(s).
SELECT E.cuit, 
       E.razon_social, 
       C.desc_cargo, 
       IFNULL(P.dni, 'Sin Contrato') AS dni, 
       IFNULL(P.apellido, 'Sin Contrato') AS apellido, 
       IFNULL(P.nombre, 'Sin Contrato') AS nombre
FROM empresas E 
INNER JOIN solicitudes_empresas SE ON E.cuit = SE.cuit
INNER JOIN cargos C ON SE.cod_cargo = C.cod_cargo
LEFT JOIN contratos CON ON SE.cuit=CON.cuit and SE.cod_cargo=CON.cod_cargo and SE.fecha_solicitud=CON.fecha_solicitud
LEFT JOIN personas P ON CON.dni = P.dni;

#12
#Mostrar para todas las solicitudes la razón social de la empresa solicitante, el cargo de
#las solicitudes para las cuales no se haya realizado un contrato.
SELECT E.cuit, razon_social, CA.desc_cargo
FROM solicitudes_empresas SE
INNER JOIN empresas E ON E.cuit=SE.cuit
INNER JOIN cargos CA ON CA.cod_cargo=SE.cod_cargo
LEFT JOIN contratos C ON C.cuit=SE.cuit and C.cod_cargo=SE.cod_cargo
where nro_contrato is null;

#PRACTICA3
#EJERCICIO1
#Para aquellos contratos que no hayan terminado calcular la fecha de caducidad
#como la fecha de solicitud más 30 días (no actualizar la base de datos). 
#Función ADDDATE
SELECT nro_contrato, fecha_incorporacion, fecha_finalizacion_contrato, ifnull(fecha_caducidad, ADDDATE(fecha_solicitud, INTERVAL 30 DAY)) AS "Fecha Caducidad"
FROM contratos WHERE fecha_caducidad IS NULL;

#EJERCICIO2
#Mostrar los contratos. Indicar nombre y apellido de la persona,
#razón social de la empresa fecha de inicio del contrato y
#fecha de caducidad del contrato. Si la fecha no ha
#terminado mostrar “Contrato Vigente”. Función IFNULL

SELECT nro_contrato, razon_social, apellido, nombre, fecha_incorporacion,
ifnull(fecha_caducidad, "Contrato Vigente") AS "fin contrato"
from empresas EM
INNER JOIN contratos CO ON EM.cuit=CO.cuit
INNER JOIN personas PE ON CO.dni=PE.dni ORDER BY nro_contrato;

-- Ejercicio 3
-- Para aquellos contratos 
-- que terminaron antes de la fecha de finalización,
-- indicar la
-- cantidad de días que
-- finalizaron antes de tiempo. Función DATEDIFF

SELECT C.nro_contrato, C.fecha_incorporacion, C.fecha_finalizacion_contrato, C.fecha_caducidad,
C.sueldo, C.porcentaje_comision, C.dni, C.cuit, C.cod_cargo, C.fecha_solicitud,
datediff(C.fecha_finalizacion_contrato, C.fecha_caducidad)
FROM contratos C  WHERE C.fecha_caducidad < C.fecha_finalizacion_contrato;

-- ejercicio 4

SELECT E.cuit, E.razon_social, E.direccion,  COM.anio_contrato,
COM.mes_contrato, COM.importe_comision, adddate(curdate(), INTERVAL 2 MONTH)
FROM empresas E
INNER JOIN contratos CO ON E.cuit=CO.cuit
INNER JOIN comisiones COM ON CO.nro_contrato=COM.nro_contrato
where fecha_pago is null;

-- Ejercicio 5

SELECT PER.nombre, PER.apellido, PER.fecha_nacimiento, day(fecha_nacimiento) as "DIA",month(fecha_nacimiento) as "MES", year(fecha_nacimiento) as "AÑO"
FROM personas PER;



-- PRACTICA 4
 -- EJERCICIO1
 -- Mostrar comisiones pagadas por la empresa traigame eso
 
 SELECT E.razon_social, sum(COM.importe_comision)
 FROM comisiones COM 
 INNER JOIN contratos CO ON COM.nro_contrato=CO.nro_contrato
 INNER JOIN empresas E ON CO.cuit=E.cuit
 where COM.fecha_pago IS NOT NULL and CO.cuit = "30-21008765-5";
 
 -- Ejercicio2
 -- Ídem 1) pero para todas las empresas.
SELECT E.razon_social, sum(COM.importe_comision)
 FROM comisiones COM 
 INNER JOIN contratos CO ON COM.nro_contrato=CO.nro_contrato
 INNER JOIN empresas E ON CO.cuit=E.cuit
 where COM.fecha_pago IS NOT NULL
 group by razon_social;

-- EJERCICIO3
-- Mostrar el promedio, desviación estándar y varianza del puntaje de las
-- evaluaciones de entrevistas, por tipo de evaluación y entrevistador. Ordenar por promedio
-- en forma ascendente y luego por desviación estándar en forma descendente

SELECT nombre_entrevistador, cod_evaluacion, AVG(resultado), STDDEV(resultado),variance(resultado)
from entrevistas E
inner join entrevistas_evaluaciones EV on E.nro_entrevista=EV.nro_entrevista
GROUP BY cod_evaluacion, nombre_entrevistador
order by 3,5 desc;

-- EJERCICIO 4
-- Ídem 3) pero para Angélica Doria, con promedio mayor a 71. Ordenar por código
-- de evaluación.

SELECT nombre_entrevistador, cod_evaluacion, AVG(resultado), STDDEV(resultado),variance(resultado)
from entrevistas E
inner join entrevistas_evaluaciones EV on E.nro_entrevista=EV.nro_entrevista
WHERE  nombre_entrevistador="Angelica Doria"
GROUP BY cod_evaluacion, nombre_entrevistador
having avg(resultado) > 71
order by cod_evaluacion;

-- EJERCICIO 5
-- 
SELECT E.nombre_entrevistador, count(*) as "cantidad de entrevistas"
from entrevistas E
WHERE month(fecha_entrevista) = 10 and year(fecha_entrevista) = 2014
group by nombre_entrevistador;

-- EJERCICIO 6
SELECT nombre_entrevistador, cod_evaluacion, count(*) as "cantidad de entrevistas", AVG(resultado), STDDEV(resultado)
from entrevistas E
inner join entrevistas_evaluaciones EV on E.nro_entrevista=EV.nro_entrevista
GROUP BY cod_evaluacion, nombre_entrevistador
having avg(resultado) > 71
order by 3;

-- EJERCICIO 7
SELECT nombre_entrevistador, cod_evaluacion, count(*) as "cantidad de entrevistas", AVG(resultado), STDDEV(resultado)
from entrevistas E
inner join entrevistas_evaluaciones EV on E.nro_entrevista=EV.nro_entrevista
GROUP BY cod_evaluacion, nombre_entrevistador
having count(*)>1
order by 3;

-- EJERCICIO 8
SELECT CON.nro_contrato, count(*) as total, count(IFNULL(COM.fecha_pago, NULL)) as pagadas, 
count(*) - count(IFNULL(COM.fecha_pago, NULL)) as "a pagar"
FROM contratos CON 
INNER JOIN comisiones COM on CON.nro_contrato=COM.nro_contrato
GROUP BY CON.nro_contrato;

-- EJERCICIO 9
SELECT CON.nro_contrato, count(*) as total, (count(IFNULL(COM.fecha_pago, NULL))) /count(*) * 100 as pagadas, 
(count(*) - count(IFNULL(COM.fecha_pago, NULL))) / count(*) * 100 as "a pagar"
FROM contratos CON INNER JOIN comisiones COM on CON.nro_contrato=COM.nro_contrato
GROUP BY CON.nro_contrato;

-- EJERCICIO 11
SELECT E.cuit, E.razon_social, count(*)
from empresas E
INNER JOIN solicitudes_empresas SE on E.cuit=SE.cuit
group by E.cuit;

-- EJERCICIO 12
SELECT E.cuit, E.razon_social,SE.cod_cargo, count(*)
from empresas E
INNER JOIN solicitudes_empresas SE on E.cuit=SE.cuit
GROUP BY SE.cuit, SE.cod_cargo;

-- ejercicio 15
SELECT C.cod_cargo, C.desc_cargo, count(*) as "Cantidad de Solicitudes"
from cargos C
left join solicitudes_empresas SE ON C.cod_cargo=SE.cod_cargo
group by C.cod_cargo
HAVING count(*)<2;

-- PRACTICA 5
-- ejercicio3

SELECT E.cuit, E.razon_social, avg(importe_comision)
from comisiones COM
inner join contratos CO on COM.nro_contrato=CO.nro_contrato
inner join empresas E on CO.cuit=E.cuit
GROUP BY E.cuit
HAVING AVG(COM.importe_comision) > (SELECT AVG(importe_comision) FROM `comisiones` COM 
INNER JOIN `contratos` CON ON COM.nro_contrato=CON.nro_contrato
INNER JOIN `empresas` EMP on CON.cuit=EMP.cuit where EMP.razon_social like "Tr%igame eso");

-- Ejercicio4
SELECT distinct EMP.razon_social, PER.nombre, PER.apellido, CON.nro_contrato, month(CON.fecha_incorporacion), 
YEAR(CON.fecha_incorporacion), COM.importe_comision FROM `comisiones` COM 
INNER JOIN `contratos` CON ON COM.nro_contrato=CON.nro_contrato
INNER JOIN `empresas` EMP on CON.cuit=EMP.cuit 
INNER JOIN `personas` PER on PER.dni=CON.dni
where COM.fecha_pago is not null and 
COM.importe_comision < (SELECT AVG(importe_comision) FROM `comisiones`);

-- Ejercicio 5
SELECT E.razon_social, avg(COM.importe_comision)
FROM comisiones COM
inner join contratos CO ON COM.nro_contrato=CO.nro_contrato
inner join empresas E ON CO.cuit=E.cuit
group by E.cuit
HAVING AVG( COM.importe_comision) > (SELECT AVG(importe_comision) FROM `comisiones`);

