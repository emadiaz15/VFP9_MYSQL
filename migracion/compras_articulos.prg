SET NULL ON

SET LIBRARY TO "c:\vfp9_mysql\prgs\librerias.prg"

PUBLIC string_cn

string_cn = Crear_Estruc_Conex_MySQL("USER_CONNECT")

PUBLIC cn

cn=SQLSTRINGCONNECT(string_cn)

SELECT * FROM "h:\compras_articulos.dbf" WHERE !DELETED() INTO CURSOR artcli
GO top
LOCAL contador
contador=1
SCAN
	cod=orden_codi
	art=art_codi
	pre=artord_precio
	can=artord_cant
	ent=artord_ent
	dasc=ALLTRIM(artord_dasc)
	arpc=artpro_codi
	dap=dap_codi
	aiv=alter_iva
	SQLEXEC(cn,"insert into compras_articulos values(?contador,?cod,?art,?pre,?can,?ent,?dasc,?arpc,?dap,?aiv);")
	contador=contador+1
ENDSCAN
=MESSAGEBOX("Proceso terminado",0+64,"Aviso de Sistema")

cerrar_cursor("artcli")

SQLDISCONNECT(cn)