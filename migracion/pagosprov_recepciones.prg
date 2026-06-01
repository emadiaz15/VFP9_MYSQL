SET NULL ON

SET LIBRARY TO "c:\vfp9_mysql\prgs\librerias.prg"

PUBLIC string_cn

string_cn = Crear_Estruc_Conex_MySQL("USER_CONNECT")

PUBLIC cn

cn=SQLSTRINGCONNECT(string_cn)

SELECT * FROM "h:\pagosprov_recepciones.dbf" WHERE !DELETED() INTO CURSOR pagp
GO top

SCAN
	codp=pagrec_codi
	cod=pag_codi
	rec=recep_codi
	imp=pagrecep_impo
	par=IIF(pagrecep_parci=.t.,1,0)
	SQLEXEC(cn,"insert into pagosprov_recepciones values(?codp,?cod,?rec,?imp,?par);")
ENDSCAN
=MESSAGEBOX("Proceso terminado",0+64,"Aviso de Sistema")

cerrar_cursor("pagp")

SQLDISCONNECT(cn)

