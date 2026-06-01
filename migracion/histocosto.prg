SET NULL ON

SET LIBRARY TO "c:\vfp9_mysql\prgs\librerias.prg"

PUBLIC string_cn

string_cn = Crear_Estruc_Conex_MySQL("USER_CONNECT")

PUBLIC cn

cn=SQLSTRINGCONNECT(string_cn)

SELECT * FROM "h:\histocosto.dbf" WHERE !DELETED() INTO CURSOR histoc
GO top
LOCAL con
con=0
SCAN
	con=con+1
	cod=con
	fec=histo_fech
	cto=histo_costo
	ctov=histo_ctovta
	arp=artpro_codi
	mon=ALLTRIM(moneda)
	SQLEXEC(cn,"insert into histocosto values(?cod,?fec,?cto,?ctov,?arp,?mon);")
ENDSCAN
=MESSAGEBOX("Proceso terminado",0+64,"Aviso de Sistema")

cerrar_cursor("histoc")

SQLDISCONNECT(cn)