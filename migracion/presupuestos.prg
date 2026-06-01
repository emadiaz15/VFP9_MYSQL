SET NULL ON

SET LIBRARY TO "c:\vfp9_mysql\prgs\librerias.prg"

PUBLIC string_cn

string_cn = Crear_Estruc_Conex_MySQL("USER_CONNECT")

PUBLIC cn

cn=SQLSTRINGCONNECT(string_cn)

SELECT * FROM "h:\presupuestos.dbf" WHERE !DELETED() INTO CURSOR pres
GO top

SCAN
	cod=presup_codi
	fec=presup_fech
	cli=cli_codi
	ref=presup_ref
	ofe=presup_ofer
	ple=presup_plent
	ent=presup_lugent
	con=presup_cond
	dto=presup_dto
	obs=presup_obser
	iva=iva_codi
	SQLEXEC(cn,"insert into presupuestos values(?cod,?fec,?cli,?ref,?ofe,?ple,?ent,?con,?dto,?obs,?iva);")
ENDSCAN
=MESSAGEBOX("Proceso terminado",0+64,"Aviso de Sistema")

cerrar_cursor("pres")

SQLDISCONNECT(cn)
