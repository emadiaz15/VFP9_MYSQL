SET NULL ON

SET LIBRARY TO C:\VFP9_MYSQL\Prgs\librerias.prg

PUBLIC string_cn

string_cn = Crear_Estruc_Conex_MySQL("USER_CONNECT")

PUBLIC cn

cn=SQLSTRINGCONNECT(string_cn)

SELECT * FROM "h:\articulos.dbf" WHERE !DELETED() INTO CURSOR art
GO top

SCAN
	cod=art_codi
	des=art_desc
	sto=art_stock
	pre=art_precio
	cto=costo_ultcpra
	rub=rub_codi
	med=art_med
	ped=pedidos
	pedp=pedprov
	stm=art_stmin
	det=art_deta
	ali=art_alicuota
	SQLEXEC(cn,"insert into articulos values(?cod,?des,?sto,?pre,?cto,?rub,?med,?ped,?pedp,?stm,?det,'',?ali);")
ENDSCAN
=MESSAGEBOX("Proceso terminado",0+64,"Aviso de Sistema")

cerrar_cursor("art")

SQLDISCONNECT(cn)


