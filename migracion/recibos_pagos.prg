SET NULL ON

SET LIBRARY TO "c:\vfp9_mysql\prgs\librerias.prg"

PUBLIC string_cn

string_cn = Crear_Estruc_Conex_MySQL("USER_CONNECT")

PUBLIC cn

cn=SQLSTRINGCONNECT(string_cn)

SELECT * FROM "h:\recibos_pagos.dbf" WHERE !DELETED() INTO CURSOR recp
GO top

SCAN
	codp=recpag_codi
	cod=rec_codi
	tip=tippag_codi
	ban=ban_codi
	suc=suc_codi
	nro=movtippag_nro
	che=ALLTRIM(chequenro)
	pza=ALLTRIM(movtippag_pza)
	vto=IIF(LEN(ALLTRIM(DTOS(movtippag_fvto)))=0,.NULL.,movtippag_fvto)
	imp=movtippag_imp
	cuit=cuit_lib
	pag=pag_codi
	gas=gas_codi
	nalo=IIF(recpag_nalo=.T.,1,0)
	dep=dep_codi
	act=ALLTRIM(activo)
	SQLEXEC(cn,"insert into recibos_pagos values(?codp,?cod,?tip,?ban,?suc,?nro,?che,?pza,?vto,?imp,?cuit,?pag,?gas,?nalo,?dep,?act);")
ENDSCAN
=MESSAGEBOX("Proceso terminado",0+64,"Aviso de Sistema")

cerrar_cursor("recp")

SQLDISCONNECT(cn)