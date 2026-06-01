SET NULL ON

SET LIBRARY TO "c:\vfp9_mysql\prgs\librerias.prg"

PUBLIC string_cn

string_cn = Crear_Estruc_Conex_MySQL("USER_CONNECT")

PUBLIC cn

cn=SQLSTRINGCONNECT(string_cn)

SELECT * FROM "h:\remitos_transportes.dbf" WHERE !DELETED() INTO CURSOR remtmysql
GO top

SCAN
	cod=rem_codi
	tra=tran_codi
	fle=ALLTRIM(flete_lugent)
	flc=ALLTRIM(flete_cargo)
	SQLEXEC(cn,"insert into remitos_transportes values(?cod,?tra,?fle,?flc);")
ENDSCAN
=MESSAGEBOX("Proceso terminado",0+64,"Aviso de Sistema")

cerrar_cursor("remtmysql")

SQLDISCONNECT(cn)