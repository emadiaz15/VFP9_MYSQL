SET NULL ON

SET LIBRARY TO "c:\vfp9_mysql\prgs\librerias.prg"

PUBLIC string_cn

string_cn = Crear_Estruc_Conex_MySQL("USER_CONNECT")

PUBLIC cn

cn=SQLSTRINGCONNECT(string_cn)

SELECT * FROM "h:\desc_articulos_proveedores.dbf" WHERE !DELETED() INTO CURSOR dacart
GO top

SCAN
	cod=dap_codi
	artp=artpro_codi
	dap=ALLTRIM(dap_desc)
	SQLEXEC(cn,"insert into desc_articulos_proveedores values(?cod,?artp,?dap);")
ENDSCAN
=MESSAGEBOX("Proceso terminado",0+64,"Aviso de Sistema")

cerrar_cursor("dacart")

SQLDISCONNECT(cn)