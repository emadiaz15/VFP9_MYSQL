SET NULL ON

SET LIBRARY TO "c:\vfp9_mysql\prgs\librerias.prg"

PUBLIC string_cn

string_cn = Crear_Estruc_Conex_MySQL("USER_CONNECT")

PUBLIC cn

cn=SQLSTRINGCONNECT(string_cn)

SELECT * FROM "h:\recibos_saldosiniciales.dbf" WHERE !DELETED() INTO CURSOR sinic
GO top

SCAN
	codr=recsini_cod
	rec=rec_codi
	cod=sini_cod
	imp=recsini_imp
	parci=IIF(recsini_parci=.T.,1,0)
	SQLEXEC(cn,"insert into recibos_saldosiniciales values(?cod,?rec,?cod,?imp,?parci);")
ENDSCAN
=MESSAGEBOX("Proceso terminado",0+64,"Aviso de Sistema")

cerrar_cursor("sinic")

SQLDISCONNECT(cn)