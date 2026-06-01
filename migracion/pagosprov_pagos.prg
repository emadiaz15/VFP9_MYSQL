SET NULL ON

SET LIBRARY TO "c:\vfp9_mysql\prgs\librerias.prg"

PUBLIC string_cn

string_cn = Crear_Estruc_Conex_MySQL("USER_CONNECT")

PUBLIC cn

cn=SQLSTRINGCONNECT(string_cn)

SELECT * FROM "h:\pagosprov_pagos.dbf" WHERE !DELETED() INTO CURSOR pagp
GO top

SCAN
	codp=pagpag_codi
	cod=pag_codi
	tip=tippag_codi
	ban=ban_codi
	suc=suc_codi
	che=ALLTRIM(chequenro)
	nro=movtippag_nro
	pza=movtippag_pza
	fvt=IIF(LEN(ALLTRIM(DTOS(movtippag_fvto)))=0,.NULL.,movtippag_fvto)
	imp=movtippag_imp
	cui=cuit_lib
	rcod=recpag_codi
	SQLEXEC(cn,"insert into pagosprov_pagos values(?codp,?cod,?tip,?ban,?suc,?che,?nro,?pza,?fvt,?imp,?cui,?rcod);")
ENDSCAN
=MESSAGEBOX("Proceso terminado",0+64,"Aviso de Sistema")

cerrar_cursor("pagp")

SQLDISCONNECT(cn)

