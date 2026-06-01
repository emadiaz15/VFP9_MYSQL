SET NULL ON

SET LIBRARY TO "c:\vfp9_mysql\prgs\librerias.prg"

PUBLIC string_cn

string_cn = Crear_Estruc_Conex_MySQL("USER_CONNECT")

PUBLIC cn

cn=SQLSTRINGCONNECT(string_cn)

SELECT * FROM "h:\rfc.dbf" WHERE !DELETED() INTO CURSOR recf
GO top

SCAN
	cod=rfc_codi
	fec=rfc_fec
	pro=prov_codi
	pag=pag_codi
	ing=rfc_impng
	ne1=rfc_neto1
	ne2=rfc_neto2
	iri=rfc_ivari
	irni=rfc_ivarni
	SQLEXEC(cn,"insert into rfc values(?cod,?fec,?pro,?pag,?ing,?ne1,?ne2,?iri,?irni);")
ENDSCAN
=MESSAGEBOX("Proceso terminado",0+64,"Aviso de Sistema")

cerrar_cursor("recf")

SQLDISCONNECT(cn)