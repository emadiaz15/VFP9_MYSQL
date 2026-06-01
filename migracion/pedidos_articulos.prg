SET NULL ON

SET LIBRARY TO "c:\vfp9_mysql\prgs\librerias.prg"

PUBLIC string_cn

string_cn = Crear_Estruc_Conex_MySQL("USER_CONNECT")

PUBLIC cn

cn=SQLSTRINGCONNECT(string_cn)

SELECT * FROM "H:\pedidos_articulos.dbf" WHERE !DELETED() INTO CURSOR climysql
GO top
counter=1
SCAN
	cod=ped_codi
	art=art_codi
	can=artped_cant
	pre=artped_precio
	aiva=alter_iva
	ent=artped_ent
	das=ALLTRIM(artped_dasc)
	dac=dac_codi
	SQLEXEC(cn,"insert into pedidos_articulos values(?counter,?cod,?art,?can,?pre,?aiva,?ent,?das,?dac);")
	counter=counter+1
ENDSCAN
=MESSAGEBOX("Proceso terminado",0+64,"Aviso de Sistema")

cerrar_cursor("climysql")

SQLDISCONNECT(cn)

