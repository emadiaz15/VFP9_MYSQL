SET NULL ON

SET LIBRARY TO "c:\vfp9_mysql\prgs\librerias.prg"

PUBLIC string_cn

string_cn = Crear_Estruc_Conex_MySQL("USER_CONNECT")

PUBLIC cn

cn=SQLSTRINGCONNECT(string_cn)

SELECT * FROM "h:\remitos.dbf" WHERE !DELETED() INTO CURSOR remmysql
GO top

SCAN
	cod=rem_codi
	nro=rem_nro
	pto=rem_pto
	fec=rem_fech
	fcc=fac_codi
	tra=tran_codi
	cli=cli_codi
	pro=prov_codi
	flec=ALLTRIM(flete_cargo)
	flep=flete_peso
	flev=flete_valor
	flel=ALLTRIM(flete_lugent)
	obs=ALLTRIM(rem_observ)
	anu=ALLTRIM(anulado)
	SQLEXEC(cn,"insert into remitos values(?cod,?nro,?pto,?fec,?fcc,?tra,?cli,?pro,?flec,?flep,?flev,?flel,?obs,?anu);")
ENDSCAN
=MESSAGEBOX("Proceso terminado",0+64,"Aviso de Sistema")

cerrar_cursor("remmysql")

SQLDISCONNECT(cn)