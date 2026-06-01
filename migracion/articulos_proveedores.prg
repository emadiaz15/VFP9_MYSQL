SET NULL ON

SET LIBRARY TO C:\VFP9_MYSQL\Prgs\librerias.prg

PUBLIC string_cn

string_cn = Crear_Estruc_Conex_MySQL("USER_CONNECT")

PUBLIC cn

cn=SQLSTRINGCONNECT(string_cn)

SELECT * FROM "h:\articulos_proveedores.dbf" WHERE !DELETED() INTO CURSOR artpro
GO top

SCAN
	cod=artpro_codi
	art=art_codi
	pro=prov_codi
	arpc=artpro_costo
	arpcv=artpro_ctovta
	des=ALLTRIM(artpro_desc)
	mon=ALLTRIM(moneda)
	lis=IIF(lista=.T.,1,0)
	SQLEXEC(cn,"insert into articulos_proveedores values(?cod,?art,?pro,?arpc,?arpcv,?des,?mon,?lis,0);")
ENDSCAN
=MESSAGEBOX("Proceso terminado",0+64,"Aviso de Sistema")

cerrar_cursor("artpro")

SQLDISCONNECT(cn)