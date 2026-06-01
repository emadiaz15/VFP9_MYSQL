SET NULL ON

SET LIBRARY TO C:\VFP9_MYSQL\Prgs\librerias.prg
PUBLIC string_cn

string_cn = Crear_Estruc_Conex_MySQL("USER_CONNECT")

PUBLIC cn

cn=SQLSTRINGCONNECT(string_cn)

SELECT * FROM "h:\articulos_clientes.dbf" WHERE !DELETED() INTO CURSOR artcli
GO top

SCAN
	cod=artcli_codi
	art=art_codi
	cli=cli_codi
	artcli=ALLTRIM(artcli_desc)
	SQLEXEC(cn,"insert into articulos_clientes values(?cod,?art,?cli,?artcli);")
ENDSCAN
=MESSAGEBOX("Proceso terminado",0+64,"Aviso de Sistema")

cerrar_cursor("artcli")

SQLDISCONNECT(cn)