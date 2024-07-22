-- 	evaluación de SQL 24/06/2024
-- recuerda que evaluamos el adecuado uso de variables y no debe quedar nada hardcodeado

use db_22244743_24062024;  # recordá quitar los [] por favor
# si se utiliza el nombre de la DB antes de la tabla, no es necesario hacer esto

#1
-- Crear las tablas Provincias y Localidades con sus correspondientes columnas, primary keys, 
-- foreign keys (si correspondiera) y su vinculación con la tabla Personas.
-- Insertar la provincia de Santa Fe, la localidad de Rosario y asociar todos los clientes y 
-- proveedores a dicha localidad.

CREATE TABLE `db_22244743_24062024`.`Provincias` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `provincia` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`id`));
  
CREATE TABLE `db_22244743_24062024`.`Localidades` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `localidad` VARCHAR(50) NOT NULL,
  `provincia_id` INT NOT NULL,
  PRIMARY KEY (`id`));

INSERT INTO `db_22244743_24062024`.`Provincias` (`provincia`) VALUES ("Santa Fe");
INSERT INTO `db_22244743_24062024`.`Localidades` (`Localidad`, `provincia_id`) VALUES ("Rosario", last_insert_id());

select last_insert_id() into @localidad_id;  

ALTER TABLE `db_22244743_24062024`.`Personas` 
ADD COLUMN `localidad_id` INT NULL AFTER `piso_dto_blk`;
# noten que como ya inserté la localidad, entonces puedo utilizar DEFAULT 1 y evitar hacer el UPDATE Personas SET localidad_id=1;

# si no establecieron el default para el campo localidad_id en la tabla Personas
UPDATE Personas SET localidad_id=1 where localidad_id is null;

#2
-- Insertar en las tablas correspondientes la información relativa al cliente dando de alta tus datos personales (o inventados):
-- Nombre y apellido
-- Calle y nro - Localidad
-- Tipo doc. DNI y nro de DNI
-- Condición de IVA: COnsumidor Final
-- Teléfono

set @nro_doc="30546671166";
INSERT INTO `db_22244743_24062024`.`Personas`
(`nro_doc`,
`razon_social`,
`tip_doc_ident_id`,
`tip_doc_resp_id`,
`localidad_id`)
VALUES (@nro_doc, "Universidad Tecnológica Nacional", 80, 4, 1);

INSERT INTO `db_22244743_24062024`.`Clientes` (`nro_doc`, `telefono`) VALUES (@nro_doc, "0341 448-0102");


#3
-- Insertar en las tablas correspondientes un ticket de compra con el siguiente detalle:
-- Cliente: insertado en el punto anterior
-- Fecha/Hora: la del momento
-- 2 azúcares
-- 1 yerba
-- Haz uso de variables para insertar el detalle del ticket, cálculos, etc.
-- Ayudín: primero insertar el ticket con importe total en 0, insertar los detalles del ticket, 
-- calcular el importe total a través de la suma de los importe parciales y actualizar el ticket.

INSERT INTO `db_22244743_24062024`.`Tickets`
(`cliente_id`,`fechora`,`importe_total`) VALUES (@nro_doc, now(), 0);
SET @ticket_id=(SELECT MAX(id) from `db_22244743_24062024`.`Tickets`);
SET @ticket_id=last_insert_id();
set @nro_correl=1;

# para los 2 de azúcar
SET @producto_id=(SELECT id FROM `db_22244743_24062024`.`Productos` where producto like "%Azúcar%" LIMIT 1);
SET @precio = (select precio from `db_22244743_24062024`.`Precios` where producto_id=@producto_id and fecha_vigencia <= now() order by fecha_vigencia DESC LIMIT 1);
set @cantidad=2;
INSERT INTO `db_22244743_24062024`.`DetallesTickets` () select @ticket_id, @nro_correl, @cantidad, @producto_id, @precio, @precio * @cantidad;

set @nro_correl=@nro_correl + 1;
# para la 1 de yerba
SET @producto_id=(SELECT id FROM `db_22244743_24062024`.`Productos` where producto like "%Yerba%" LIMIT 1);
SET @precio = (select precio from `db_22244743_24062024`.`Precios` where producto_id=@producto_id and fecha_vigencia <= now() order by fecha_vigencia DESC LIMIT 1);
set @cantidad=1;
INSERT INTO `db_22244743_24062024`.`DetallesTickets` () select @ticket_id, @nro_correl, @cantidad, @producto_id, @precio, @precio * @cantidad;

# ahora debo sumar los importes parciales y actualizar el total del ticket
SET @importe_total = (SELECT SUM(importe_parcial) FROM DetallesTickets where ticket_id = @ticket_id);
UPDATE Tickets SET importe_total=@importe_total where id = @ticket_id;

# otra forma de actualizar el importe total del ticket
UPDATE `db_22244743_24062024`.`Tickets` T 
INNER JOIN (
	SELECT SUM(importe_parcial) as sum_importe_total, ticket_id FROM `db_22244743_24062024`.`DetallesTickets` GROUP BY ticket_id ) DT ON DT.ticket_id = T.id
       SET T.importe_total = DT.sum_importe_total;


#4
-- Realizar un informe con el monto mínimo, el monto máximo y el valor del ticket promedio.
-- -------------------------------------------------------------------------------------
-- | Importe ticket menor monto | Importe ticket mayor monto | Importe ticket promedio |
-- -------------------------------------------------------------------------------------
-- | $xxxx.xx                   | $xxxx.xx                   | $xxxx.xx               |
-- -------------------------------------------------------------------------------------

SELECT 
concat("$", MIN(importe_total)) as "Importe del ticket de menor monto", 
concat("$", MAX(importe_total)) as "Importe del ticket de mayor monto", 
concat("$", AVG(importe_total)) as "Importe del ticket promedio" 
FROM `db_22244743_24062024`.`Tickets`;


#5
-- Informar los tickets cuyo importe total esté por encima del valor del ticket promedio.
-- -------------------------------------------------------------------------------------
-- | Nro de ticket | Nombre y apellido o Razón social | Fecha      | Importe total   |
-- -------------------------------------------------------------------------------------
-- | x             | xxxxxxxxxxxxxx                   | dd/mm/yyyy | $xxxx.xx        |
-- -------------------------------------------------------------------------------------
-- | x             | xxxxxxxxxxxxxx                   | dd/mm/yyyy | $xxxx.xx        |
-- -------------------------------------------------------------------------------------
-- 
-- 
-- -------------------------------------------------------------------------------------
-- | x             | xxxxxxxxxxxxxx                   | dd/mm/yyyy | $xxxx.xx        |
-- -------------------------------------------------------------------------------------

# usando subconsulta
SELECT 
id as "Nro de ticket", 
CONCAT(IFNULL(razon_social, CONCAT(nombre, " ", apellido))) as "Nombre y apellido o Razón social", 
DATE_FORMAT(fechora, "%d/%m/%Y") as "Fecha", concat("$ ", importe_total) as "Importe"
FROM `db_22244743_24062024`.`Tickets` T INNER JOIN `db_22244743_24062024`.`Personas` P ON T.cliente_id=P.nro_doc 
WHERE importe_total >= (SELECT AVG(importe_total) FROM `db_22244743_24062024`.`Tickets`) ORDER BY importe_total DESC;

# otro manera si quieren utilizar HAVING + subconsulta
SELECT 
id as "Nro de ticket", 
CONCAT(IFNULL(razon_social, CONCAT(nombre, " ", apellido))) as "Nombre y apellido o Razón social", 
DATE_FORMAT(fechora, "%d/%m/%Y") as "Fecha", sum(DT.importe_parcial) as Importe
FROM `db_22244743_24062024`.`DetallesTickets` DT INNER JOIN `db_22244743_24062024`.`Tickets` T ON DT.ticket_id=T.id 
INNER JOIN `db_22244743_24062024`.`Personas` P ON T.cliente_id=P.nro_doc GROUP BY DT.ticket_id
HAVING Importe >= (SELECT AVG(importe_total) FROM `db_22244743_24062024`.`Tickets`)  ORDER BY T.importe_total DESC;


#6
-- Informar los montos totales de los pedidos realizados a cada proveedor entre el 01/01/2023 y el 31/12/2023 
-- ordenadas por monto total en forma descendente.
-- -------------------------------------------------------------------------------------
-- | CUIT Proveedor | Nombre y apellido o Razón social | Monto total                 |
-- -------------------------------------------------------------------------------------
-- | xxxxxxxxxxx    | xxxxxxxxxxxxxx                   | $xxxx.xx                    |
-- -------------------------------------------------------------------------------------
-- | xxxxxxxxxxx    | xxxxxxxxxxxxxx                   | $xxxx.xx                    |
-- -------------------------------------------------------------------------------------
-- 
-- 
-- -------------------------------------------------------------------------------------
-- | xxxxxxxxxxx    | xxxxxxxxxxxxxx                   | $xxxx.xx                    |
-- -------------------------------------------------------------------------------------

SELECT PER.nro_doc as "CUIT", PER.razon_social as "Razón social", 
concat("$ ", sum(precio_uni_compra * cantidad)) as "Monto total"
FROM Pedidos PED INNER JOIN Proveedores PRO ON PED.nro_doc=PRO.nro_doc
INNER JOIN Personas PER on PRO.nro_doc=PER.nro_doc 
WHERE PED.fecha BETWEEN "2023-01-01" AND "2023-12-31" group by PRO.nro_doc
ORDER BY "Monto total" DESC;


#7
-- Mostrar la cantidad productos asociados a cada categoría, si una categoría no tuviera ningún producto 
-- asociado indicar 0, ordenar por cantidad en forma decreciente.
-- -------------------------------------------------------------------------------------
-- | Identificador | Categoría                         | Cantidad                      |
-- -------------------------------------------------------------------------------------
-- | 1             | xxxxxxxxxxxxxx                    | xx                            |
-- -------------------------------------------------------------------------------------
-- | 2             | xxxxxxxxxxxxxx                    | xx                            |
-- -------------------------------------------------------------------------------------
-- 
-- 
-- -------------------------------------------------------------------------------------
-- | n             | xxxxxxxxxxxxxx                    | 0                             |
-- -------------------------------------------------------------------------------------

SELECT C.id as "Indentificador", C.categoria as "Categoría", ifnull(count(P.id), 0) as "Cantidad"
FROM Categorias C LEFT JOIN Productos P on C.id=P.categoria_id GROUP BY C.id; 


-- FIN DEL EXAMEN
-- FIN DEL EXAMEN
-- FIN DEL EXAMEN