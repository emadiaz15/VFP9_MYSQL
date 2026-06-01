SET NULL ON

SET LIBRARY TO "c:\vfp9_mysql\prgs\librerias.prg"

PUBLIC string_cn

string_cn = Crear_Estruc_Conex_MySQL("USER_CONNECT")

PUBLIC cn

cn=SQLSTRINGCONNECT(string_cn)

SELECT * FROM "h:\comisiones.dbf" WHERE !DELETED() INTO CURSOR artcli
GO top

SCAN
	cod=com_codi
	fec=com_fech
	ven=ven_codi
	comven=com_cantv
	imp=com_impo
	des=com_perdes
	has=com_perhas
	SQLEXEC(cn,"insert into comisiones values(?cod,?fec,?ven,?comven,?imp,?des,?has);")
ENDSCAN
=MESSAGEBOX("Proceso terminado",0+64,"Aviso de Sistema")

cerrar_curosor("artcli")

SQLDISCONNECT(cn)