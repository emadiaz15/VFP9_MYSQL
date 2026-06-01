prgcond= conectar_db(_screen.cn)
	SQLEXEC(prgcond,"select * from gastos order by gas_codi;","cur_gastos")
desconectar_db(prgcond)

IF RECCOUNT("cur_gastos")>0
	GO top
	SCAN
		prgcond= conectar_db(_screen.cn)
			IF cur_gastos.gas_tipcbte='C'
				SQLEXEC(prgcond,"update personas set cond_codi=4 where per_codi=?cur_gastos.per_codi;")
			ELSE
				SQLEXEC(prgcond,"update personas set cond_codi=2 where per_codi=?cur_gastos.per_codi;")
			ENDIF
		desconectar_db(prgcond)
	ENDSCAN
ENDIF

cerrar_cursor("cur_gastos")