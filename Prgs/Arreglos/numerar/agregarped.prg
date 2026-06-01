PUBLIC cn

LOCAL _xCodirem, _xCodiped

STORE 0 TO _xCodirem, _xCodiped

cn= conectar_db(_screen.cn)
	SQLEXEC(cn,"call usp_remiped();","cur_remiped")
desconectar_db(cn)

IF RECCOUNT("cur_remiped") > 0
	LOCATE
	SCAN
		_xCodirem = cur_remiped.rem_codi
		_xCodiped = cur_remiped.ped_codi
		cn= conectar_db(_screen.cn)
			SQLEXEC(cn,"update remitos set ped_codi = ?_xCodiped where rem_codi = ?_xCodirem;")
		desconectar_db(cn)
	ENDSCAN
ENDIF

=MESSAGEBOX("Proceso finalizado correctamente...",0+64,"Aviso del Sistema")