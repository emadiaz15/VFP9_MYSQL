PUBLIC cn

LOCAL _xFarcodi, _xCodifac, _xCodiart, _xCant, _xImpo, xDasc, _xDac, _xDdesc, _xNd, _xSst, _xCiva, _Apcod

STORE 0 TO _xFarcodi, _xCodifac, _xCodiart, _xCant, _xImpo, _xDac, _Apcod
STORE "" TO _xDasc, _xDdesc, _xNd, _xSst, _xCiva

cn= conectar_db(_screen.cn)

SQLEXEC(cn,"call numerar_fac();","cufacar")

SQLEXEC(cn,"DELETE FROM facturas_articulos;")

SQLEXEC(cn,"ALTER TABLE facturas_articulos ADD far_codi integer(10) not null FIRST;")

SQLEXEC(cn,"ALTER TABLE facturas_articulos ADD UNIQUE INDEX far_codi (far_codi);")

desconectar_db(cn)

SELECT cufacar

LOCATE

SCAN
	_xFarcodi = cufacar.far_codi
	_xCodifac = cufacar.fac_codi
	_xCodiart = cufacar.art_codi
	_xCant    = cufacar.artfac_cant
	_xImpo    = cufacar.artfac_impo
	_xDasc    = ALLTRIM(cufacar.artfac_dasc)
	_xDac     = cufacar.dac_codi
	_xDdesc   = ALLTRIM(cufacar.artfac_ddesc)
	_xNd      = ALLTRIM(cufacar.artfac_nd)
	_xSst     = cufacar.artfac_sstock
	_xCiva    = cufacar.calciva
	_Apcod    = cufacar.artped_codi
	cn= conectar_db(_screen.cn)
		SQLEXEC(cn,"INSERT INTO facturas_articulos VALUES(?_xFarcodi,?_xCodifac,?_xCodiart,?_xCant,?_xImpo,?_xDasc,?_xDac,?_xDdesc,?_xNd,?_xSst,?_xCiva,?_Apcod);")
	desconectar_db(cn)
	SELECT cufacar
ENDSCAN

MESSAGEBOX("Proceso finalizado correctamente...",0+64,"Aviso del Sistema")


