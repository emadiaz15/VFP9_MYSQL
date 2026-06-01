SET NULL ON

SET LIBRARY TO "c:\vfp9_mysql\prgs\librerias.prg"

PUBLIC string_cn

string_cn = Crear_Estruc_Conex_MySQL("USER_CONNECT")

PUBLIC cn

cn=SQLSTRINGCONNECT(string_cn)

SELECT * FROM "h:\saldosiniprov.dbf" WHERE !DELETED() INTO CURSOR sinic
GO top

SCAN
	cod=sini_cod
	fec=sini_fech
	sal=prov_sal
	pag=sini_pag
	pro=prov_codi
	pdo=pagado
	anu=anulado
	SQLEXEC(cn,"insert into saldosiniprov values(?cod,?fec,?sal,?pag,?pro,?pdo,?anu);")
ENDSCAN
=MESSAGEBOX("Proceso terminado",0+64,"Aviso de Sistema")

cerrar_cursor("sinic")

SQLDISCONNECT(cn)