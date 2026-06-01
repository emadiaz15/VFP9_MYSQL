SET NULL ON

SET LIBRARY TO "c:\vfp9_mysql\prgs\librerias.prg"

PUBLIC string_cn

string_cn = Crear_Estruc_Conex_MySQL("USER_CONNECT")

PUBLIC cn

cn=SQLSTRINGCONNECT(string_cn)

SELECT * FROM "h:\rubros.dbf" WHERE !DELETED() INTO CURSOR aju
GO top

SCAN
	cod=rub_codi
	rub=ALLTRIM(rub_desc)
	SQLEXEC(cn,"insert into rubros values(?cod,?rub);")
ENDSCAN
=MESSAGEBOX("Proceso terminado",0+64,"Aviso de Sistema")

cerrar_cursor("aju")

SQLDISCONNECT(cn)