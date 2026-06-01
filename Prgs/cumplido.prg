parameter codp
x=0
y=0
ruticum = conectar_db(_screen.cn)
	SQLEXEC(ruticum,"select count(*) as x from pedidos_articulos where ped_codi=?codp;","curx")
	SQLEXEC(ruticum,"select count(*) as y from pedidos_articulos where ped_codi=?codp and artped_ent>=artped_cant;","cury")
desconectar_db(ruticum)
x=curx.x
y=cury.y
ruticum= conectar_db(_screen.cn)
	if x=y
		SQLEXEC(ruticum,"update pedidos set cumplido='S' where ped_codi=?codp;")
	ELSE
		SQLEXEC(ruticum,"update pedidos set cumplido='' where ped_codi=?codp;")
	ENDIF
desconectar_db(ruticum)

cerrar_cursor("curx")
cerrar_cursor("cury")
return