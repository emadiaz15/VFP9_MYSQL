SET NULL ON

SET LIBRARY TO "c:\vfp9_mysql\prgs\librerias.prg"

PUBLIC string_cn

string_cn = Crear_Estruc_Conex_MySQL("USER_CONNECT")

PUBLIC cn

cn=SQLSTRINGCONNECT(string_cn)

SELECT * FROM "h:\tiposgastos.dbf" WHERE !DELETED() INTO CURSOR tipg
GO top

SCAN
	cod=tipgas_codi
	gas=tipgas_desc
	SQLEXEC(cn,"insert into tiposgastos values(?cod,?gas);")
ENDSCAN
=MESSAGEBOX("Proceso terminado",0+64,"Aviso de Sistema")

cerrar_cursor("tipg")

SQLDISCONNECT(cn)