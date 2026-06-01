PUBLIC cn1, cn2
LOCAL xrefa,codf
cn1 = SQLSTRINGCONNECT("Driver={MySQL ODBC 5.1 Driver};Server=localhost;Port=3306;Database=db_recifac;Uid=admin;Pwd=Flatw194;")
	SQLEXEC(cn1,"select * from recibos_facturas order by recfac_codi;","cur_recf")
SQLDISCONNECT(cn1)

SELECT cur_recf
LOCATE
SCAN
	xrefa = cur_recf.recfac_codi
	codf  = cur_recf.fac_codi
	cn2 = SQLSTRINGCONNECT("Driver={MySQL ODBC 5.1 Driver};Server=192.168.0.222;Port=3306;Database=db_dhoelec;Uid=admin;Pwd=Admin121074;")
		SQLEXEC(cn2,"update recibos_facturas set fac_codi = ?codf where recfac_codi= ?xrefa;")
	SQLDISCONNECT(cn2)
ENDSCAN

MESSAGEBOX("Proceso finalizado correctamente...",64,"Aviso del Sistema")