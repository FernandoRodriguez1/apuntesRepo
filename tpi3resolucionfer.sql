
#TPI3
-- EJERCICIO1
-- Insertar el producto Cubierta Kevlar Gravel 700x42, 
-- con 0 meses de garantía, un stock inical de 10 y un umbral 
-- de stock de 2 y precio de $5000 (utilizar la función NOW).

INSERT INTO `en_dos_ruedas_[rodriguez]-[50.597]`.`productos`
(`descripcion`,
`meses_gtia`,
`stock_inicial`,
`umbral_stock`)
VALUES
(`Cubierta Kevlar Gravel 700x42`,
0,
10,
2);
set @cod_cubierta=last_insert_id();

INSERT INTO precioshistoricos VALUES(@cod_cubierta,now(),5000);

-- EJERCICIO 2
-- Inserta una actualización de precio
-- para la cubierta, ahora vale $5100 
-- (utilizar la función NOW).

INSERT INTO PreciosHistoricos
 VALUES(@cod_cubierta, DATE_SUB(NOW(), INTERVAL 1 SECOND), 5100);
 
 -- EJERCICIO 3
 -- Inserta otra actualización de precio para 
 -- la cubierta pero esta vez a partir del 
 -- 31/12/2023 la cubierta valdrá $5500.

INSERT INTO PreciosHistoricos
 VALUES(@cod_cubierta,"2023-12-31", 5500);
 
 -- EJERCICIO 4
 -- Insertar el producto Cámara 700x42,
 -- con 0 meses de garantía, un stock inical de 20 y 
 -- un umbral de stock de 5 y precio de $1000.

INSERT INTO `en_dos_ruedas_[rodriguez]-[50.597]`.`productos`
(`descripcion`,
`meses_gtia`,
`stock_inicial`,
`umbral_stock`)
VALUES
("Camara 700x42",
0,
20,
5);
set @cod_camara=last_insert_id();

INSERT INTO precioshistoricos
VALUES(@cod_camara, now(),1000);

-- EJERCICIO 5
-- Insertar el producto Kit cámara + cubierta compuesto por 
-- 1 cubierta + 1 cámara, con 
-- 0 meses de garantía, un stock inicial de 10 y
--  un precio de $5500.

INSERT INTO `en_dos_ruedas_[rodriguez]-[50.597]`.`productos`
(`descripcion`,
`meses_gtia`,
`stock_inicial`,
`umbral_stock`

)
VALUES
("Kit camara + cubierta",
0,
10,
0);
set @cod_kit=last_insert_id();

INSERT INTO `en_dos_ruedas_[rodriguez]-[50.597]`.`kits`
(`cod_producto`,
`cod_producto_rel`,
`cantidad`)
VALUES
(
@cod_kit,
@cod_cubierta,
1);
INSERT INTO `en_dos_ruedas_[rodriguez]-[50.597]`.`kits`
(
`cod_producto`,
`cod_producto_rel`,
`cantidad`)
VALUES
(
@cod_kit,
@cod_camara,
1);
INSERT INTO `en_dos_ruedas_[rodriguez]-[50.597]`.`precioshistoricos`
(`cod_producto`,
`fec_hora_alta`,
`precio`)
VALUES
(@cod_kit,
now(),
5500);

-- EJERCICIO 6
-- Insertar tus datos como cliente.

set @cod_CS=5;
INSERT INTO `en_dos_ruedas_[rodriguez]-[50.597]`.`tiposdocumentos`
(`id_tip_doc`,
`descripcion_doc`,
`tipo`)
VALUES
(@cod_CS,
"Consumidor Final",
"Responsabilidad");

set @cod_dni=96;
INSERT INTO `en_dos_ruedas_[rodriguez]-[50.597]`.`tiposdocumentos`
(`id_tip_doc`,
`descripcion_doc`,
`tipo`)
VALUES
(@cod_dni,
"DNI",
"Identificacion");

set @nro_doc=32456789;
INSERT INTO `en_dos_ruedas_[rodriguez]-[50.597]`.`clientes`
(`nro_doc`,
`nombre`,
`apellido`,
`telefono`,
`celular`,
`calle`,
`nro`,
`piso_dpto`,
`localidad`,
`tip_doc_iden`,
`tip_doc_resp`)
VALUES
(
@nro_doc,
"Fernando",
"Rodriguez",
null,
"3412345678",
"sdasdsa",
"1222",
null,
"Rosario",
@cod_dni,
@cod_CS);

-- EJERCICIO 7
-- Crear tu carrito con la forma de pago "contado" 
-- e inserta en él, 1 cubierta, 1 cámara y un kit 
-- (utiliza variables para almacenar el nro de carrito y poder 
-- insertar el detalle, buscar 
-- el precio actual, etc)

INSERT INTO formasdepago
VALUES(NULL, "Contado");

set @cod_pago_efectivo=last_insert_id();

INSERT INTO `en_dos_ruedas_[rodriguez]-[50.597]`.`carritos`
(
`fecha_hora`,
`cod_factura`,
`forma_pago`,
`nro_doc`)
VALUES
(
now(),
NULL,
@cod_pago_efectivo,
@nro_doc);

SET @cod_carrito= last_insert_id();


set @id_detalle=1;
select @precio:=(SELECT precio FROM PreciosHistoricos WHERE cod_producto=@cod_cubierta and fec_hora_alta<=NOW() order by fec_hora_alta DESC LIMIT 1);

INSERT INTO `en_dos_ruedas_[rodriguez]-[50.597]`.`detallescarritos`
(`id_carrito`,
`id_detalle`,
`cod_producto`,
`cantidad`,
`precio_unitario`)
VALUES
(@cod_carrito,
@id_detalle,
@cod_cubierta,
1,
@precio);


set @id_detalle=@id_detalle+1;
select @precio:=(SELECT precio FROM PreciosHistoricos WHERE cod_producto=@cod_camara and fec_hora_alta<=NOW() order by fec_hora_alta DESC LIMIT 1);
INSERT INTO `en_dos_ruedas_[rodriguez]-[50.597]`.`detallescarritos`
(`id_carrito`,
`id_detalle`,
`cod_producto`,
`cantidad`,
`precio_unitario`)
VALUES
(@cod_carrito,
@id_detalle,
@cod_camara,
1,
@precio);

set @id_detalle=@id_detalle+1;
select @precio:=(SELECT precio FROM PreciosHistoricos WHERE cod_producto=@cod_kit and fec_hora_alta<=NOW() order by fec_hora_alta DESC LIMIT 1);
INSERT INTO `en_dos_ruedas_[rodriguez]-[50.597]`.`detallescarritos`
(`id_carrito`,
`id_detalle`,
`cod_producto`,
`cantidad`,
`precio_unitario`)
VALUES
(@cod_carrito,
@id_detalle,
@cod_kit,
1,
@precio);

UPDATE Productos SET stock_inicial=stock_inicial - 1 WHERE cod_producto=@cod_cubierta;
UPDATE Productos SET stock_inicial=stock_inicial - 1 WHERE cod_producto=@cod_camara;
UPDATE Productos SET stock_inicial=stock_inicial - 1 WHERE cod_producto=@cod_kit;







 

