SET NULL ON

SET LIBRARY TO "c:\vfp9_mysql\prgs\librerias.prg"

PUBLIC string_cn

string_cn = Crear_Estruc_Conex_MySQL("USER_CONNECT")

PUBLIC cn

cn=SQLSTRINGCONNECT(string_cn)

SELECT * FROM "h:\regulaprov.dbf" WHERE !DELETED() INTO CURSOR re
GO top

SCAN
	cod=regp_codi
	fec=regp_fech
	cnc=regp_conc
	det=regp_deta
	imp=regp_impo
	pro=prov_codi
	cta=ctacte
	SQLEXEC(cn,"insert into regulaprov values(?cod,?fec,?cnc,?det,?imp,?pro,?cta);")
ENDSCAN
=MESSAGEBOX("Proceso terminado",0+64,"Aviso de Sistema")

cerrar_cursor("re")

SQLDISCONNECT(cn)