SET NULL ON

SET LIBRARY TO "c:\vfp9_mysql\prgs\librerias.prg"

PUBLIC string_cn

string_cn = Crear_Estruc_Conex_MySQL("USER_CONNECT")

PUBLIC cn

cn=SQLSTRINGCONNECT(string_cn)

SELECT * FROM "h:\pedidos_transportes.dbf" WHERE !DELETED() INTO CURSOR pedtran
GO top
xcont=1
SCAN
	cod=ped_codi
	tra=tran_codi
	ent=ALLTRIM(flete_lugent)
	car=flete_cargo
	SQLEXEC(cn,"insert into pedidos_transportes values(?xcont,?cod,?tra,?ent,?car);")
	xcont=xcont+1
ENDSCAN
=MESSAGEBOX("Proceso terminado",0+64,"Aviso de Sistema")

cerrar_cursor("pedtran")

SQLDISCONNECT(cn)



