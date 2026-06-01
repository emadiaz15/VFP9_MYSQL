SET DATE BRITISH
SET CENTURY on

PUBLIC cn
LOCAL nroit, xpedc, xarpc, xped, xart, xcant, xprec, xalter, xent, xdasc, xdac

DO "C:\VFP9_MYSQL\Prgs\conexion.prg"

cn = conectar_db(_screen.cn)
	SQLEXEC(cn,"select * from pedidos_articulos order by artped_codi;","cur_auxi")
desconectar_db(cn)


SELECT cur_auxi
LOCATE

SCAN
	nroit = 1
	xpedc = cur_auxi.ped_codi
	DO WHILE cur_auxi.ped_codi = xpedc
		xarpc = cur_auxi.artped_codi
		cn = conectar_db(_screen.cn)
			sqlexec(cn,"update pedidos_articulos set artped_it = ?nroit where artped_codi = ?xarpc;")
		desconectar_db(cn)
		SKIP
		nroit = nroit + 1						         
	ENDDO
	SKIP - 1
ENDSCAN

MESSAGEBOX("Proceso finalizado correctamente",64,"Aviso del Sistema")