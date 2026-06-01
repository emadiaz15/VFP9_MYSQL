CLOSE all

LOCAL arp,ctd
STORE 0 TO arp,ctd

SET LIBRARY TO C:\VFP9_MYSQL\Prgs\librerias.prg
set path to C:\vfp9_mysql, ;
LOCAL xcadena
xcadena = Crear_Estruc_Conex_Mysql("USER_CONNECT")
_screen.AddProperty("cn",xcadena)

SELECT 0
USE costos_arreglo
GO top
SCAN
	arp=costos_arreglo.artpro_cod
	ctd=costos_arreglo.costodef
	arcos= conectar_db(_screen.cn)
		SQLEXEC(arcos,"update articulos_proveedores set artpro_costo=?ctd where artpro_codi=?arp;")
	desconectar_db(arcos)
ENDSCAN