LOCAL xcodifac,xcodip,xven,xcom
SELECT 0
USE c:\vfp9_mysql\prgs\arreglos\comisiones.dbf SHARED

LOCATE

SCAN
	xcodifac=comisiones.fac_codi
	xcodip  =comisiones.ped_codi
	xven    =comisiones.ven_codi
	xcom    =comisiones.porc_codi
	cn= conectar_db(_screen.cn)
		SQLEXEC(cn,"update facturas set ped_codi=?xcodip,ven_codi=?xven,porc_codi=?xcom where fac_codi=?xcodifac;")
	desconectar_db(cn)
ENDSCAN

MESSAGEBOX("Proceso Finalizado",64,"Aviso del Sistema")