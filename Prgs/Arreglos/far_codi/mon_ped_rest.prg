PUBLIC cn

LOCAL xped
xped = 0
DO "c:\vfp9_mysql\prgs\conexion.prg"

cn= conectar_db(_screen.cn)
	SQLEXEC(cn,"call a_arreglo();","cur_moneda")
desconectar_db(cn)

SELECT cur_moneda
LOCATE
SCAN
	xped=cur_moneda.ped_codi
	cn= conectar_db(_screen.cn)
		SQLEXEC(cn,"update pedidos set moneda = 'P' where ped_codi = ?xped;")
	desconectar_db(cn)
ENDSCAN

xped = 0

SELECT cur_moneda1
LOCATE
SCAN
	xped=cur_moneda1.ped_codi
	cn= conectar_db(_screen.cn)
		SQLEXEC(cn,"update pedidos set moneda = 'D' where ped_codi = ?xped;")
	desconectar_db(cn)
ENDSCAN

MESSAGEBOX("Proceso finalizado correctamente.",64,"Aviso del Sistema")