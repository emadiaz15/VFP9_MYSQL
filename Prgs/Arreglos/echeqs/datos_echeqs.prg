PUBLIC cn
LOCAL xrpc, xcban, xnro, xcuit

IF USED("echeqs")
	USE
ENDIF

SELECT 0
USE echeqs
LOCATE

SCAN
	xrpc  = recpag_cod
	xcban = ban_codi
	xnro  = ALLTRIM(mtp_nro)
	xcuit = cuit_lib
	cn= SQLSTRINGCONNECT("Driver={MySQL ODBC 5.1 Driver};Server=192.168.0.222;Port=3306;Database=db_dhoelec;Uid=admin;Pwd=Admin121074")
		SQLEXEC(cn,"update recibos_pagos set tippag_codi=20,ban_codi=?xcban,movtippag_nro=?xnro,chequenro=?xnro,cuit_lib=?xcuit,activo='S' where recpag_codi = ?xrpc;")
	SQLDISCONNECT(cn)
ENDSCAN

MESSAGEBOX("Proceso finalizado correctamente...",64,"Aviso del Sistema")