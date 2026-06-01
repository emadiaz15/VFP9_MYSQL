
SELECT arreglo
LOCATE

LOCAL xpcod, xarti, xprec, xcant, xdasc, xalt, nit, nreg, xalti, xdac
SCAN
	xpcod = arreglo.presup_codi
	xarti = arreglo.art_codi
	xprec = arreglo.artpres_precio
	xcant = arreglo.artpres_cant
	xdasc = ALLTRIM(arreglo.artpres_dasc)
	xalt  = ""
	nit   = arreglo.nro_it
	nreg  = arreglo.nro_regis
	xalti = 0
	xdac  = 0
	cn = conectar_db(_screen.cn)
		SQLEXEC(cn,"insert into presupuestos_articulos values(?xpcod,?xarti,?xprec,?xcant,?xdasc,?xalt,?nit,?nreg,?xalti,?xdac);")
	desconectar_db(cn)
ENDSCAN

MESSAGEBOX("Proceso Finalizado Correctamente.-",64,"Aviso del Sistema")
