&&Libreria de Rutinas libres para todos los módulos del sistema


*---Crea la Estructura Principal para el inicio del Sistema con el Servidor de Data-------*

	FUNCTION Crear_Estruc_Conex_MySQL(cIdSistema as String) as String
		LOCAL xServidor,xBasedeDatos,xPort,xId,xClave,xEstructura,xServerData
		
		&&Verificamos a que Servidor nos Conectamos [(local)] o [Remoto]
		xServidor     = ALLTRIM(LeerIni("SERVER","HOSTNAME","C:\vfp9_mysql\local.ini"))
		xPort         = ALLTRIM(LeerIni("SERVER","PUERTO","C:\vfp9_mysql\local.ini"))
		xDriver       = ALLTRIM(LeerIni("SERVER","DRIVER","C:\vfp9_mysql\local.ini"))
		
		&&establecemos parametros de conexion hacia la base de datos
		xBasedeDatos  = ALLTRIM(LeerIni(cIdSistema,"BD","C:\vfp9_mysql\local.ini"))	
		xId           = ALLTRIM(LeerIni(cIdSistema,"USER","C:\vfp9_mysql\local.ini"))
		xClave        = ALLTRIM(LeerIni(cIdSistema,"CLAVE","C:\vfp9_mysql\local.ini"))
			
		xEstructura   = "Driver=&xDriver;Server=&xServidor;Port=&xPort;Database=&xBasedeDatos;Uid=&xId;Pwd=&xClave;"
		RETURN xEstructura
	ENDFUNC
	
	*-------Crea o sobreescribe los parámetros de nuestro archivo .INI----------*
	FUNCTION EscribirIni(pSeccion as String,pClave as String,pCadena as String,pINIFile as String) as String		  
		  DECLARE integer WritePrivateProfileString IN WIN32API;
	      STRING pSeccion, STRING pClave, ;
	      STRING pCadena,  STRING pINIFile

	      WritePrivateProfileString(pSeccion,pClave,pCadena,pINIFile)
	ENDFUNC

	*-------Lee los parámetros de nuestra información .INI------------*
	FUNCTION LeerIni(pSeccion as String, pClave as string, pINIFile as string) as string
		LOCAL xDefault, xRetVal, xRetLen
		xDefault = ""
		xRetVal = Space(255)
		xRetLen = LEN(xRetVal)
		
		DECLARE integer GetPrivateProfileString IN WIN32API ;
		STRING pSeccion, STRING pClave, ;
		STRING xDefault, STRING @xRetVal, ;
		INTEGER xRetLen, STRING pINIFile
		
		xRet = GetPrivateProfileString(pSeccion, pClave, xDefault, ;
										@xRetVal, xRetLen, pINIFile)
		Return Left(xRetVal, AT(CHR(0),xRetVal)-1)
	ENDFUNC

	******************************************************************
	*         Conexiones a diferentes Servidores de Datos            *
	******************************************************************
	*-------Conexion al data server-----*
	FUNCTION Conectar_DB(pEstructura_Conexion as String) as String
		LOCAL xExtructura_Conexion
		xEstructura_Conexion=ALLTRIM(pEstructura_Conexion)
 	    Cn_Conectar=Sqlstringconnect(xEstructura_Conexion)
		IF Cn_Conectar<0 then
			RETURN 0
		ELSE
			RETURN Cn_Conectar
		ENDIF	
	ENDFUNC

	*--------cerrar la conexion con el data server----*
	FUNCTION Desconectar_DB(pConexion as Integer) as Integer
		IF pConexion>0 then
			SQLDISCONNECT(pConexion)
		ENDIF	
	ENDFUNC	
	
	*--------Modifica Campo Pedidos en Artículos------------*
	FUNCTION Campo_ped(xCodigo AS Integer) AS Integer
	    LOCAL lnConn, lnRet, llOwnConn, lnLock, lcMsg

	    IF VARTYPE(xCodigo) # "N" OR xCodigo <= 0
	        RETURN 0
	    ENDIF

	    lnConn    = 0
	    llOwnConn = .F.
	    lnRet     = 0
	    lnLock    = 0

	    *-----------------------------------------
	    * Crear una nueva conexion
	    *-----------------------------------------
        lnConn = Conectar_DB(_screen.cn)
        IF VARTYPE(lnConn) # "N" OR lnConn <= 0
            RETURN 0
        ENDIF
        llOwnConn = .T.

	    *-----------------------------------------
	    * BLOQUEAR TABLAS INVOLUCRADAS EN EL CÁLCULO
	    *   - articulos: WRITE (se actualiza pedidos)
	    *   - pedidos, pedidos_articulos: WRITE (se usan para el cálculo)
	    *-----------------------------------------
	    lnLock = MySQL_LockTables( ;
	                "LOCK", ;
	                "articulos WRITE, pedidos WRITE, pedidos_articulos WRITE", ;
	                lnConn )

	    *-----------------------------------------
	    * Llamada al Stored Procedure
	    *-----------------------------------------
	    lnRet = SQLEXEC(lnConn, ;
	        "CALL usp_pencinarti(?xCodigo)")

	    *-----------------------------------------
	    * Desbloquear SIEMPRE las tablas
	    *-----------------------------------------
	    lnLock = MySQL_LockTables("UNLOCK", "", lnConn)

	    *-----------------------------------------
	    * Si yo abrí la conexión, la cierro
	    *-----------------------------------------
	    IF llOwnConn
	        Desconectar_DB(lnConn)
	    ENDIF

	    RETURN IIF(lnRet < 0, 0, 1)
	ENDFUNC	

	*--------Modifica Campo Pedprov en Artículos------------*
	FUNCTION Campo_ppr(xCodicom as Integer) as Integer
	    LOCAL lnConn, lnRet, llOwnConn, lnLock, lcMsg

	    IF VARTYPE(xCodigo) # "N" OR xCodicom <= 0
	        RETURN 0
	    ENDIF

	    lnConn    = 0
	    llOwnConn = .F.
	    lnRet     = 0
	    lnLock    = 0

	    *-----------------------------------------
	    * Crear una nueva conexion
	    *-----------------------------------------
        lnConn = Conectar_DB(_screen.cn)
        IF VARTYPE(lnConn) # "N" OR lnConn <= 0
            RETURN 0
        ENDIF
        llOwnConn = .T.

	    *-----------------------------------------
	    * BLOQUEAR TABLAS INVOLUCRADAS EN EL CÁLCULO
	    *   - articulos: WRITE (se actualiza compras)
	    *   - compras, compras_articulos: WRITE (se usan para el cálculo)
	    *-----------------------------------------
	    lnLock = MySQL_LockTables( ;
	                "LOCK", ;
	                "articulos WRITE, compras WRITE, compras_articulos WRITE", ;
	                lnConn )

	    *-----------------------------------------
	    * Llamada al Stored Procedure
	    *-----------------------------------------
	    lnRet = SQLEXEC(lnConn, ;
	        "CALL usp_penpinarti(?xCodicom)")

	    *-----------------------------------------
	    * Desbloquear SIEMPRE las tablas
	    *-----------------------------------------
	    lnLock = MySQL_LockTables("UNLOCK", "", lnConn)

	    *-----------------------------------------
	    * Si yo abrí la conexión, la cierro
	    *-----------------------------------------
	    IF llOwnConn
	        Desconectar_DB(lnConn)
	    ENDIF

	    RETURN IIF(lnRet < 0, 0, 1)
	ENDFUNC
	
	*--------Bloqueo de tablas utilizadas en función Campo_ped------------*
	FUNCTION MySQL_LockTables(tcAccion, tcTablas, tnConexion)
	    LOCAL lnConn, llOwnConn, lnRet, lcSQL, lcAccion

	    lnConn    = 0
	    llOwnConn = .F.
	    lnRet     = 0

	    lcAccion = UPPER(ALLTRIM(tcAccion))

	    * Validar acción
	    IF lcAccion # "LOCK" AND lcAccion # "UNLOCK"
	        RETURN 0
	    ENDIF

	    * Armar sentencia SQL
	    IF lcAccion = "UNLOCK"
	        lcSQL = "UNLOCK TABLES"
	    ELSE
	        IF EMPTY(ALLTRIM(tcTablas))
	            RETURN 0
	        ENDIF
	        lcSQL = "LOCK TABLES " + ALLTRIM(tcTablas)
	    ENDIF

	    * Usar conexión existente o crear una nueva
	    IF VARTYPE(tnConexion) = "N" AND tnConexion > 0
	        lnConn    = tnConexion
	        llOwnConn = .F.
	    ELSE
	        lnConn = Conectar_DB(_screen.cn)
	        IF VARTYPE(lnConn) # "N" OR lnConn <= 0
	            RETURN 0
	        ENDIF
	        llOwnConn = .T.
	    ENDIF

	    * Ejecutar LOCK / UNLOCK
	    lnRet = SQLEXEC(lnConn, lcSQL)

	    * Si yo abrí la conexión, la cierro
	    IF llOwnConn
	        Desconectar_DB(lnConn)
	    ENDIF

	    RETURN IIF(lnRet < 0, 0, 1)
	ENDFUNC	

	*--------Ejecuta el Formulario Consfac------------*
	FUNCTION Ej_Consfac(xCodifac as Integer,xCond as Integer)
		IF xCodifac > 0 then
			pasfac = 1
			DO FORM consfactura WITH xCodifac, xCond
		ENDIF
	ENDFUNC 
	
	
	*-----Encriptamos la contraseña del Usuario------*
	FUNCTION Encriptar_Clave(pClave as String) as String
		LOCAL xClave,xClave_encripta		
		xClave = ALLTRIM(pClave)
		xClave_encripta = ''   
		For I=1 to Len(xClave)
		  Car = Substr(xClave,I,1)
		  xClave_encripta = xClave_encripta +Chr(Asc(Car)-8-i)
		Endfor
		Return (xClave_encripta)
	ENDFUNC
	

	*------Desencriptamos la contraseña del Usuario-------*
	FUNCTION Desencriptar_Clave(pClave as string) as String
		LOCAL xClave,xClave_encripta
		xClave = ALLTRIM(pClave)
		xClave_desencripta=''
		For I=1 to Len(xClave)
		  Car = Substr(xClave,I,1)
		  xClave_desencripta = xClave_desencripta +Chr(Asc(Car)+8+i)
		Endfor
		Return (xClave_desencripta)
	ENDFUNC
	
	
	*-------Crea directorio de carpetas----------*
	FUNCTION CrearDir(pDirectorio as String) as String
	  IF !DIRECTORY(pDirectorio) THEN
	  	MKDIR &pDirectorio
	  ENDIF
	ENDFUNC
		
	
	*------ Crear Cursor a Xml ---------*
	FUNCTION crear_CursorToXml(pAlias as String) as String
		LOCAL xAlias as String,xXmldata as XMLAdapter,adapter as XMLAdapter
		xAlias = ALLTRIM(pAlias)
		SELECT(xAlias)		
        adapter = CREATEOBJECT("XMLAdapter")
	    adapter.AddTableSchema(xAlias)
	    adapter.PreserveWhiteSpace= .T.
	    adapter.ToXML("xXmldata",,.F.,.T.,.F.)	    
	    adapter.ReleaseXML
	    RETURN xXmldata		
	ENDFUNC	
 
 
    *------Cierra cursores,dbf abiertos temporalmente------*
	FUNCTION Cerrar_Cursor(pAlias as String) as String
		LOCAL xAlias as String
		xAlias = ALLTRIM(pAlias)
		IF USED(xAlias) THEN
			USE IN &xAlias
		ENDIF		
	ENDFUNC
	
	
	*------Cierra TODOS los cursores,dbf abiertos temporalmente------*
	FUNCTION Cerrar_cursores()
		LOCAL lnI
		AUSED(laCursores) && Poner tablas abiertas en un array
		FOR lnI = 1 TO ALEN(laCursores) STEP 2
			SELECT (laCursores(lnI))
			IF ".TMP" $ DBF() && Es un cursor
				USE IN (laCursores(lnI)) &&Cerrarlo
			ENDIF
		ENDFOR
	ENDFUNC 
	

	*-----Añadir Conexión a otra unidad de red------*
	FUNCTION AddConnection(tcDrive,tcResource,tcPassword)
		LOCAL lnRet
		DECLARE INTEGER WNetAddConnection IN WIN32API;
				STRING @lpzRemoteName, ;
				STRING @lpzPassword,;
				STRING @lpzLocalName
		IF PARAMETERS() < 3
			lnRet = WNetAddConnection(@tcResource,0,@tcDrive)
		ELSE
			lnRet = WNetAddConnection(@tcResource,@tcPassword, @tcDrive)
		ENDIF
		IF lnRet # 0
			RETURN "Error " + ALLT(STR(lnRet)) + ;
			" al conectar el drive " + tcDrive
		ENDIF
		RETURN ""
	ENDFUNC
	
	
	*-------Cancelar Conexión de unidad de red-----*
	FUNCTION CancelConnection(tcDrive)
		LOCAL lnRet
		DECLARE INTEGER WNetCancelConnection IN WIN32API;
		STRING @lpzLocalName, ;
		INTEGER nForce
		lnRet = WNetCancelConnection( @tcDrive, 0)
		IF lnRet # 0
			RETURN "Error " + ALLT(STR(lnRet)) + ;
			" al desconectar el drive " + tcDrive
		ENDIF
		RETURN ""
	ENDFUNC


	*----Pedir conexion a unidad de red------*
	FUNCTION GetConnection(lcDrive)
		DECLARE INTEGER WNetGetConnection IN WIN32API ;
		STRING lpLocalName, ;
		STRING @lpRemoteName, ;
		INTEGER @lpnLength
		LOCAL cRemoteName, nLength, lcRet, llRet
		cRemoteName=SPACE(100)
		nLength = 100
		llRet = WNetGetConnection(lcDrive,@cRemoteName,@nLength)
		lcRet = LEFT(cRemoteName,AT(CHR(0),cRemoteName)-1)
		RETURN lcRet
	ENDFUNC	
	
	
	*----Convertir cadena numerica en valor numérico------*
	FUNCTION ConverNro(nCadena)
		LOCAL nNro as numeric
	    nNro = CAST(STRTRAN(nCadena,",",".") as numeric(15,3))
	    RETURN nNro
	ENDFUNC
	
	
	*----Obtener el Último dia del Mes
	FUNCTION Ult_Dia_Mes(fFecha as Date)
		LOCAL xFecha1,xFecha2
		xFecha1 = fFecha-(DAY(fFecha)-1) && Se ubica en el 1er dia del Mes
		xFecha2 = GOMONTH(xFecha1,1)-1   && se ubica en el Último dia del Mes
		RETURN xFecha2
	ENDFUNC
	

	*----Obtener  Dia
	FUNCTION Dia_Nombre(nDia as int)
		LOCAL xNombre_dia
			xNombre_dia= ICASE(nDia = 1,  "Domingo",;
							   nDia = 2,  "Lunes",;
							   nDia = 3,  "Martes",;
							   nDia = 4,  "Miercoles",;
							   nDia = 5,  "Jueves",;
							   nDia = 6,  "Viernes",;
							   nDia = 7,  "Sabado")
		RETURN xNombre_dia
	ENDFUNC


	*----Obtener  Mes
	FUNCTION Mes_Nombre(nMes as int)
		LOCAL xNombre_mes
			xNombre_mes= ICASE(nMes = 1,  "Enero",;
							   nMes = 2,  "Febrero",;
							   nMes = 3,  "Marzo",;
							   nMes = 4,  "Abril",;
							   nMes = 5,  "Mayo",;
							   nMes = 6,  "Junio",;
							   nMes = 7,  "Julio",;
							   nMes = 8,  "Agosto",;
							   nMes = 9,  "Setiembre",;
							   nMes = 10, "Octubre",;
							   nMes = 11, "Noviembre",;
							   nMes = 12, "Diciembre")
		RETURN xNombre_mes
	ENDFUNC
	
			
	*-------Obtener la serie del Disco Duro-----*
	FUNCTION Serie_DiscoDuro()
		loFSO = CREATEOBJECT("Scripting.FileSystemObject") 

		lcSerialNumber = lofso.drives("c:").serialnumber 

		*messagebox(str(lcSerialNumber))
		RETURN (str(lcSerialNumber))
	ENDFUNC 	
	
	
	***** obtener la serie de disco duro 2018 *****
	FUNCTION obtener_serie_discoduro()
		objWMI = Getobject("winmgmts:\\")

		cCadWMI = "Select * from Win32_PhysicalMedia"

		oSistema = objWMI.ExecQuery(cCadWMI)

		For Each Disco In oSistema

		     return Disco.SerialNumber

		Next
	ENDFUNC 
		
** EXPORTAR A EXCEL ***

PROCEDURE exp_to_excel
LPARAMETERS tcCursor

LOCAL loExcel as Object,;
    loBook as Object,;
    loSheet as Object
    

loExcel = CREATEOBJECT("Excel.Application")
loBook = loExcel.workbooks.ADD()
loSheet = loExcel.ActiveSheet

WAIT "Enviando Datos" WINDOW AT 20,50 NOWAIT 
SELECT (tcCursor)
lnFields = AFIELDS(laFields,tcCursor)
lnRow = 0
SCAN
    lnRow = m.lnRow + 1
    FOR lnCol = 1 TO FCOUNT(tcCursor)
        lcValor = EVALUATE(tcCursor+"."+FIELD(lncol))
        DO CASE
            CASE laFields[lnCol,2]="D" AND EMPTY(lcValor)
                lcValor = null
            CASE laFields[lnCol,2]="T"
                lcValor = TTOC(lcvalor)
            CASE laFields[lnCol,2]="L"
                lcValor = TRANSFORM(lcValor)
        ENDCASE
        loSheet.Cells(lnRow,lnCol).value = m.lcValor
    NEXT

ENDSCAN 

loBook.SaveAs(JUSTSTEM(tcCursor))
WAIT CLEAR 
loExcel.visible=.t.

** DEFINE CLASE FORMILARIO WAIT WINDOW **

DEFINE CLASS frmWait AS Form
    BorderStyle = 1
    Closable = .F.
    ControlBox = .F.
    MinButton = .F.
    MaxButton = .F.
    AutoCenter = .T.
    ShowWindow = 0
    AlwaysOnTop = .T.
    Width = 300
    Height = 50
    Caption = ""
    TitleBar= 0
    BackColor = RGB(0,0,0)

    ADD OBJECT lblMsg AS Label WITH ;
        Alignment = 2, ;
        AutoSize = .T., ;
        Top = 43, ;
        Left = 0, ;
        Caption = "", ;
        BackStyle= 0, ;
        FontBold= .T., ;
        FontItalic= .T., ;
        ForeColor=RGB(0,255,0)

    PROCEDURE Init(tcMensaje)
        IF VARTYPE(tcMensaje) <> "C" OR EMPTY(tcMensaje)
            tcMensaje = "Procesando..."
        ENDIF
        THIS.SetMessage(tcMensaje)
    ENDPROC

    PROCEDURE SetMessage(tcMensaje)
        IF VARTYPE(tcMensaje) <> "C"
            tcMensaje = TRANSFORM(tcMensaje)
        ENDIF
        THIS.lblMsg.Caption = tcMensaje

        * Recalcular centrado del texto
        THIS.lblMsg.Left = INT((THIS.Width - THIS.lblMsg.Width) / 2)
        THIS.lblMsg.Top  = INT((THIS.Height - THIS.lblMsg.Height) / 2)

        THIS.Refresh()
        DOEVENTS
    ENDPROC
ENDDEFINE

*****************************************************************************


*!*	FUNCTION APLICACION_ESTA_EJECUTANDOSE
*!*	LParameters tcNombreAplicacion
*!*	Local llResultado, lcIdentificador, lcNombreTestigo
*!*	 
*!*	  if Empty(tcNombreAplicacion)
*!*	Return (.T.)
*!*	  endif
*!*	 
*!*	  lcIdentificador = StrTran(tcNombreAplicacion, " ", "")
*!*	 
*!*	  lcNombreTestigo = "_Testigo_" + lcIdentificador
*!*	 
*!*	  if WExist(lcNombreTestigo)
*!*	Return (.T.)
*!*	  endif
*!*	 
*!*	  DECLARE INTEGER FindWindow IN WIN32API AS API_EncontrarVentana ;
*!*	STRING, ;
*!*	STRING
*!*	 
*!*	  if API_EncontrarVentana(.NULL., lcIdentificador) > 0
*!*	Return (.T.)
*!*	  endif
*!*	 
*!*	  DEFINE WINDOW &lcNombreTestigo ;
*!*	FROM  1, 1 ;
*!*	TO    2, 2 ;
*!*	TITLE lcIdentificador ;
*!*	IN    DESKTOP
*!*	 
*!*	  Return (.F.)
*!*	 
*!*	ENDFUNC