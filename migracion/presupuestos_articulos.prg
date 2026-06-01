SET NULL ON

SET LIBRARY TO "c:\vfp9_mysql\prgs\librerias.prg"

PUBLIC string_cn

string_cn = Crear_Estruc_Conex_MySQL("USER_CONNECT")

PUBLIC cn

cn=SQLSTRINGCONNECT(string_cn)

SELECT * FROM "h:\presupuestos_articulos.dbf" WHERE !DELETED() INTO CURSOR pres
GO top

SCAN
	cod=presup_codi
	art=art_codi
	pre=artpres_precio
	can=artpres_cant
	das=artpres_dasc
	ativ=alternativa
	it=nro_it
	reg=nro_regis
	aiva=alter_iva
	dac=dac_codi
	SQLEXEC(cn,"insert into presupuestos_articulos values(?cod,?art,?pre,?can,?das,?ativ,?it,?reg,?aiva,?dac);")
ENDSCAN
=MESSAGEBOX("Proceso terminado",0+64,"Aviso de Sistema")

cerrar_cursor("pres")

SQLDISCONNECT(cn)
