DO "c:\vfp9_mysql\prgs\conexion.prg"

PUBLIC cn
LOCAL xfac, xped

cn= conectar_db(_screen.cn)
	SQLEXEC(cn,"select fac_codi, ped_codi from facturas order by fac_codi;","cur_fac")
desconectar_db(cn)

IF RECCOUNT("cur_fac") > 0
	LOCATE
	SCAN
		xfac= cur_fac.fac_codi
		xped= cur_fac.ped_codi
		cn= conectar_db(_screen.cn)
			SQLEXEC(cn,"update remitos set ped_codi = ?xped where fac_codi = ?xfac;")
		desconectar_db(cn)
	ENDSCAN
ENDIF

MESSAGEBOX("Proceso finalizado correctamente.",0+64,"Aviso del Sistema")
