SET NULL ON

SET LIBRARY TO "c:\vfp9_mysql\prgs\librerias.prg"

PUBLIC string_cn

string_cn = Crear_Estruc_Conex_MySQL("USER_CONNECT")

PUBLIC cn

cn=SQLSTRINGCONNECT(string_cn)

SELECT * FROM "h:\condipresup.dbf" WHERE !DELETED() INTO CURSOR condi
GO top

SCAN
	cod=condp_cod
	cpv=ALLTRIM(condp_val)
	pla=ALLTRIM(condp_pla)
	pag=ALLTRIM(condp_pag)
	lug=ALLTRIM(condp_lug)
	obs=ALLTRIM(condp_obs)
	SQLEXEC(cn,"insert into condipresup values(?cod,?cpv,?pla,?pag,?lug,?obs);")
ENDSCAN
=MESSAGEBOX("Proceso terminado",64,"Aviso de Sistema")

cerrar_cursor("condi")

SQLDISCONNECT(cn)