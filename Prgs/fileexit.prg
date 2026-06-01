LOCAL buscar
buscar = ALLTRIM(SUBSTR(SYS(0), AT("#", SYS(0))+2))
salir = conectar_db(_screen.cn)
	SQLEXEC(salir,"update usuarios set usu_canapp = usu_canapp - 1 where TRIM(usu_nomb) = ?buscar;")
	SQLEXEC(salir,"select usu_canapp from usuarios where TRIM(usu_nomb) = ?buscar;","cur_canap")
	IF cur_canap.usu_canapp = 0
		SQLEXEC(salir,"update usuarios set usu_estado = 0 where TRIM(usu_nomb) = ?buscar;")
	ENDIF
desconectar_db(salir)

CLEAR EVENTS
ON ShutDown
QUIT