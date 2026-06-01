SET NULL ON

SET LIBRARY TO "c:\vfp9_mysql\prgs\librerias.prg"

PUBLIC string_cn

string_cn = Crear_Estruc_Conex_MySQL("USER_CONNECT")

PUBLIC cn

cn=SQLSTRINGCONNECT(string_cn)

SELECT * FROM "h:\pagos_saldosiniprov.dbf" WHERE !DELETED() INTO CURSOR pagp
GO top

SCAN
	codp=pagsini_cod
	cod=pag_codi
	sini=sini_cod
	imp=pagsini_imp
	par=IIF(pagsini_parci=.t.,1,0)
	SQLEXEC(cn,"insert into pagos_saldosiniprov values(?codp,?cod,?sini,?imp,?par);")
ENDSCAN
=MESSAGEBOX("Proceso terminado",0+64,"Aviso de Sistema")

cerrar_cursor("pagp")

SQLDISCONNECT(cn)
