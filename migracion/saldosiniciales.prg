SET NULL ON

SET LIBRARY TO "c:\vfp9_mysql\prgs\librerias.prg"

PUBLIC string_cn

string_cn = Crear_Estruc_Conex_MySQL("USER_CONNECT")

PUBLIC cn

cn=SQLSTRINGCONNECT(string_cn)

SELECT * FROM "h:\saldosiniciales.dbf" WHERE !DELETED() INTO CURSOR sinic
GO top

SCAN
	cod=sini_cod
	fec=sini_fech
	cli=cli_codi
	sal=cli_sal
	pag=sini_pag
	anu=anulado
	pdo=pagado
	SQLEXEC(cn,"insert into saldosiniciales values(?cod,?fec,?cli,?sal,?pag,?anu,?pdo);")
ENDSCAN
=MESSAGEBOX("Proceso terminado",0+64,"Aviso de Sistema")

cerrar_cursor("sinic")

SQLDISCONNECT(cn)


