SET NULL ON

SET LIBRARY TO "c:\vfp9_mysql\prgs\librerias.prg"

PUBLIC string_cn

string_cn = Crear_Estruc_Conex_MySQL("USER_CONNECT")

PUBLIC cn

cn=SQLSTRINGCONNECT(string_cn)

SELECT * FROM "h:\histopagar.dbf" WHERE !DELETED() INTO CURSOR histcop
GO top

SCAN
	cod=histop_codi
	fec=histop_fecha
	imp=histop_impo
	SQLEXEC(cn,"insert into histopagar values(?cod,?fec,?imp);")
ENDSCAN
=MESSAGEBOX("Proceso terminado",0+64,"Aviso de Sistema")

cerrar_cursor("histcop")

SQLDISCONNECT(cn)