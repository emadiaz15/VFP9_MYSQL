SET NULL ON

SET LIBRARY TO "c:\vfp9_mysql\prgs\librerias.prg"

PUBLIC string_cn

string_cn = Crear_Estruc_Conex_MySQL("USER_CONNECT")

PUBLIC cn

cn=SQLSTRINGCONNECT(string_cn)

SELECT * FROM "h:\desc_articulos_clientes.dbf" WHERE !DELETED() INTO CURSOR dacart
GO top

SCAN
	cod=dac_codi
	artc=artcli_codi
	dac=ALLTRIM(dac_desc)
	SQLEXEC(cn,"insert into desc_articulos_clientes values(?cod,?artc,?dac);")
ENDSCAN
=MESSAGEBOX("Proceso terminado",0+64,"Aviso de Sistema")

cerrar_cursor("dacart")

SQLDISCONNECT(cn)