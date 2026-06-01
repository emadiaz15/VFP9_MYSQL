SET NULL ON

SET LIBRARY TO "c:\vfp9_mysql\prgs\librerias.prg"

PUBLIC string_cn

string_cn = Crear_Estruc_Conex_MySQL("USER_CONNECT")

PUBLIC cn

cn=SQLSTRINGCONNECT(string_cn)

SELECT * FROM "h:\pagosprov.dbf" WHERE !DELETED() INTO CURSOR pagp
GO top

SCAN
	cod=pag_codi
	fec=pag_fech
	imp=pag_impo
	suj=pag_sujret
	prov=prov_codi
	obs=pag_obser
	ant=pag_antic
	dsaf=pag_dtosaf
	dpag=pag_dtoxpag
	res=pag_restsaf
	tot=pag_totsaf
	SQLEXEC(cn,"insert into pagosprov values(?cod,?fec,?imp,?suj,?prov,?obs,?ant,?dsaf,?dpag,?res,?tot);")
ENDSCAN
=MESSAGEBOX("Proceso terminado",0+64,"Aviso de Sistema")

cerrar_cursor("pagp")

SQLDISCONNECT(cn)
