SET NULL ON

SET LIBRARY TO "c:\vfp9_mysql\prgs\librerias.prg"

PUBLIC string_cn

string_cn = Crear_Estruc_Conex_MySQL("USER_CONNECT")

PUBLIC cn

cn=SQLSTRINGCONNECT(string_cn)

SELECT * FROM "h:\sucbancos.dbf" WHERE !DELETED() INTO CURSOR sucursales
GO top

SCAN
	cod=suc_codi
	nom=ALLTRIM(suc_nomb)
	dom=ALLTRIM(suc_domi)
	ban=ban_codi
	suc=suc_bansuc
	SQLEXEC(cn,"insert into sucbancos values(?cod,?nom,?dom,?ban,?suc);")
ENDSCAN
=MESSAGEBOX("Proceso terminado",0+64,"Aviso de Sistema")

cerrar_cursor("sucursales")

SQLDISCONNECT(cn)