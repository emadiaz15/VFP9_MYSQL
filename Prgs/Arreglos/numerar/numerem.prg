PUBLIC cn

LOCAL _xRercodi, _xCodirem, _xCodiart, _xRemnro, _xCant, _xDasc, _xDac,_xDap, _xDdesc, _xSst, _Apcod

STORE 0 TO _xRercodi, _xCodirem, _xCodiart, _xRemnro, _xCant, _xDac,_xDap, _Apcod
STORE "" TO _xDasc, _xDdesc, _xSst

cn= conectar_db(_screen.cn)

SQLEXEC(cn,"call numerar_rem();","curemar")

SQLEXEC(cn,"DELETE FROM remitos_articulos;")

SQLEXEC(cn,"ALTER TABLE remitos_articulos ADD rer_codi integer(10) not null FIRST;")

SQLEXEC(cn,"ALTER TABLE remitos_articulos ADD UNIQUE INDEX rer_codi (rer_codi);")

desconectar_db(cn)

SELECT curemar

LOCATE

SCAN
	_xRercodi = curemar.rer_codi
	_xCodirem = curemar.rem_codi
	_xCodiart = curemar.art_codi
	_xRemnro  = curemar.rem_nro
	_xCant    = curemar.artrem_cant
	_xDasc    = ALLTRIM(curemar.artrem_dasc)
	_xDac     = curemar.dac_codi
	_xDap     = curemar.dap_codi
	_xDdesc   = ALLTRIM(curemar.artrem_ddesc)
	_xSst     = curemar.artrem_sstock
	_Apcod    = curemar.artped_codi
	cn= conectar_db(_screen.cn)
		SQLEXEC(cn,"INSERT INTO remitos_articulos VALUES(?_xRercodi,?_xCodirem,?_xCodiart,?_xRemnro,?_xCant,?_xDasc,?_xDac,?_xDap,?_xDdesc,?_xSst,?_Apcod);")
	desconectar_db(cn)
	SELECT curemar
ENDSCAN

MESSAGEBOX("Proceso finalizado correctamente...",0+64,"Aviso del Sistema")


