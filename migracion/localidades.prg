SET NULL ON

SET LIBRARY TO "c:\vfp9_mysql\prgs\librerias.prg"

PUBLIC string_cn

string_cn = Crear_Estruc_Conex_MySQL("USER_CONNECT")

PUBLIC cn

cn=SQLSTRINGCONNECT(string_cn)

SELECT * FROM "h:\localidades.dbf" WHERE !DELETED() INTO CURSOR locamysql
GO top

SCAN
	cod=loca_codi
	nom=ALLTRIM(loca_nomb)
	pro=provi_codi
	cpc=cp_codi
	zon=zona_codi
	SQLEXEC(cn,"insert into localidades values(?cod,?nom,?pro,?cpc,?zon);")
ENDSCAN
=MESSAGEBOX("Proceso terminado",0+64,"Aviso de Sistema")

cerrar_cursor("locamysql")

SQLDISCONNECT(cn)
