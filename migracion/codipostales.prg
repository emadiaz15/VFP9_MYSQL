SET NULL ON

SET LIBRARY TO "c:\vfp9_mysql\prgs\librerias.prg"

PUBLIC string_cn

string_cn = Crear_Estruc_Conex_MySQL("USER_CONNECT")

PUBLIC cn

cn=SQLSTRINGCONNECT(string_cn)

SELECT * FROM "h:\codipostales.dbf" WHERE !DELETED() INTO CURSOR cpmysql
GO top

SCAN
	cod=cp_codi
	nro=cp_nro
	SQLEXEC(cn,"insert into codipostales values(?cod,?nro);")
ENDSCAN
=MESSAGEBOX("Proceso terminado",0+64,"Aviso de Sistema")

cerrar_cursor("cpmysql")

SQLDISCONNECT(cn)