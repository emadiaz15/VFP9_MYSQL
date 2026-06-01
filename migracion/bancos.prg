SET NULL ON

SET LIBRARY TO C:\VFP9_MYSQL\Prgs\librerias.prg

PUBLIC string_cn

string_cn = Crear_Estruc_Conex_MySQL("USER_CONNECT")

PUBLIC cn

cn=SQLSTRINGCONNECT(string_cn)

SELECT * FROM "h:\bancos.dbf" WHERE !DELETED() INTO CURSOR artcli
GO top

SCAN
	cod=ban_codi
	des=ALLTRIM(ban_desc)
	cuit=ban_cuit
	SQLEXEC(cn,"insert into bancos values(?cod,?des,?cuit);")
ENDSCAN
=MESSAGEBOX("Proceso terminado",0+64,"Aviso de Sistema")

cerrar_cursor("artcli")

SQLDISCONNECT(cn)