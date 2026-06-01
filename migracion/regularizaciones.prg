SET NULL ON

SET LIBRARY TO "c:\vfp9_mysql\prgs\librerias.prg"

PUBLIC string_cn

string_cn = Crear_Estruc_Conex_MySQL("USER_CONNECT")

PUBLIC cn

cn=SQLSTRINGCONNECT(string_cn)

SELECT * FROM "h:\regularizaciones.dbf" WHERE !DELETED() INTO CURSOR re
GO top

SCAN
	cod=reg_codi
	fec=reg_fech
	cnc=reg_conc
	imp=reg_impo
	cli=cli_codi
	det=reg_deta
	cta=ctacte
	SQLEXEC(cn,"insert into regularizaciones values(?cod,?fec,?cnc,?imp,?cli,?det,?cta);")
ENDSCAN
=MESSAGEBOX("Proceso terminado",0+64,"Aviso de Sistema")

cerrar_cursor("re")

SQLDISCONNECT(cn)