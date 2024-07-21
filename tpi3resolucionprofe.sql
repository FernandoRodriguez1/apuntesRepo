use `en_dos_ruedas_GALLO-20416`;
ALTER TABLE `Productos` 
CHANGE COLUMN `meses_gtia` `meses_gtia` INT NOT NULL ;

# 1
INSERT INTO Productos(descripcion, meses_gtia, stock_inicial, umbral_stock) VALUES(
"Cubiertas Kevlar Gravel 700x42", 0, 10, 2
);

SET @cod_cubierta=last_insert_id();

INSERT INTO PreciosHistoricos VALUES(@cod_cubierta, NOW(), 5000);

# 2
# ATENCIÓN: con NOW() la diferencia mínima es de un segundo, cuando corro lineas consecutivas del 
# script puede que intente meter dos registros en el mismo segundo
INSERT INTO PreciosHistoricos VALUES(@cod_cubierta, DATE_SUB(NOW(), INTERVAL 1 SECOND), 5100);

# 3
# notar que el precio es a partir de las 0hs, entonces puedo meter un date en un datetime
INSERT INTO PreciosHistoricos VALUES(@cod_cubierta, "2023-12-31", 5100);

# 4
INSERT INTO Productos(descripcion, meses_gtia, stock_inicial, umbral_stock) VALUES(
"Cámara 700x42", 0, 20, 5
);
SELECT @cod_camara:=last_insert_id();
INSERT INTO PreciosHistoricos VALUES(@cod_camara, NOW(), 1000);

# 5
INSERT INTO Productos(descripcion, meses_gtia, stock_inicial, umbral_stock) VALUES(
"Kit cámara + cubierta", 0, 10, 0
);
SET @cod_kit=last_insert_id();
INSERT INTO PreciosHistoricos VALUES(@cod_kit, NOW(), 5500);

INSERT INTO Kits VALUES(@cod_kit, @cod_cubierta, 1);
INSERT INTO Kits VALUES(@cod_kit, @cod_camara, 1);

# 6
SET @cod_CS=5;
INSERT INTO TiposDocumentos VALUES(@cod_CS, "Consumidor Final", "Responsabilidad");


SET @cod_DNI=96;
INSERT INTO TiposDocumentos VALUES(@cod_DNI, "DNI", "Identificación");

SET @nro_doc=22244743;
INSERT INTO Clientes VALUES(
	@nro_doc,
    "Cristián", "Gallo", NULL, "+5493415866666", "Zeballos", "1371", NULL, "Rosario", @cod_DNI, @cod_CS
);

# 7
INSERT INTO FormasDePago VALUES (NULL, "Contado");
SET @formapago_id=last_insert_id();


ALTER TABLE `Carritos` 
CHANGE COLUMN `cod_factura` `cod_factura` INT NULL ;

INSERT INTO Carritos VALUES (NULL, NOW(), NULL, @formapago_id, @nro_doc);
SET @carrito_id=last_insert_id();
SET @id_detalle=1;

ALTER TABLE `DetallesCarritos` 
CHANGE COLUMN `precio_unitario` `precio_unitario` DECIMAL(9,2) NOT NULL ;

select @precio:=(SELECT precio FROM PreciosHistoricos WHERE cod_producto=@cod_cubierta and fec_hora_alta<=NOW() order by fec_hora_alta DESC LIMIT 1);
INSERT INTO DetallesCarritos VALUES (
	@carrito_id,
    @id_detalle,
    @cod_cubierta,
    1,
    @precio
);

SET @id_detalle=@id_detalle + 1;
select @precio:=(SELECT precio FROM PreciosHistoricos WHERE cod_producto=@cod_camara and fec_hora_alta<=NOW() order by fec_hora_alta DESC LIMIT 1);

INSERT INTO DetallesCarritos VALUES (
	@carrito_id,
    @id_detalle,
    @cod_camara,
    1,
    @precio
);

SET @id_detalle=@id_detalle + 1;
select @precio:=(SELECT precio FROM PreciosHistoricos WHERE cod_producto=@cod_kit and fec_hora_alta<=NOW() order by fec_hora_alta DESC LIMIT 1);

INSERT INTO DetallesCarritos VALUES (
	@carrito_id,
    @id_detalle,
    @cod_kit,
    1,
    @precio
);

# insertado el carrito, la frutilla del postre sería decrementar los stocks de los productos, pero como utilizamos tecnología perfecta en este curso
# el stock podemos calcularlo cuando querramos, si queremos decremantarlo haríamos:
UPDATE Productos SET stock_inicial=stock_inicial - 1 WHERE cod_producto=@cod_cubierta;
UPDATE Productos SET stock_inicial=stock_inicial - 1 WHERE cod_producto=@cod_camara;
UPDATE Productos SET stock_inicial=stock_inicial - 1 WHERE cod_producto=@cod_kit;