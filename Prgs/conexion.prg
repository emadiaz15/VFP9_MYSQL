***** CONEXIÓN AL ENTORNO DE DATOS ***********

SET LIBRARY TO C:\VFP9_MYSQL\Prgs\librerias.prg
set path to C:\vfp9_mysql, ;
			C:\VFP9_MYSQL\Formularios, ;
			C:\VFP9_MYSQL\Prgs, ;
			C:\VFP9_MYSQL\Reportes, ;
			C:\VFP9_MYSQL\imagen, ;
			C:\VFP9_MYSQL\Clases

SET CLASSLIB TO C:\VFP9_MYSQL\Clases\botones_especiales.vcx, ;
				C:\VFP9_MYSQL\Clases\grids_varios.vcx, ;
				C:\VFP9_MYSQL\Clases\objetos_especiales.vcx, ;
				C:\VFP9_MYSQL\Clases\toolbar_varios.vcx, ;
				c:\vfp9_mysql\clases\foxcharts.vcx, ;
				c:\vfp9_mysql\clases\gdiplusx.vcx

LOCAL xcadena
xcadena = Crear_Estruc_Conex_Mysql("USER_CONNECT")
_screen.AddProperty("cn",xcadena)
*!*	_screen.AddProperty("estapres",0)
*!*	_screen.AddProperty("xopvta","")
MESSAGEBOX("Conexión establecida correctamente....",64,"Aviso del Sistema")
