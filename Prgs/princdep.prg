clear
close all
set talk off
set dele on
set exact off
set near on
SET CONSOLE OFF

clear
public paso,fecha,valor,preg,aviso,consulta,rubcodi,proveedor,rubroc,rubrod,rub,can,d, ;
		aux,codicli,localiz,nitem,codp,acu,muestro,codiprov,cond,pasrem,valorcadena,codigo
codigo=0
set date british
set cent on
set dele on

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

SET STATUS BAR OFF
SET SYSMENU TO
_screen.Closable= .F.
_screen.caption="SISTEMA PARA DEPÓSITO"
_screen.Icon= 'C:\VFP9_MYSQL\POLES03B.ICO'

_screen.AddProperty("xconext","Driver={MySQL ODBC 5.1 Driver};Server=192.168.0.223;Port=3306;Database=db_ilumet;Uid=admin;Pwd=Admin121074*;")

_screen.AddObject("opantalla_principal","pantalla_principal2")
_screen.opantalla_principal.visible=.t.
_screen.height= _screen.opantalla_principal.height-65
_screen.Width = _screen.opantalla_principal.width
_screen.Left  = (SYSMETRIC(1)-_screen.Width)/2
_screen.top   = (SYSMETRIC(2)-_screen.height)/2
_screen.MaxButton= .F.

LOCAL xcadena
xcadena = Crear_Estruc_Conex_Mysql("USER_CONNECT")
_screen.AddProperty("cn",xcadena)

paso=0
valor=0
rubroc=0
localiz=0
nitem=0
muestro=0
pasrem=1
fecha=ctod("  /  /    ")
valorcadena=""
aux=0
ON SHUTDOWN do c:\vfp9_mysql\prgs\fileexit.prg
READ EVENTS

