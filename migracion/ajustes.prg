SET NULL ON

SET LIBRARY TO C:\VFP9_MYSQL\Prgs\librerias.prg

PUBLIC string_cn

string_cn = Crear_Estruc_Conex_MySQL("USER_CONNECT")

PUBLIC cn

cn=SQLSTRINGCONNECT(string_cn)

SELECT * FROM "h:\ajustes.dbf" WHERE !DELETED() INTO CURSOR aju
GO top

SCAN
	cod=aju_codi
	fec=aju_fech
	conc=aju_conc
	obs=aju_observ
	SQLEXEC(cn,"insert into ajustes values(?cod,?fec,?conc,?obs);")
ENDSCAN
=MESSAGEBOX("Proceso terminado",0+64,"Aviso de Sistema")

cerrar_cursor("aju")

SQLDISCONNECT(cn)