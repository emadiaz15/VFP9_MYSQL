LOCAL xcodi,xncodi,xrcodi,xnrcodi

STORE 0 TO xcodi,xncodi,xrcodi,xnrcodi

SET LIBRARY TO C:\VFP9_MYSQL\Prgs\librerias.prg

set path to C:\vfp9_mysql, ;
			C:\VFP9_MYSQL\Prgs, ;
			C:\VFP9_MYSQL\Tablas_libres
			
LOCAL xcadena
xcadena = Crear_Estruc_Conex_Mysql("USER_CONNECT")
_screen.AddProperty("cn",xcadena)

SELECT 0
IF USED("recodif")
	USE IN recodif
ENDIF
USE recodif
LOCATE

SCAN
	xcodi   = recodif.art_codi
	xncodi  = recodif.ncodi
	xnrcodi = recodif.nrcodi
	
	cn = conectar_db(_screen.cn)
		SQLEXEC(cn,"call usp_recodif(?xcodi,?xncodi,?xnrcodi);")
	desconectar_db(cn)
ENDSCAN

*!*	cn = conectar_db(_screen.cn)
*!*		SQLEXEC(cn,"update rubros set rub_codi=405000 where rub_codi=401200;")
*!*		SQLEXEC(cn,"update rubros set rub_codi=412000 where rub_codi=401060;")
*!*		SQLEXEC(cn,"delete from rubros where rub_codi=401100;")
*!*	desconectar_db(cn)

MESSAGEBOX("Proceso finalizado con exito",64,"Aviso del Sistema")


return