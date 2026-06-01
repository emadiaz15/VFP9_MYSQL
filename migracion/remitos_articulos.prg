SET NULL ON

SET LIBRARY TO "c:\vfp9_mysql\prgs\librerias.prg"

PUBLIC string_cn

string_cn = Crear_Estruc_Conex_MySQL("USER_CONNECT")

PUBLIC cn

cn=SQLSTRINGCONNECT(string_cn)

SELECT * FROM "h:\remitos_articulos.dbf" WHERE !DELETED() INTO CURSOR facart
GO top

SCAN
	cod=rem_codi
	art=art_codi
	nro=rem_nro
	arc=artrem_cant
	das=ALLTRIM(artrem_dasc)
    dac=dac_codi
    dap=dap_codi
	ardd=ALLTRIM(artrem_ddesc)
	sst=ALLTRIM(artrem_sstock)
	SQLEXEC(cn,"insert into remitos_articulos values(?cod,?art,?nro,?arc,?das,?dac,?dap,?ardd,?sst,0);")
ENDSCAN
=MESSAGEBOX("Proceso terminado",0+64,"Aviso de Sistema")

cerrar_cursor("facart")

SQLDISCONNECT(cn)
