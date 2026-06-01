SET NULL ON

SET LIBRARY TO "c:\vfp9_mysql\prgs\librerias.prg"

PUBLIC string_cn

string_cn = Crear_Estruc_Conex_MySQL("USER_CONNECT")

PUBLIC cn

cn=SQLSTRINGCONNECT(string_cn)

SELECT * FROM "h:\recibos_facturas.dbf" WHERE !DELETED() INTO CURSOR fac
GO top

SCAN
	codf=recfac_codi
	cod=rec_codi
	fac=fac_codi
	imp=recfac_impo
	par=IIF(recfac_parci=.T.,1,0)
	SQLEXEC(cn,"insert into recibos_facturas values(?codf,?cod,?fac,?imp,?par);")
ENDSCAN
=MESSAGEBOX("Proceso terminado",0+64,"Aviso de Sistema")

cerrar_cursor("fac")

SQLDISCONNECT(cn)


