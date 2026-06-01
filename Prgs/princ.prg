clear
close all
set talk off
SET ECHO OFF
set dele on
set exact off
set near on
set date british
set cent on
SET STATUS BAR OFF
SET NOTIFY OFF
SET EXCLUSIVE OFF
SET CURRENCY TO "$"
SET CURRENCY LEFT
SET HOURS TO 24

SET POINT TO "."
SET SEPARATOR TO ","
CLEAR

public paso,fecha,valor,preg,aviso,consulta,rubcodi,proveedor,rub,can,d,buscar, ;
	   aux,codicli,localiz,nitem,codp,codped,acu,muestro,codiprov,cond,verch,pasrem,pasfac,pasrec,aliiva,codifac,impcbte,codiban,codisuc, ;
	   pasrecep,paspago,pascpra,nombre,codigo,menusel,fecin,valorcadena,sino,codiper,TRA,MATFAC,ven,zona,vcodi,debintcli,creintcli,debintpro,creintpro, ;
	   pasdiv,pasdic,estadoasoc,nroasoc,rpgcodi,rpgcodig
	   

STORE 0 TO aliiva,codifac,paso,valor,localiz,nitem,muestro,pasrem,pasfac,pasrec,codp,codped,cond, ;
		   pasrecep,paspago,pscpra,impcbte,aux,preg,codiban,codisuc,sino,codicli,codiper,ven,zona,vcodi,debintcli,creintcli,debintpro,creintpro, ;
		   pasdiv,pasdic,nroasoc,codigo,rpgcodi,rpgcodig
STORE '' TO menusel,valorcadena

LOCAL lcRootApi

estadoasoc=.F.
verch=1
buscar=1
fecha=ctod("  /  /    ")


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

_screen.WindowState= 2
*!*	_screen.Closable= .F.
*!*	_screen.caption="DHO ELECTRICIDAD S.R.L."
_screen.Icon= 'C:\VFP9_MYSQL\POLES03B.ICO'

*!*	WAIT WINDOW SYSMETRIC(1)
*!*	WAIT WINDOW SYSMETRIC(2)
*!*	_screen.opantalla_principal.cnt_logo.top= ((SYSMETRIC(2)/2)-(_screen.opantalla_principal.cnt_logo.height/2))-(SYSMETRIC(9)+70)
*!*	_screen.opantalla_principal.cnt_logo.left= (SYSMETRIC(1)/2)-(_screen.opantalla_principal.cnt_logo.width/2)


_screen.AddProperty("xconext","Driver={MySQL ODBC 5.1 Driver};Server=192.168.0.148;Port=3306;Database=db_ilumet;Uid=admin;Pwd=Admin1304;")
_screen.AddProperty("urlapi",0)
_screen.AddProperty("estapres",0)
_screen.AddProperty("alteralta","")
_screen.AddProperty("altermodi","")
_screen.AddProperty("utilidad",0)
_screen.AddProperty("tipoasoc","")
_screen.AddProperty("dolarpres",0)
_screen.AddProperty("monepres","")
_screen.AddProperty("moneocpra","")
_screen.AddProperty("numepres",0)
_screen.AddProperty("xopcpra","")
_screen.AddProperty("xopvta","")
_screen.AddProperty("estamodipres",0)
_screen.AddProperty("callplanipre",0)
_screen.AddProperty("modpediplan",.F.)
_screen.AddProperty("modcpraplan",.F.)
_screen.AddProperty("copypediplan",.F.)
_screen.AddProperty("copypresplan",.F.)
_screen.AddProperty("codfasoc",0)
_screen.AddProperty("vendasoc",0)
_screen.AddProperty("porcodiasoc",0)
_screen.AddProperty("otcomiasoc",0.000)
_screen.AddProperty("deposito",.F.)
_screen.AddProperty("estamodidep",0)
_screen.AddProperty("callplanidep",0)
_screen.AddProperty("dolaraju",0)
_screen.AddProperty("deposito",.F.)
_screen.AddProperty("tipopago","")
_screen.AddProperty("clientepres",0)
_screen.AddProperty("clienteconpres",0)
_screen.AddProperty("empresa","")

_screen.AddObject("opantalla_principal","pantalla_principal")
_screen.opantalla_principal.visible=.t.
_screen.opantalla_principal.fechahora_sistema.left=28
_screen.opantalla_principal.fechahora_sistema.top= SYSMETRIC(2)-350
_screen.opantalla_principal.width=_screen.Width
_screen.opantalla_principal.height=_screen.Height

LOCAL xcadena
xcadena = Crear_Estruc_Conex_Mysql("USER_CONNECT")
_screen.AddProperty("cn",xcadena)

*---------------------------------------------------------
* Chequea IP Apirest dolar
*---------------------------------------------------------
clsapi= conectar_db(_screen.cn)
	SQLEXEC(clsapi,"SELECT CAST(var_valor AS CHAR(255)) AS ip " + ;
				    "FROM variables_entorno " + ;
				    "WHERE var_activo = 1 " + ;
				    "  AND var_clave = 'SERVIDOR_WEB_EXT_1' " + ;
				    "LIMIT 1","cur_ipapi")
desconectar_db(clsapi)
IF RECCOUNT("cur_ipapi")>0
	lcRootApi = cur_ipapi.ip
	cerrar_cursor("cur_ipapi")
ENDIF

*---------------------------------------------------------
* Limpiar valor leído desde MySQL/ODBC
*---------------------------------------------------------

lcRootApi = STRTRAN(lcRootApi, CHR(0), "")
lcRootApi = STRTRAN(lcRootApi, CHR(9), "")
lcRootApi = STRTRAN(lcRootApi, CHR(10), "")
lcRootApi = STRTRAN(lcRootApi, CHR(13), "")    
*---------------------------------------------------------
* Crea url concatenada
*---------------------------------------------------------    
_screen.urlapi = ALLTRIM('"http://'+lcRootApi)
*---------------------------------------------------------
* Fin chequeo IP Apirest dolar
*---------------------------------------------------------


progprinc= Conectar_db(_screen.cn)
	SQLEXEC(progprinc,"select param_desc from parametros where param_codi = 13;","cur_empre")
desconectar_db(progprinc)
IF RECCOUNT("cur_empre") > 0
	_screen.empresa = ALLTRIM(cur_empre.param_desc)
	cerrar_cursor("cur_empre")
ENDIF

progprinc= Conectar_db(_screen.cn)
	SQLEXEC(progprinc,"select param_impo from parametros where param_codi = 15;","cur_dolaju")
desconectar_db(progprinc)

IF RECCOUNT("cur_dolaju") > 0
	_screen.dolaraju=cur_dolaju.param_impo
ENDIF
cerrar_cursor("cur_dolaju")
progprinc= conectar_db(_screen.cn)
	SQLEXEC(progprinc,"select param_impo from parametros where param_codi = 14;","cur_dolof")
	SQLEXEC(progprinc,"select param_impo from parametros where param_codi = 18;","cur_dolcpra")
	SQLEXEC(progprinc,"select param_fechora from parametros where param_codi = 14;","cur_fechora")
desconectar_db(progprinc)

_screen.opantalla_principal.AddObject("api_dolaroficial","api_dolaroficial")
_screen.opantalla_principal.api_dolaroficial.Visible = .T.
_screen.opantalla_principal.Api_dolaroficial.left=_screen.opantalla_principal.fechahora_sistema.width+30
_screen.opantalla_principal.Api_dolaroficial.top= SYSMETRIC(2)-370

proprin= conectar_db(_screen.cn)
	SQLEXEC(proprin,"select param_desc from parametros where param_codi = 13;","cur_nomem")
desconectar_db(proprin)
_screen.caption=ALLTRIM(cur_nomem.param_desc)
&&"Sistema Konnektar - EMPRESA: "+ALLTRIM(cur_nomem.param_desc)
cerrar_cursor("cur_nomem")

local cobrar,pagar,cod,ultidia,cadusu
ultidia=GOMONTH(DATE(iif(month(date())=1,YEAR(DATE())-1,YEAR(DATE())),iif(month(date())=1,12,MONTH(DATE())-1),1),1)-1
cadusu = ALLTRIM(SUBSTR(SYS(0), AT("#", SYS(0))+2))

frmprinc= conectar_db(_screen.cn)
	IF frmprinc>0
		SQLEXEC(frmprinc,"update usuarios set usu_estado = 1, usu_canapp = usu_canapp + 1 where TRIM(usu_nomb) = ?cadusu;")
		SQLEXEC(frmprinc,"select MAX(histoc_fecha) as histoc_fecha from histocobrar;","cur_fecobro")
	ELSE
		MESSAGEBOX("El sistema no pudo conectarse al servidor de datos..."+CHR(13)+;
		           "consulte con el administrador de la red...",48,"Aviso del sistema...")
		RETURN
	ENDIF
desconectar_db(frmprinc)

if month(cur_fecobro.histoc_fecha)<>month(date()) and cur_fecobro.histoc_fecha<>ultidia
	frmprinc= conectar_db(_screen.cn)
		SQLEXEC(frmprinc,"select SUM(cli_saldo-cli_favor) as saldo from clientes;","cur_salcli")
		cobrar=cur_salcli.saldo
		SQLEXEC(frmprinc,"select MAX(histoc_codi) as histoc_codi from histocobrar;","cur_histcc")
		cod=cur_histcc.histoc_codi+1
		SQLEXEC(frmprinc,"insert into histocobrar values(?cod,?ultidia,?cobrar);")

		SQLEXEC(frmprinc,"select SUM(prov_saldo-prov_afvor) as saldo from proveedores where prov_codi<>46 and prov_codi<>153 and prov_codi<>178 and prov_codi<>229;","cur_salpro")
		pagar=cur_salpro.saldo
		SQLEXEC(frmprinc,"select MAX(histop_codi) as histop_codi from histopagar;","cur_histop")
		cod=cur_histop.histop_codi+1
		SQLEXEC(frmprinc,"insert into histopagar values(?cod,?ultidia,?pagar);")
	desconectar_db(frmprinc)
ENDIF

frmprinc= conectar_db(_screen.cn)
	SQLEXEC(frmprinc,"select param_impo from parametros where param_codi=12;","cur_utiprn")
desconectar_db(frmprinc)
IF RECCOUNT("cur_utiprn")>0
	_screen.utilidad=cur_utiprn.param_impo
ENDIF

LOCAL vendn
vendn=UPPER(substr(sys(0),ATC("#",sys(0))+2))
frmprinc= conectar_db(_screen.cn)
	SQLEXEC(frmprinc,"select * from vendedores where ven_nomb=?vendn;","cur_ven")
desconectar_db(frmprinc)
if reccount("cur_ven")>0
	ven=ven_codi
ELSE
	ven=0
ENDIF

LOCAL usubarra
usubarra=UPPER(substr(sys(0),ATC("#",sys(0))+2))

if ven>0
	_screen.AddProperty("barra","")
	_screen.barra=CREATEOBJECT("toolbar_03")
	_screen.barra.dock(0)
	_screen.barra.visible=.T.
	_screen.barra.movable=.F.
	do c:\vfp9_mysql\mnuvendedores.mpr
else
	if ALLTRIM(usubarra)="CLOTILDE"
		_screen.AddProperty("barra","")
		_screen.barra=CREATEOBJECT("toolbar_02")
		_screen.barra.dock(0)
		_screen.barra.visible=.T.
		_screen.barra.movable=.F.
		do c:\vfp9_mysql\mnufacturas.mpr
	else
		_screen.AddProperty("barra","")
		_screen.barra=CREATEOBJECT("toolbar_01")
		_screen.barra.dock(0)
		_screen.barra.visible=.T.
		_screen.barra.movable=.F.
		do c:\vfp9_mysql\mnuprincipal.mpr
	endif
ENDIF

*!*	_screen.opantalla_principal.btn_mostrar.Top= (_screen.Height/2) - (_screen.opantalla_principal.btn_mostrar.height/2)
*!*	_screen.opantalla_principal.btn_mostrar.Left= (_screen.width-_screen.opantalla_principal.btn_mostrar.width)+11
*!*	_screen.opantalla_principal.cnt_tareas.btn_ocultar.Top= (_screen.Height/2) - (_screen.opantalla_principal.cnt_tareas.btn_ocultar.height/2)
*!*	_screen.opantalla_principal.btn_mostrar.Visible= .T.

SET CONSOLE OFF

ON ERROR set console off

ON SHUTDOWN do c:\vfp9_mysql\prgs\fileexit.prg
READ EVENTS