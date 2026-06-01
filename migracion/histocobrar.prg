SET NULL ON

SET LIBRARY TO "c:\vfp9_mysql\prgs\librerias.prg"

PUBLIC string_cn

string_cn = Crear_Estruc_Conex_MySQL("USER_CONNECT")

PUBLIC cn

cn=SQLSTRINGCONNECT(string_cn)

SELECT * FROM "h:\histocobrar.dbf" WHERE !DELETED() INTO CURSOR histcob
GO top

SCAN
	cod=histoc_codi
	fec=histoc_fecha
	imp=histoc_impo
	SQLEXEC(cn,"insert into histocobrar values(?cod,?fec,?imp);")
ENDSCAN
=MESSAGEBOX("Proceso terminado",0+64,"Aviso de Sistema")

cerrar_cursor("histcob")

SQLDISCONNECT(cn)
