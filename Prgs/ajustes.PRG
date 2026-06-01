parameter art
string_cn= crear_estruc_conex_mysql("USER_CONNECT")
aju= conectar_db(string_cn)
	SQLEXEC(aju,"select a.*,b.* from ajustes a inner join ajustes_articulos b on a.aju_codi=b.aju_codi where b.art_codi=?art;")
desconectar_db(aju)
brow