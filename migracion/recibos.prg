SET NULL ON

SET LIBRARY TO "c:\vfp9_mysql\prgs\librerias.prg"

PUBLIC string_cn

string_cn = Crear_Estruc_Conex_MySQL("USER_CONNECT")

PUBLIC cn

cn=SQLSTRINGCONNECT(string_cn)

SELECT * FROM "h:\recibos.dbf" WHERE !DELETED() INTO CURSOR fac
GO top

SCAN
	cod=rec_codi
	nro=rec_nro
	fec=IIF(LEN(ALLTRIM(DTOS(rec_fec)))=0,.NULL.,rec_fec)
	imp=rec_impo
	cli=cli_codi
	tip=rec_tipo
	ant=rec_antic
	obs=rec_obser
	dto=rec_dtosaf
	res=rec_restsaf
	SQLEXEC(cn,"insert into recibos values(?cod,?nro,?fec,?imp,?cli,?tip,?ant,?obs,?dto,?res);")
ENDSCAN
=MESSAGEBOX("Proceso terminado",0+64,"Aviso de Sistema")

cerrar_cursor("fac")

SQLDISCONNECT(cn)

