SET NULL ON

SET LIBRARY TO "c:\vfp9_mysql\prgs\librerias.prg"

PUBLIC string_cn

string_cn = Crear_Estruc_Conex_MySQL("USER_CONNECT")

PUBLIC cn

cn=SQLSTRINGCONNECT(string_cn)

SELECT * FROM "h:\provincias.dbf" WHERE !DELETED() INTO CURSOR provmysql
GO top

SCAN
	cod=provi_codi
	nom=ALLTRIM(provi_nomb)
	SQLEXEC(cn,"insert into provincias values(?cod,?nom);")
ENDSCAN
=MESSAGEBOX("Proceso terminado",0+64,"Aviso de Sistema")

cerrar_cursor("provmysql")

SQLDISCONNECT(cn)
