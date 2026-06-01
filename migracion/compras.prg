SET NULL ON

SET LIBRARY TO "c:\vfp9_mysql\prgs\librerias.prg"

PUBLIC string_cn

string_cn = Crear_Estruc_Conex_MySQL("USER_CONNECT")

PUBLIC cn

cn=SQLSTRINGCONNECT(string_cn)

SELECT * FROM "h:\compras.dbf" WHERE !DELETED() INTO CURSOR artcli
GO top

SCAN
	cod=orden_codi
	fec=orden_fech
	pro=prov_codi
	ref=ALLTRIM(orden_ref)
	obs=ALLTRIM(orden_obser)
	dto=orden_dto
	tra=tran_codi
	iva=iva_codi
	cum=cumplido
	anu=anulado
	mon=moneda
	SQLEXEC(cn,"insert into compras values(?cod,?fec,?pro,?ref,?obs,?dto,?tra,?iva,?cum,?anu,0,?mon);")
ENDSCAN
=MESSAGEBOX("Proceso terminado",0+64,"Aviso de Sistema")

cerrar_cursor("artcli")

SQLDISCONNECT(cn)