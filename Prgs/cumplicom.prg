parameter codc

x=0
y=0
ruticum = conectar_db(_screen.cn)
	SQLEXEC(ruticum,"select count(*) as x from compras_articulos where orden_codi=?codc;","curx")
	SQLEXEC(ruticum,"select count(*) as y from compras_articulos where orden_codi=?codc and artord_ent>=artord_cant;","cury")
desconectar_db(ruticum)
x=curx.x
y=cury.y
ruticum= conectar_db(_screen.cn)
	if x=y
		SQLEXEC(ruticum,"update compras set cumplido='S' where orden_codi=?codc;")
	ELSE
		SQLEXEC(ruticum,"update compras set cumplido='' where orden_codi=?codc;")
	ENDIF
desconectar_db(ruticum)
cerrar_cursor("curx")
cerrar_cursor("cury")
return