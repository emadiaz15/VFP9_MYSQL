SET NULL ON

SET LIBRARY TO "c:\vfp9_mysql\prgs\librerias.prg"

PUBLIC string_cn

string_cn = Crear_Estruc_Conex_MySQL("USER_CONNECT")

PUBLIC cn

cn=SQLSTRINGCONNECT(string_cn)

SELECT * FROM "h:\facturas_articulos.dbf" WHERE !DELETED() INTO CURSOR facart
GO top

SCAN
	cod=fac_codi
	art=art_codi
	afc=artfac_cant
	afi=artfac_impo
	afd=ALLTRIM(artfac_dasc)
	dac=dac_codi
	ard=ALLTRIM(artfac_ddesc)
	arnd=ALLTRIM(artfac_nd)
	sst=ALLTRIM(artfac_sstock)
	civa=ALLTRIM(calciva)
	SQLEXEC(cn,"insert into facturas_articulos values(?cod,?art,?afc,?afi,?afd,?dac,?ard,?arnd,?sst,?civa,0);")
ENDSCAN
=MESSAGEBOX("Proceso terminado",0+64,"Aviso de Sistema")

cerrar_cursor("facart")

SQLDISCONNECT(cn)