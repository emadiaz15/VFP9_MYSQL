cn= conectar_db(_screen.cn)

SQLEXEC(cn,"call fusibles();","cur_fusi")

SELECT cur_fusi
GO top

SCAN
	SQLEXEC(cn,"select CAST(arpdes_codi+1 as DECIMAL(8,0)) as arpdes_codi from articulos_proveedores_descuentos order by arpdes_codi desc limit 1;","codi")
	IF RECCOUNT("codi")>0
		SQLEXEC(cn,"insert into articulos_proveedores_descuentos values(?codi.arpdes_codi,?cur_fusi.artpro_codi,4,1);")
	ELSE
		SQLEXEC(cn,"insert into articulos_proveedores_descuentos values(1,?cur_fusi.artpro_codi,4,1);")
	ENDIF
ENDSCAN

SQLEXEC(cn,"select * from articulos_proveedores_descuentos order by arpdes_codi;","cur_final")

BROWSE

cerrar_cursor("cur_fusi")
cerrar_cursor("codi")
cerrar_cursor("cur_final")

desconectar_db(cn)
