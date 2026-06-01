SET NULL ON

SET LIBRARY TO C:\VFP9_MYSQL\Prgs\librerias.prg

PUBLIC string_cn

string_cn = Crear_Estruc_Conex_MySQL("USER_CONNECT")

PUBLIC cn

cn=SQLSTRINGCONNECT(string_cn)

SELECT * FROM "H:\ajustes_articulos.dbf" WHERE !DELETED() INTO CURSOR aju
GO top

SCAN
	cod=aju_codi
	art=art_codi
	aaj=artaju_cant
	SQLEXEC(cn,"insert into ajustes_articulos values(?cod,?art,?aaj);")
ENDSCAN
=MESSAGEBOX("Proceso terminado",0+64,"Aviso de Sistema")

cerrar_cursor("aju")

SQLDISCONNECT(cn)