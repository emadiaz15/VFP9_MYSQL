SET NULL ON

SET LIBRARY TO "c:\vfp9_mysql\prgs\librerias.prg"

PUBLIC string_cn

string_cn = Crear_Estruc_Conex_MySQL("USER_CONNECT")

PUBLIC cn

cn=SQLSTRINGCONNECT(string_cn)

SELECT * FROM "h:\recepciones_articulos.dbf" WHERE !DELETED() INTO CURSOR fac
GO top

SCAN
	cod=recep_codi
	art=art_codi
	can=artrecep_cant
	pre=artrecep_prec
	das=ALLTRIM(artrecep_dasc)
	cnc=concepto
	sst=recep_sstock
	dap=dap_codi
	civa=IIF(calciva=.T.,1,0)
	ord=orden_codi
	SQLEXEC(cn,"insert into recepciones_articulos values(?cod,?art,?can,?pre,?das,?cnc,?sst,?dap,?civa,?ord);")
ENDSCAN
=MESSAGEBOX("Proceso terminado",0+64,"Aviso de Sistema")

cerrar_cursor("fac")

SQLDISCONNECT(cn)