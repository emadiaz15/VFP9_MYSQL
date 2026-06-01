SET NULL ON

SET LIBRARY TO "c:\vfp9_mysql\prgs\librerias.prg"

PUBLIC string_cn

string_cn = Crear_Estruc_Conex_MySQL("USER_CONNECT")

PUBLIC cn

cn=SQLSTRINGCONNECT(string_cn)

SELECT * FROM "h:\pedidos.dbf" WHERE !DELETED() INTO CURSOR climysql
GO top

SCAN
	cod=ped_codi
	fec=ped_fech
	cli=cli_codi
	dto=ped_dto
	iva=iva_codi
	pres=presup_codi
	nped=notaped_nro
	tra=tran_codi
	car=flete_cargo
	rede=ALLTRIM(redespacho)
	cum=cumplido
	ven=ven_codi
	por=porc_codi
	otc=otra_comi
	obs=ped_obser
	SQLEXEC(cn,"insert into pedidos values(?cod,?fec,?cli,?dto,?iva,?pres,?nped,?tra,?car,?rede,?cum,?ven,?por,?otc,?obs);")
ENDSCAN
=MESSAGEBOX("Proceso terminado",0+64,"Aviso de Sistema")

cerrar_cursor("climysql")

SQLDISCONNECT(cn)


