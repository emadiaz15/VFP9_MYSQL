*=========================================================
* grid_articulos_ui.prg
* Librería común para formularios que muestran artículos en
* grids nativos VFP o grids ActiveX.
*
* Responsabilidades principales:
* - Inicializar/bindear grids de artículos
* - Calcular colores dinámicos por situación de stock
* - Mostrar detalle de stock en panel embebido o form flotante
* - Gestionar selección visual de fila
* - Agregar opciones estándar al menú contextual
* - Permitir agregar artículos a temp_solicitud_compra
*
* Uso típico:
* 1) Bind del grid (nativo o ActiveX)
* 2) Refrescar cursor visual de stock
* 3) Configurar colores/eventos
* 4) Abrir/cerrar panel o form de detalle
*=========================================================

*=========================================================
* GridArt_Init
* Inicializa el soporte estándar para grids nativos:
* guarda nombres de grid/cursor/campos, crea propiedades
* auxiliares del formulario y construye los objetos visuales
* base (shape de selección y panel de stock).
*=========================================================
FUNCTION GridArt_Init
LPARAMETERS toForm, tcGridName, tcCursorName, tcFieldArtCodi, tcFieldArtDesc

IF VARTYPE(toForm) # "O"
    RETURN .F.
ENDIF

IF EMPTY(tcGridName) OR EMPTY(tcCursorName) OR EMPTY(tcFieldArtCodi) OR EMPTY(tcFieldArtDesc)
    RETURN .F.
ENDIF

IF !PEMSTATUS(toForm, "xGridArtFocusZone", 5)
    toForm.AddProperty("xGridArtFocusZone", "GRID")
ELSE
    toForm.xGridArtFocusZone = "GRID"
ENDIF

IF !PEMSTATUS(toForm, "xGridArtMode", 5)
    toForm.AddProperty("xGridArtMode", "NATIVE")
ELSE
    toForm.xGridArtMode = "NATIVE"
ENDIF

IF !PEMSTATUS(toForm, "xGridArtName", 5)
    toForm.AddProperty("xGridArtName", tcGridName)
ELSE
    toForm.xGridArtName = tcGridName
ENDIF

IF !PEMSTATUS(toForm, "xGridArtCursor", 5)
    toForm.AddProperty("xGridArtCursor", tcCursorName)
ELSE
    toForm.xGridArtCursor = tcCursorName
ENDIF

IF !PEMSTATUS(toForm, "xGridArtColorCursor", 5)
    toForm.AddProperty("xGridArtColorCursor", "cur_gridart_color")
ELSE
    toForm.xGridArtColorCursor = "cur_gridart_color"
ENDIF

IF !PEMSTATUS(toForm, "xGridArtFieldCodi", 5)
    toForm.AddProperty("xGridArtFieldCodi", tcFieldArtCodi)
ELSE
    toForm.xGridArtFieldCodi = tcFieldArtCodi
ENDIF

IF !PEMSTATUS(toForm, "xGridArtFieldDesc", 5)
    toForm.AddProperty("xGridArtFieldDesc", tcFieldArtDesc)
ELSE
    toForm.xGridArtFieldDesc = tcFieldArtDesc
ENDIF

IF !PEMSTATUS(toForm, "xCurRec", 5)
    toForm.AddProperty("xCurRec", 1)
ELSE
    toForm.xCurRec = 1
ENDIF

IF !PEMSTATUS(toForm, "xPrimerFoco", 5)
    toForm.AddProperty("xPrimerFoco", .T.)
ELSE
    toForm.xPrimerFoco = .T.
ENDIF

IF !PEMSTATUS(toForm, "xTipStockAbierto", 5)
    toForm.AddProperty("xTipStockAbierto", .F.)
ELSE
    toForm.xTipStockAbierto = .F.
ENDIF

IF !PEMSTATUS(toForm, "xGridArtBound", 5)
    toForm.AddProperty("xGridArtBound", .T.)
ELSE
    toForm.xGridArtBound = .T.
ENDIF

=GridArt_CreateSelectionShape(toForm)
=GridArt_CreateStockPanel(toForm)

RETURN .T.
ENDFUNC


*=========================================================
* GridArt_BindNative
* Alias semántico de GridArt_Init para formularios que usan
* grid nativo VFP. Simplifica el bind desde el Init del form.
*=========================================================
FUNCTION GridArt_BindNative
LPARAMETERS toForm, tcGridName, tcCursorName, tcFieldArtCodi, tcFieldArtDesc

RETURN GridArt_Init(toForm, tcGridName, tcCursorName, tcFieldArtCodi, tcFieldArtDesc)
ENDFUNC


*=========================================================
* GridArt_ShowTooltip
* Abre el panel de stock si todavía no está visible.
* Se usa normalmente desde MouseMove o eventos equivalentes.
*=========================================================
FUNCTION GridArt_ShowTooltip
LPARAMETERS toForm

IF VARTYPE(toForm) # "O"
    RETURN .F.
ENDIF

IF !PEMSTATUS(toForm, "xTipStockAbierto", 5) OR !toForm.xTipStockAbierto
    RETURN GridArt_Open(toForm)
ENDIF

RETURN .T.
ENDFUNC


*=========================================================
* GridArt_BindActiveX
* Inicializa el soporte estándar para grids ActiveX:
* guarda el nombre del grid y las columnas donde están
* código y descripción del artículo, y prepara el panel
* flotante de detalle.
*=========================================================
FUNCTION GridArt_BindActiveX
LPARAMETERS toForm, tcGridName, tnColArtCodi, tnColArtDesc

IF VARTYPE(toForm) # "O"
    RETURN .F.
ENDIF

IF EMPTY(tcGridName) OR VARTYPE(tnColArtCodi) # "N" OR VARTYPE(tnColArtDesc) # "N"
    RETURN .F.
ENDIF

IF !PEMSTATUS(toForm, "xGridArtFocusZone", 5)
    toForm.AddProperty("xGridArtFocusZone", "GRID")
ELSE
    toForm.xGridArtFocusZone = "GRID"
ENDIF

IF !PEMSTATUS(toForm, "xGridArtMode", 5)
    toForm.AddProperty("xGridArtMode", "ACTIVEX")
ELSE
    toForm.xGridArtMode = "ACTIVEX"
ENDIF

IF !PEMSTATUS(toForm, "xGridArtName", 5)
    toForm.AddProperty("xGridArtName", tcGridName)
ELSE
    toForm.xGridArtName = tcGridName
ENDIF

IF !PEMSTATUS(toForm, "xGridArtColCodi", 5)
    toForm.AddProperty("xGridArtColCodi", tnColArtCodi)
ELSE
    toForm.xGridArtColCodi = tnColArtCodi
ENDIF

IF !PEMSTATUS(toForm, "xGridArtColDesc", 5)
    toForm.AddProperty("xGridArtColDesc", tnColArtDesc)
ELSE
    toForm.xGridArtColDesc = tnColArtDesc
ENDIF

IF !PEMSTATUS(toForm, "xPrimerFoco", 5)
    toForm.AddProperty("xPrimerFoco", .T.)
ELSE
    toForm.xPrimerFoco = .T.
ENDIF

IF !PEMSTATUS(toForm, "xTipStockAbierto", 5)
    toForm.AddProperty("xTipStockAbierto", .F.)
ELSE
    toForm.xTipStockAbierto = .F.
ENDIF

IF !PEMSTATUS(toForm, "xGridArtBound", 5)
    toForm.AddProperty("xGridArtBound", .T.)
ELSE
    toForm.xGridArtBound = .T.
ENDIF

=GridArt_CreateStockPanel(toForm)
=GridArt_CloseStockPanel(toForm)

RETURN .T.
ENDFUNC


*=========================================================
* GridArt_BindPedGrid
* Atajo para formularios ActiveX con layout estándar:
* asume grid1, columna 3 = código y columna 4 = descripción.
*=========================================================
FUNCTION GridArt_BindPedGrid
LPARAMETERS toForm

RETURN GridArt_BindActiveX(toForm, "grid1", 3, 4)
ENDFUNC


*=========================================================
* GridArt_Unbind
* Limpia el estado visual del helper: cierra paneles,
* libera bindings y deja el formulario marcado como no ligado.
*=========================================================
FUNCTION GridArt_Unbind
LPARAMETERS toForm

IF VARTYPE(toForm) # "O"
    RETURN .F.
ENDIF

=GridArt_CloseStockPanel(toForm)

*-- Cerrar form flotante de stock si quedo abierto
IF PEMSTATUS(toForm, "oStockPopForm", 5) AND VARTYPE(toForm.oStockPopForm) = "O"
    TRY
        toForm.oStockPopForm.Release()
    CATCH
    ENDTRY
    toForm.oStockPopForm = .NULL.
ENDIF

TRY
    UNBINDEVENTS(toForm)
CATCH
ENDTRY

IF PEMSTATUS(toForm, "xGridArtBound", 5)
    toForm.xGridArtBound = .F.
ENDIF

RETURN .T.
ENDFUNC



*=========================================================
* GridArt_CreateSelectionShape
* Crea el shape usado como borde visual de la fila activa
* en grids nativos.
*=========================================================
FUNCTION GridArt_CreateSelectionShape
LPARAMETERS toForm

IF VARTYPE(toForm) # "O"
    RETURN .F.
ENDIF

IF !PEMSTATUS(toForm, "shpSelRow", 5)
    toForm.AddObject("shpSelRow", "Shape")
ENDIF

WITH toForm.shpSelRow
    .BackStyle   = 0
    .BorderColor = RGB(30,30,30)
    .BorderWidth = 2
    .Visible     = .F.
    .ZOrder(0)
ENDWITH

RETURN .T.
ENDFUNC


*=========================================================
* GridArt_CreateStockPanel
* Crea los controles visuales del panel embebido de detalle
* de stock: shape, título, botón cerrar y editbox.
*=========================================================
FUNCTION GridArt_CreateStockPanel
LPARAMETERS toForm

IF VARTYPE(toForm) # "O"
    RETURN .F.
ENDIF

IF !PEMSTATUS(toForm, "shpTipStock", 5)
    toForm.AddObject("shpTipStock", "Shape")
ENDIF

WITH toForm.shpTipStock
    .Left          = 500
    .Top           = 120
    .Width         = 400
    .Height        = 300
    .BackColor     = RGB(255,255,210)
    .BorderColor   = RGB(80,80,80)
    .BorderWidth   = 1
    .SpecialEffect = 0
    .Visible       = .F.
    .ZOrder(0)
ENDWITH

IF !PEMSTATUS(toForm, "lblTipTitulo", 5)
    toForm.AddObject("lblTipTitulo", "Label")
ENDIF

WITH toForm.lblTipTitulo
    .Left      = toForm.shpTipStock.Left + 10
    .Top       = toForm.shpTipStock.Top + 8
    .Width     = 220
    .Height    = 20
    .Caption   = "Detalle de Stock"
    .FontBold  = .T.
    .FontSize  = 10
    .BackStyle = 0
    .Visible   = .F.
    .ZOrder(0)
ENDWITH

IF !PEMSTATUS(toForm, "cmdTipCerrar", 5)
    toForm.AddObject("cmdTipCerrar", "CommandButton")
ENDIF

WITH toForm.cmdTipCerrar
    .Left      = toForm.shpTipStock.Left + toForm.shpTipStock.Width - 32
    .Top       = toForm.shpTipStock.Top + 5
    .Width     = 22
    .Height    = 20
    .Caption   = "X"
    .FontBold  = .T.
    .Visible   = .F.
    .ZOrder(0)
ENDWITH

IF !PEMSTATUS(toForm, "edtTipStock", 5)
    toForm.AddObject("edtTipStock", "EditBox")
ENDIF

WITH toForm.edtTipStock
    .Left          = toForm.shpTipStock.Left + 10
    .Top           = toForm.shpTipStock.Top + 30
    .Width         = toForm.shpTipStock.Width - 20
    .Height        = toForm.shpTipStock.Height - 40
    .FontName      = "Courier New"
    .FontSize      = 9
    .ReadOnly      = .T.
    .Enabled       = .T.
    .BackColor     = RGB(255,255,210)
    .ForeColor     = RGB(30,30,30)
    .BorderStyle   = 0
    .ScrollBars    = 0
    .Value         = ""
    .Visible       = .F.
    .ZOrder(0)
ENDWITH

RETURN .T.
ENDFUNC


*=========================================================
* GridArt_Open
* Muestra el panel embebido de stock y fuerza el refresco
* del contenido según el artículo actualmente seleccionado.
*=========================================================
FUNCTION GridArt_Open
LPARAMETERS toForm

IF VARTYPE(toForm) # "O"
    RETURN .F.
ENDIF

IF !PEMSTATUS(toForm, "shpTipStock", 5)
    =GridArt_CreateStockPanel(toForm)
ENDIF

toForm.shpTipStock.Visible  = .T.
toForm.lblTipTitulo.Visible = .T.
toForm.cmdTipCerrar.Visible = .T.
toForm.edtTipStock.Visible  = .T.
toForm.xTipStockAbierto     = .T.

=GridArt_Refresh(toForm)

*-- Mientras el detalle esta abierto, la rueda debe pertenecer al panel.
toForm.xGridArtFocusZone = "TIP"

IF PEMSTATUS(toForm, "edtTipStock", 5)
    TRY
        toForm.edtTipStock.SetFocus()
    CATCH
    ENDTRY
ENDIF


RETURN .T.
ENDFUNC

*=========================================================
* GridArt_OpenStockPanel
* Wrapper de compatibilidad hacia atrás para código viejo
* que abría el panel de stock en grids nativos.
*=========================================================
FUNCTION GridArt_OpenStockPanel
LPARAMETERS toForm

RETURN GridArt_Open(toForm)
ENDFUNC


*=========================================================
* GridArt_OpenStockPanel_ActiveX
* Wrapper de compatibilidad hacia atrás para formularios
* ActiveX que usan la apertura estándar del panel.
*=========================================================
FUNCTION GridArt_OpenStockPanel_ActiveX
LPARAMETERS toForm

RETURN GridArt_Open(toForm)
ENDFUNC

*=========================================================
* GridArt_OpenStockPanel_ActiveX_Bound
* Wrapper de compatibilidad que abre el panel de stock
* usando la configuración ActiveX ya guardada en el form.
*=========================================================
FUNCTION GridArt_OpenStockPanel_ActiveX_Bound
LPARAMETERS toForm

RETURN GridArt_Open(toForm)
ENDFUNC


*=========================================================
* GridArt_CloseStockPanel
* Oculta todos los controles del panel embebido y limpia
* el contenido textual del detalle de stock.
*=========================================================
FUNCTION GridArt_CloseStockPanel
LPARAMETERS toForm

IF VARTYPE(toForm) # "O"
    RETURN .F.
ENDIF

IF PEMSTATUS(toForm, "shpTipStock", 5)
    toForm.shpTipStock.Visible = .F.
ENDIF
IF PEMSTATUS(toForm, "lblTipTitulo", 5)
    toForm.lblTipTitulo.Visible = .F.
ENDIF
IF PEMSTATUS(toForm, "cmdTipCerrar", 5)
    toForm.cmdTipCerrar.Visible = .F.
ENDIF
IF PEMSTATUS(toForm, "edtTipStock", 5)
    toForm.edtTipStock.Visible = .F.
    toForm.edtTipStock.Value   = ""
ENDIF
IF PEMSTATUS(toForm, "xTipStockAbierto", 5)
    toForm.xTipStockAbierto = .F.
ENDIF

RETURN .T.
ENDFUNC


*=========================================================
* GridArt_OnEsc
* Cierra el panel de stock del formulario activo.
* Se puede ligar a ON KEY LABEL ESC.
*=========================================================
FUNCTION GridArt_OnEsc
LOCAL loForm

loForm = _SCREEN.ActiveForm
IF VARTYPE(loForm) = "O"
    =GridArt_CloseStockPanel(loForm)
ENDIF

RETURN .T.
ENDFUNC


*=========================================================
* GridArt_Refresh
* Decide cómo refrescar el detalle de stock según el modo
* configurado del formulario: NATIVE o ACTIVEX.
*=========================================================
FUNCTION GridArt_Refresh
LPARAMETERS toForm

IF VARTYPE(toForm) # "O"
    RETURN .F.
ENDIF

IF !PEMSTATUS(toForm, "xGridArtMode", 5)
    RETURN GridArt_UpdateStockPanel(toForm)
ENDIF

DO CASE
    CASE UPPER(ALLTRIM(toForm.xGridArtMode)) == "ACTIVEX"
        RETURN GridArt_UpdateStockPanel_ActiveX_Bound(toForm)

    CASE UPPER(ALLTRIM(toForm.xGridArtMode)) == "NATIVE"
        RETURN GridArt_UpdateStockPanel(toForm)
ENDCASE

RETURN .F.
ENDFUNC

*=========================================================
* GridArt_UpdateStockPanel
* Lee el artículo actual desde un cursor ligado a grid nativo,
* consulta stock/pedidos/compras en MySQL y arma el texto
* mostrado en el panel embebido.
*=========================================================
FUNCTION GridArt_UpdateStockPanel
LPARAMETERS toForm

LOCAL lcCur, lcFieldCodi, lcFieldDesc
LOCAL lnArtCodi, lcArtDesc
LOCAL lnConn, lnRet
LOCAL lnStock, lnPedidos, lnPedProv, lnMin, lnPct, lnPos, lnDif, lnAlerta
LOCAL lcTip

IF VARTYPE(toForm) # "O"
    RETURN .F.
ENDIF

IF !PEMSTATUS(toForm, "xTipStockAbierto", 5) OR !toForm.xTipStockAbierto
    RETURN .F.
ENDIF

lcCur       = toForm.xGridArtCursor
lcFieldCodi = toForm.xGridArtFieldCodi
lcFieldDesc = toForm.xGridArtFieldDesc

IF EMPTY(lcCur) OR !USED(lcCur) OR RECCOUNT(lcCur) = 0 OR EOF(lcCur)
    RETURN .F.
ENDIF

lnArtCodi = VAL(TRANSFORM(EVALUATE(lcCur + "." + lcFieldCodi)))
lcArtDesc = ALLTRIM(TRANSFORM(EVALUATE(lcCur + "." + lcFieldDesc)))

IF lnArtCodi <= 5
    IF PEMSTATUS(toForm, "edtTipStock", 5)
        toForm.edtTipStock.Value = "El registro actual no corresponde a un artículo codificado."
    ENDIF
    RETURN .T.
ENDIF

lnConn = Conectar_DB(_screen.cn)
IF VARTYPE(lnConn) # "N" OR lnConn <= 0
    RETURN .F.
ENDIF

lnRet = SQLEXEC(lnConn, ;
    "SELECT a.art_stock, a.pedidos, a.pedprov, a.art_stmin, " + ;
    "IFNULL(m.art_pct_alerta, 0) AS art_pct_alerta " + ;
    "FROM articulos a " + ;
    "LEFT JOIN art_metricas m ON m.art_codi = a.art_codi " + ;
    "WHERE a.art_codi = ?lnArtCodi", ;
    "cur_tip_art_prg")

Desconectar_DB(lnConn)

IF lnRet <= 0 OR !USED("cur_tip_art_prg") OR RECCOUNT("cur_tip_art_prg") = 0
    IF USED("cur_tip_art_prg")
        USE IN cur_tip_art_prg
    ENDIF
    RETURN .F.
ENDIF

lnStock   = VAL(TRANSFORM(NVL(cur_tip_art_prg.art_stock, 0)))
lnPedidos = VAL(TRANSFORM(NVL(cur_tip_art_prg.pedidos, 0)))
lnPedProv = VAL(TRANSFORM(NVL(cur_tip_art_prg.pedprov, 0)))
lnMin     = VAL(TRANSFORM(NVL(cur_tip_art_prg.art_stmin, 0)))
lnPct     = VAL(TRANSFORM(NVL(cur_tip_art_prg.art_pct_alerta, 0)))

lnPos = lnStock + lnPedProv - lnPedidos
lnDif = lnPos - lnMin
lnAlerta = lnMin * (1 + (lnPct / 100))


IF LEN(lcArtDesc) > 180
    lcArtDesc = LEFT(lcArtDesc, 180) + "..."
ENDIF

lcTip = ;
    "Codigo        : " + TRANSFORM(lnArtCodi)                         + CHR(13) + ;
    "Descripcion   : " + lcArtDesc                                     + CHR(13) + ;
    "Pct. alerta   : " + TRANSFORM(lnPct) + "%"                       + CHR(13) + ;
    "-----------------------------------"                               + CHR(13) + ;
    "Stock         : " + TRANSFORM(lnStock,   "999,999,999.999")      + CHR(13) + ;
    "Compras       : " + TRANSFORM(lnPedProv, "999,999,999.999")      + CHR(13) + ;
    "Pedidos       : " + TRANSFORM(lnPedidos, "999,999,999.999")      + CHR(13) + ;
    "-----------------------------------"                               + CHR(13) + ;
    "Posicion      : " + TRANSFORM(lnPos,     "999,999,999.999")      + CHR(13) + ;
    "Pos. minima   : " + TRANSFORM(lnMin,     "999,999,999.999") + ;
        " (alerta en " + ALLTRIM(TRANSFORM(lnAlerta, "999,999,999.99")) + ")" + CHR(13) + ;
    "Diferencia    : " + IIF(lnDif >= 0, "+", "-") + TRANSFORM(ABS(lnDif), "999,999,999.999")


USE IN cur_tip_art_prg

IF PEMSTATUS(toForm, "edtTipStock", 5)
    toForm.edtTipStock.Value = lcTip
ENDIF

RETURN .T.
ENDFUNC


*=========================================================
* GridArt_DynBack
* Calcula el color de fondo de una fila según la cercanía
* entre la posición actual y el umbral de alerta de stock.
*=========================================================
FUNCTION GridArt_DynBack
LPARAMETERS tnPos, tnMin, tnPct, tnPedProv

LOCAL lnPuntoAlerta, lnDif, lnRatio
LOCAL lnR, lnG, lnB

tnPos = VAL(TRANSFORM(NVL(tnPos, 0)))
tnMin = VAL(TRANSFORM(NVL(tnMin, 0)))
tnPct = VAL(TRANSFORM(NVL(tnPct, 0)))

lnPuntoAlerta = tnMin * (1 + (tnPct / 100))

IF tnPos < 0
    IF lnPuntoAlerta > 0
        lnRatio = MIN(1, (-tnPos) / lnPuntoAlerta)
    ELSE
        lnRatio = 1
    ENDIF
    lnR = INT(160 - (70 * lnRatio))
    lnG = INT(100 - (70 * lnRatio))
    lnB = 255
    RETURN RGB(lnR, lnG, lnB)
ENDIF

IF lnPuntoAlerta <= 0 OR tnPos > lnPuntoAlerta
    RETURN RGB(255,255,255)
ENDIF

lnDif   = lnPuntoAlerta - tnPos
lnRatio = MIN(1, MAX(0, lnDif / lnPuntoAlerta))
lnR = 255
lnG = INT(235 - (135 * lnRatio))
lnB = INT(235 - (135 * lnRatio))

RETURN RGB(lnR, lnG, lnB)
ENDFUNC



*=========================================================
* GridArt_DynFore
* Calcula el color de fuente de una fila según el estado
* de stock respecto de la posición mínima y la alerta.
*=========================================================
FUNCTION GridArt_DynFore
LPARAMETERS tnPos, tnMin, tnPct, tnPedProv

LOCAL lnUmbral

tnPos = VAL(TRANSFORM(NVL(tnPos, 0)))
tnMin = VAL(TRANSFORM(NVL(tnMin, 0)))
tnPct = VAL(TRANSFORM(NVL(tnPct, 20)))

IF tnPos < 0
    RETURN RGB(255, 255, 255)
ENDIF

IF tnMin <= 0
    RETURN RGB(0,0,0)
ENDIF

lnUmbral = tnMin * (1 + (tnPct / 100))

IF tnPos < lnUmbral
    RETURN RGB(40,40,40)
ENDIF

RETURN RGB(0,0,0)
ENDFUNC


*=========================================================
* GridArt_GetDynBack
* Devuelve el color de fondo dinámico de la fila actual
* leyendo los datos precalculados del cursor visual auxiliar.
*=========================================================
FUNCTION GridArt_GetDynBack
LPARAMETERS toForm

LOCAL lcCur, lcColorCur
LOCAL lnRec, lnPos, lnMin, lnPct, lnPedProv

IF VARTYPE(toForm) # "O"
    RETURN RGB(255,255,255)
ENDIF

lcCur      = toForm.xGridArtCursor
lcColorCur = toForm.xGridArtColorCursor

IF EMPTY(lcCur) OR EMPTY(lcColorCur)
    RETURN RGB(255,255,255)
ENDIF

IF !USED(lcCur) OR !USED(lcColorCur)
    RETURN RGB(255,255,255)
ENDIF

lnRec = RECNO(lcCur)

IF lnRec <= 0 OR lnRec > RECCOUNT(lcColorCur)
    RETURN RGB(255,255,255)
ENDIF

GO lnRec IN (lcColorCur)

lnPos     = VAL(TRANSFORM(NVL(EVALUATE(lcColorCur + ".xposicion"),      0)))
lnMin     = VAL(TRANSFORM(NVL(EVALUATE(lcColorCur + ".art_stmin"),      0)))
lnPct     = VAL(TRANSFORM(NVL(EVALUATE(lcColorCur + ".art_pct_alerta"), 20)))
lnPedProv = VAL(TRANSFORM(NVL(EVALUATE(lcColorCur + ".pedprov"),        0)))

RETURN GridArt_DynBack(lnPos, lnMin, lnPct, lnPedProv)
ENDFUNC

*=========================================================
* GridArt_GetDynFore
* Se llama desde el form:
* RETURN GridArt_GetDynFore(THISFORM)
*=========================================================
FUNCTION GridArt_GetDynFore
LPARAMETERS toForm

LOCAL lcCur, lcColorCur, lnRec
LOCAL lnPos, lnMin, lnPct, lnPedProv

IF VARTYPE(toForm) # "O"
    RETURN RGB(0,0,0)
ENDIF

lcCur      = toForm.xGridArtCursor
lcColorCur = toForm.xGridArtColorCursor

IF EMPTY(lcCur) OR EMPTY(lcColorCur)
    RETURN RGB(0,0,0)
ENDIF

IF !USED(lcCur) OR !USED(lcColorCur)
    RETURN RGB(0,0,0)
ENDIF

SELECT (lcCur)
lnRec = RECNO()

IF lnRec <= 0
    RETURN RGB(0,0,0)
ENDIF

IF SEEK(STR(lnRec, 6), lcColorCur, "xrecno")
    lnPos     = VAL(TRANSFORM(NVL(EVALUATE(lcColorCur + ".xposicion"), 0)))
    lnMin     = VAL(TRANSFORM(NVL(EVALUATE(lcColorCur + ".art_stmin"), 0)))
    lnPct     = VAL(TRANSFORM(NVL(EVALUATE(lcColorCur + ".art_pct_alerta"), 20)))
    lnPedProv = VAL(TRANSFORM(NVL(EVALUATE(lcColorCur + ".pedprov"), 0)))

    RETURN GridArt_DynFore(lnPos, lnMin, lnPct, lnPedProv)
ENDIF

RETURN RGB(0,0,0)
ENDFUNC


*!*	*=========================================================
*!*	* GridArt_GetDynBold
*!*	* Devuelve .T. si la fila debe mostrarse en negrita
*!*	* (posicion negativa = estado critico / lila)
*!*	*=========================================================
*!*	FUNCTION GridArt_GetDynBold
*!*	LPARAMETERS toForm

*!*	LOCAL lcCur, lcColorCur, lnRec, lnPos

*!*	IF VARTYPE(toForm) # "O"
*!*	    RETURN .F.
*!*	ENDIF

*!*	lcCur      = toForm.xGridArtCursor
*!*	lcColorCur = toForm.xGridArtColorCursor

*!*	IF EMPTY(lcCur) OR EMPTY(lcColorCur)
*!*	    RETURN .F.
*!*	ENDIF

*!*	IF !USED(lcCur) OR !USED(lcColorCur)
*!*	    RETURN .F.
*!*	ENDIF

*!*	SELECT (lcCur)
*!*	lnRec = RECNO()

*!*	IF lnRec <= 0
*!*	    RETURN .F.
*!*	ENDIF

*!*	IF SEEK(STR(lnRec, 6), lcColorCur, "xrecno")
*!*	    lnPos = VAL(TRANSFORM(NVL(EVALUATE(lcColorCur + ".xposicion"), 0)))
*!*	    RETURN (lnPos < 0)
*!*	ENDIF

*!*	RETURN .F.
*!*	ENDFUNC



*=========================================================
* GridArt_ConfigurarColores
* Aplica expresiones DynamicBackColor / DynamicForeColor
* al grid nativo y deja el helper visual listo para uso.
*=========================================================
FUNCTION GridArt_ConfigurarColores
LPARAMETERS toForm

LOCAL lnCol, lcGrid, loGrid, loCol
LOCAL lcExpBack, lcExpFore
LOCAL lcOldBack, lcOldFore, lcFixedCols, llFixed

IF VARTYPE(toForm) # "O"
    RETURN .F.
ENDIF

lcGrid = toForm.xGridArtName
IF EMPTY(lcGrid) OR !PEMSTATUS(toForm, lcGrid, 5)
    RETURN .F.
ENDIF

loGrid = EVALUATE("toForm." + lcGrid)

lcExpBack   = "GridArt_GetDynBack(THISFORM)"
lcExpFore   = "GridArt_GetDynFore(THISFORM)"
*!*	lcExpBold   = "GridArt_GetDynBold(THISFORM)"
lcFixedCols = ""

WITH loGrid
    .HighlightStyle     = 0

    FOR lnCol = 1 TO .ColumnCount
        loCol = .Columns(lnCol)

        lcOldBack = ALLTRIM(TRANSFORM(loCol.DynamicBackColor))
        lcOldFore = ALLTRIM(TRANSFORM(loCol.DynamicForeColor))

        llFixed = !EMPTY(lcOldBack) AND ;
                  !("GridArt_GetDynBack" $ lcOldBack) AND ;
                  !("GridArt_GetDynFore" $ lcOldFore)

        IF llFixed
            lcFixedCols = lcFixedCols + IIF(EMPTY(lcFixedCols), "", ",") + TRANSFORM(lnCol)
            LOOP
        ELSE
            loCol.DynamicBackColor = lcExpBack
            loCol.DynamicForeColor = lcExpFore
*!*	            loCol.DynamicFontBold  = lcExpBold
        ENDIF

        loCol.Sparse = .T.

        IF PEMSTATUS(loCol, "Text1", 5)
            WITH loCol.Text1
                .BorderStyle = 0
                .Margin      = 0
                IF PEMSTATUS(loCol.Text1, "BackStyle", 5)
                    .BackStyle = 0
                ENDIF
            ENDWITH
        ENDIF
    ENDFOR
ENDWITH

IF !PEMSTATUS(toForm, "xGridArtFixedColumns", 5)
    toForm.AddProperty("xGridArtFixedColumns", lcFixedCols)
ELSE
    toForm.xGridArtFixedColumns = lcFixedCols
ENDIF

=GridArt_SyncActiveColor(toForm)

loGrid.Refresh()

RETURN .T.
ENDFUNC



FUNCTION GridArt_EvalColor
LPARAMETERS tcExpr, tnDefault

LOCAL lnColor
lnColor = tnDefault

IF !EMPTY(tcExpr)
    TRY
        lnColor = EVALUATE(tcExpr)
    CATCH
        lnColor = tnDefault
    ENDTRY
ENDIF

RETURN lnColor
ENDFUNC


FUNCTION GridArt_IsFixedColumn
LPARAMETERS toForm, tnCol

LOCAL lcFixed

IF VARTYPE(toForm) # "O"
    RETURN .F.
ENDIF

IF !PEMSTATUS(toForm, "xGridArtFixedColumns", 5)
    RETURN .F.
ENDIF

lcFixed = "," + ALLTRIM(toForm.xGridArtFixedColumns) + ","

RETURN ("," + TRANSFORM(tnCol) + ",") $ lcFixed
ENDFUNC




FUNCTION GridArt_SyncActiveColor
LPARAMETERS toForm

LOCAL lcGrid, loGrid, lnCol, loCol
LOCAL lnBack, lnFore, lnColBack, lnColFore
LOCAL llFixed, lcDynExpr

IF VARTYPE(toForm) # "O"
    RETURN .F.
ENDIF

IF !PEMSTATUS(toForm, "xGridArtName", 5)
    RETURN .F.
ENDIF

lcGrid = toForm.xGridArtName
IF EMPTY(lcGrid) OR !PEMSTATUS(toForm, lcGrid, 5)
    RETURN .F.
ENDIF

loGrid = EVALUATE("toForm." + lcGrid)

lnBack = GridArt_GetDynBack(toForm)
lnFore = GridArt_GetDynFore(toForm)

WITH loGrid
    .HighlightStyle     = 0

    FOR lnCol = 1 TO .ColumnCount
        loCol = .Columns(lnCol)
        llFixed = GridArt_IsFixedColumn(toForm, lnCol)

        IF !llFixed
            lcDynExpr = ALLTRIM(TRANSFORM(loCol.DynamicBackColor))
            IF !EMPTY(lcDynExpr) AND !("GridArt_GetDynBack" $ lcDynExpr)
                llFixed = .T.
            ENDIF
        ENDIF

        IF llFixed
            lnColBack = GridArt_EvalColor(loCol.DynamicBackColor, lnBack)
            lnColFore = GridArt_EvalColor(loCol.DynamicForeColor, lnFore)
        ELSE
            lnColBack = lnBack
            lnColFore = lnFore
        ENDIF

        IF PEMSTATUS(loCol, "Text1", 5) AND !llFixed
            loCol.Text1.BackColor  = lnColBack
            loCol.Text1.ForeColor  = lnColFore
            loCol.Text1.BorderStyle = 0
        ENDIF
    ENDFOR
ENDWITH

RETURN .T.
ENDFUNC




*=========================================================
* GridArt_DarkenColor
* Oscurece un color RGB base para generar variantes visuales
* de selección o énfasis.
*=========================================================
FUNCTION GridArt_DarkenColor
LPARAMETERS tnColor, tnAmount

LOCAL lnR, lnG, lnB
lnR = MAX(0, MOD(tnColor, 256)            - tnAmount)
lnG = MAX(0, MOD(INT(tnColor / 256), 256) - tnAmount)
lnB = MAX(0, INT(tnColor / 65536)         - tnAmount)

RETURN RGB(lnR, lnG, lnB)
ENDFUNC


*=========================================================
* GridArt_RefrescarStockVisual
* Recrea el cursor auxiliar de colores/stock a partir del
* cursor origen o, si hace falta, completando datos desde MySQL.
*=========================================================
FUNCTION GridArt_RefrescarStockVisual
LPARAMETERS toForm

LOCAL lcCur, lcColorCur, lnConn, lnRet
LOCAL lnStock, lnPedidos, lnStMin, lnPctAlerta, lnPedProv, lnPos
LOCAL lcGrid

IF VARTYPE(toForm) # "O"
    RETURN .F.
ENDIF

lcCur      = toForm.xGridArtCursor
lcColorCur = toForm.xGridArtColorCursor
lcGrid     = toForm.xGridArtName

IF EMPTY(lcCur) OR !USED(lcCur)
    RETURN .F.
ENDIF

IF USED(lcColorCur)
    USE IN (lcColorCur)
ENDIF

* === Detectar si el cursor origen ya tiene datos de stock (ej: viene del SP) ===
LOCAL llFuenteConStock
llFuenteConStock = (TYPE(lcCur + ".art_stock") <> "U")

IF RECCOUNT(lcCur) = 0 OR llFuenteConStock
    IF llFuenteConStock AND RECCOUNT(lcCur) > 0
        SELECT art_codi, ;
               NVL(posicion,       0) AS xposicion, ;
               NVL(art_stmin,      0) AS art_stmin, ;
               NVL(art_pct_alerta, 0) AS art_pct_alerta, ;
               NVL(pedprov,        0) AS pedprov, ;
               .F.                    AS xIsSelected ;
        FROM (lcCur) ;
        INTO CURSOR (lcColorCur) READWRITE
    ELSE
        * Cursor vacío - estructura mínima
        SELECT art_codi, ;
               CAST(0 AS N(15,3)) AS xposicion, ;
               CAST(0 AS N(15,3)) AS art_stmin, ;
               CAST(0 AS N(10,2)) AS art_pct_alerta, ;
               CAST(0 AS N(15,3)) AS pedprov, ;
               .F.                AS xIsSelected ;
        FROM (lcCur) ;
        INTO CURSOR (lcColorCur) READWRITE
    ENDIF

    INDEX ON STR(RECNO(), 6) TAG xrecno COMPACT

    IF !EMPTY(lcGrid) AND PEMSTATUS(toForm, lcGrid, 5)
        EVALUATE("toForm." + lcGrid + ".Refresh()")
    ENDIF

    =GridArt_SyncActiveColor(toForm)

    RETURN .T.
ENDIF

* Path original: cursor sin stock, query MySQL
SELECT *, ;
       CAST(0 AS N(15,3)) AS art_stock, ;
       CAST(0 AS N(15,3)) AS xpedidos, ;
       CAST(0 AS N(15,3)) AS art_stmin, ;
       CAST(0 AS N(10,2)) AS art_pct_alerta, ;
       CAST(0 AS N(15,3)) AS pedprov, ;
       CAST(0 AS N(15,3)) AS xposicion ;
FROM (lcCur) ;
INTO CURSOR (lcColorCur) READWRITE

INDEX ON STR(RECNO(), 6) TAG xrecno COMPACT

lnConn = Conectar_DB(_screen.cn)
IF VARTYPE(lnConn) # "N" OR lnConn <= 0
    IF !EMPTY(lcGrid) AND PEMSTATUS(toForm, lcGrid, 5)
        EVALUATE("toForm." + lcGrid + ".Refresh()")
    ENDIF

    =GridArt_SyncActiveColor(toForm)

    RETURN .F.
ENDIF

lnRet = SQLEXEC(lnConn, ;
    "SELECT a.art_codi, a.art_stock, a.pedidos, a.art_stmin, " + ;
    "IFNULL(m.art_pct_alerta, 0) AS art_pct_alerta, " + ;
    "a.pedprov " + ;
    "FROM articulos a " + ;
    "LEFT JOIN art_metricas m ON m.art_codi = a.art_codi", ;
    "cur_gridart_stock")

Desconectar_DB(lnConn)

IF lnRet <= 0 OR !USED("cur_gridart_stock")
    IF !EMPTY(lcGrid) AND PEMSTATUS(toForm, lcGrid, 5)
        EVALUATE("toForm." + lcGrid + ".Refresh()")
    ENDIF

    =GridArt_SyncActiveColor(toForm)

    RETURN .F.
ENDIF

SELECT cur_gridart_stock
INDEX ON art_codi TAG xartcodi COMPACT

SELECT (lcColorCur)
LOCATE
SCAN
    IF art_codi > 5 AND SEEK(art_codi, "cur_gridart_stock", "xartcodi")
        lnStock     = VAL(TRANSFORM(NVL(cur_gridart_stock.art_stock, 0)))
        lnPedidos   = VAL(TRANSFORM(NVL(cur_gridart_stock.pedidos, 0)))
        lnStMin     = VAL(TRANSFORM(NVL(cur_gridart_stock.art_stmin, 0)))
        lnPctAlerta = VAL(TRANSFORM(NVL(cur_gridart_stock.art_pct_alerta, 0)))
        lnPedProv   = VAL(TRANSFORM(NVL(cur_gridart_stock.pedprov, 0)))
        lnPos       = lnStock + lnPedProv - lnPedidos

        REPLACE art_stock      WITH lnStock
        REPLACE xpedidos       WITH lnPedidos
        REPLACE art_stmin      WITH lnStMin
        REPLACE art_pct_alerta WITH lnPctAlerta
        REPLACE pedprov        WITH lnPedProv
        REPLACE xposicion      WITH lnPos
    ELSE
        REPLACE art_stock      WITH 0
        REPLACE xpedidos       WITH 0
        REPLACE art_stmin      WITH 0
        REPLACE art_pct_alerta WITH 0
        REPLACE pedprov        WITH 0
        REPLACE xposicion      WITH 0
    ENDIF
ENDSCAN

IF USED("cur_gridart_stock")
    USE IN cur_gridart_stock
ENDIF

IF !EMPTY(lcGrid) AND PEMSTATUS(toForm, lcGrid, 5)
    EVALUATE("toForm." + lcGrid + ".Refresh()")
ENDIF

=GridArt_SyncActiveColor(toForm)

RETURN .T.
ENDFUNC


*=========================================================
* GridArt_UpdateSelection
* Actualiza la fila activa, refresca el grid y sincroniza
* el detalle de stock si el panel está abierto.
*=========================================================
FUNCTION GridArt_UpdateSelection
LPARAMETERS toForm

LOCAL lcCur, lcGrid, loGrid

IF VARTYPE(toForm) # "O"
    RETURN .F.
ENDIF

lcCur  = toForm.xGridArtCursor
lcGrid = toForm.xGridArtName

IF EMPTY(lcCur) OR EMPTY(lcGrid)
    RETURN .F.
ENDIF

IF !USED(lcCur) OR !PEMSTATUS(toForm, lcGrid, 5)
    RETURN .F.
ENDIF

loGrid = EVALUATE("toForm." + lcGrid)

*-- Ocultar shape siempre
IF PEMSTATUS(toForm, "shpSelRow", 5)
    toForm.shpSelRow.Visible = .F.
ENDIF

*-- Actualizar xCurRec ANTES del Refresh
SELECT (lcCur)
toForm.xCurRec = RECNO()
=GridArt_SyncActiveColor(toForm)


*-- Refresh: dispara DynamicBackColor con xCurRec ya actualizado
*!*	loGrid.Refresh()

IF PEMSTATUS(toForm, "xTipStockAbierto", 5) AND toForm.xTipStockAbierto
    =GridArt_UpdateStockPanel(toForm)
ENDIF

IF PEMSTATUS(toForm, "oStockPopForm", 5) AND VARTYPE(toForm.oStockPopForm) = "O"
    =GridArt_RefrescarStockFormNative(toForm)
ENDIF

RETURN .T.
ENDFUNC


*=========================================================
* GridArt_AddStockMenuOption
* Agrega al popup contextual una opción estándar para abrir
* el detalle de stock del artículo actual.
*=========================================================
FUNCTION GridArt_AddStockMenuOption
LPARAMETERS tcPopupName, tnBar, toForm

IF EMPTY(tcPopupName) OR VARTYPE(tnBar) # "N" OR VARTYPE(toForm) # "O"
    RETURN .F.
ENDIF

LOCAL lcBar, lcPop, lcMode
lcBar  = TRANSFORM(INT(tnBar))
lcPop  = ALLTRIM(tcPopupName)
lcMode = IIF(PEMSTATUS(toForm, "xGridArtMode", 5), UPPER(ALLTRIM(toForm.xGridArtMode)), "NATIVE")

DEFINE BAR &lcBar OF &lcPop PROMPT [Detalle de Stock]

IF lcMode == "ACTIVEX"
    ON SELECTION BAR &lcBar OF &lcPop =GridArt_OpenStockForm(_SCREEN.ActiveForm)
ELSE
    ON SELECTION BAR &lcBar OF &lcPop =GridArt_OpenStockFormNative(_SCREEN.ActiveForm)
ENDIF

RETURN .T.
ENDFUNC


*=========================================================
* GridArt_AddStockMenuSeparator
* Inserta una barra separadora en el popup contextual del grid.
*=========================================================
FUNCTION GridArt_AddStockMenuSeparator
LPARAMETERS tcPopupName, tnBar

IF EMPTY(tcPopupName) OR VARTYPE(tnBar) # "N"
    RETURN .F.
ENDIF

LOCAL lcBar, lcPop
lcBar = TRANSFORM(INT(tnBar))
lcPop = ALLTRIM(tcPopupName)

DEFINE BAR &lcBar OF &lcPop PROMPT [\-]

RETURN .T.
ENDFUNC

*=========================================================
* GridArt_GetCurrentArtFromActiveX
* Obtiene código y descripción del artículo seleccionado en
* un grid ActiveX a partir de las columnas configuradas.
*=========================================================
FUNCTION GridArt_GetCurrentArtFromActiveX
LPARAMETERS toForm, tcGridName, tnColArtCodi, tnColArtDesc, taRet

LOCAL loGrid, lnRowAct
LOCAL lnOldCol, lnArtCodi
LOCAL lcArtDesc

IF TYPE("taRet[1]") = "U"
    DIMENSION taRet[2]
ENDIF

taRet[1] = 0
taRet[2] = ""

IF VARTYPE(toForm) # "O"
    RETURN .F.
ENDIF

IF EMPTY(tcGridName) OR !PEMSTATUS(toForm, tcGridName, 5)
    RETURN .F.
ENDIF

loGrid = EVALUATE("toForm." + tcGridName)

IF VARTYPE(loGrid) # "O"
    RETURN .F.
ENDIF

IF loGrid.Rows <= 1
    RETURN .F.
ENDIF

lnRowAct = loGrid.Row
IF lnRowAct <= 0 OR lnRowAct >= loGrid.Rows
    RETURN .F.
ENDIF

lnOldCol = loGrid.Col

loGrid.Col = tnColArtCodi
lnArtCodi = VAL(ALLTRIM(loGrid.Text))

loGrid.Col = tnColArtDesc
lcArtDesc = ALLTRIM(loGrid.Text)

loGrid.Col = lnOldCol

taRet[1] = lnArtCodi
taRet[2] = lcArtDesc

RETURN .T.
ENDFUNC


*=========================================================
* GridArt_UpdateStockPanel_ActiveX
* Versión específica para grids ActiveX estándar:
* obtiene el artículo actual, consulta stock y actualiza
* el panel embebido de detalle.
*=========================================================
FUNCTION GridArt_UpdateStockPanel_ActiveX
LPARAMETERS toForm

LOCAL laArt[2]
LOCAL lnArtCodi, lcArtDesc
LOCAL lnConn, lnRet
LOCAL lnStock, lnPedidos, lnPedProv, lnMin, lnPct, lnPos, lnDif, lnAlerta
LOCAL lcTip
LOCAL llOk

IF VARTYPE(toForm) # "O"
    RETURN .F.
ENDIF

IF !PEMSTATUS(toForm, "xTipStockAbierto", 5) OR !toForm.xTipStockAbierto
    RETURN .F.
ENDIF

llOk = GridArt_GetCurrentArtFromActiveX(toForm, "grid1", 3, 4, @laArt)
IF !llOk
    RETURN .F.
ENDIF

lnArtCodi = laArt[1]
lcArtDesc = laArt[2]

IF lnArtCodi <= 5
    IF PEMSTATUS(toForm, "edtTipStock", 5)
        toForm.edtTipStock.Value = "El registro actual no corresponde a un artículo codificado."
    ENDIF
    RETURN .T.
ENDIF

lnConn = Conectar_DB(_screen.cn)
IF VARTYPE(lnConn) # "N" OR lnConn <= 0
    RETURN .F.
ENDIF

lnRet = SQLEXEC(lnConn, ;
    "SELECT a.art_stock, a.pedidos, a.pedprov, a.art_stmin, " + ;
    "IFNULL(m.art_pct_alerta, 0) AS art_pct_alerta " + ;
    "FROM articulos a " + ;
    "LEFT JOIN art_metricas m ON m.art_codi = a.art_codi " + ;
    "WHERE a.art_codi = ?lnArtCodi", ;
    "cur_tip_art_activex")

Desconectar_DB(lnConn)

IF lnRet <= 0 OR !USED("cur_tip_art_activex") OR RECCOUNT("cur_tip_art_activex") = 0
    IF USED("cur_tip_art_activex")
        USE IN cur_tip_art_activex
    ENDIF
    RETURN .F.
ENDIF

lnStock   = VAL(TRANSFORM(NVL(cur_tip_art_activex.art_stock, 0)))
lnPedidos = VAL(TRANSFORM(NVL(cur_tip_art_activex.pedidos, 0)))
lnPedProv = VAL(TRANSFORM(NVL(cur_tip_art_activex.pedprov, 0)))
lnMin     = VAL(TRANSFORM(NVL(cur_tip_art_activex.art_stmin, 0)))
lnPct     = VAL(TRANSFORM(NVL(cur_tip_art_activex.art_pct_alerta, 0)))

lnPos = lnStock + lnPedProv - lnPedidos
lnDif = lnPos - lnMin
lnAlerta = lnMin * (1 + (lnPct / 100))


IF LEN(lcArtDesc) > 180
    lcArtDesc = LEFT(lcArtDesc, 180) + "..."
ENDIF

lcTip = ;
    "Codigo        : " + TRANSFORM(lnArtCodi)                         + CHR(13) + ;
    "Descripcion   : " + lcArtDesc                                     + CHR(13) + ;
    "Pct. alerta   : " + TRANSFORM(lnPct) + "%"                       + CHR(13) + ;
    "-----------------------------------"                               + CHR(13) + ;
    "Stock         : " + TRANSFORM(lnStock,   "999,999,999.999")      + CHR(13) + ;
    "Compras       : " + TRANSFORM(lnPedProv, "999,999,999.999")      + CHR(13) + ;
    "Pedidos       : " + TRANSFORM(lnPedidos, "999,999,999.999")      + CHR(13) + ;
    "-----------------------------------"                               + CHR(13) + ;
    "Posicion      : " + TRANSFORM(lnPos,     "999,999,999.999")      + CHR(13) + ;
    "Pos. minima   : " + TRANSFORM(lnMin,     "999,999,999.999") + ;
        " (alerta en " + ALLTRIM(TRANSFORM(lnAlerta, "999,999,999.99")) + ")" + CHR(13) + ;
    "Diferencia    : " + IIF(lnDif >= 0, "+", "-") + TRANSFORM(ABS(lnDif), "999,999,999.999")


USE IN cur_tip_art_activex

IF PEMSTATUS(toForm, "edtTipStock", 5)
    toForm.edtTipStock.Value = lcTip
ENDIF

RETURN .T.
ENDFUNC


*=========================================================
* GridArt_UpdateStockPanel_ActiveX_Bound
* Igual que la versión ActiveX estándar, pero usando la
* configuración de grid/columnas ya guardada en el formulario.
*=========================================================
FUNCTION GridArt_UpdateStockPanel_ActiveX_Bound
LPARAMETERS toForm

LOCAL laArt[2]
LOCAL lnArtCodi, lcArtDesc
LOCAL lnConn, lnRet
LOCAL lnStock, lnPedidos, lnPedProv, lnMin, lnPct, lnPos, lnDif, lnAlerta
LOCAL lcTip
LOCAL llOk
LOCAL lcGridName, lnColCodi, lnColDesc

IF VARTYPE(toForm) # "O"
    RETURN .F.
ENDIF

IF !PEMSTATUS(toForm, "xTipStockAbierto", 5) OR !toForm.xTipStockAbierto
    RETURN .F.
ENDIF

IF !PEMSTATUS(toForm, "xGridArtName", 5)
    RETURN .F.
ENDIF
IF !PEMSTATUS(toForm, "xGridArtColCodi", 5)
    RETURN .F.
ENDIF
IF !PEMSTATUS(toForm, "xGridArtColDesc", 5)
    RETURN .F.
ENDIF

lcGridName = toForm.xGridArtName
lnColCodi  = toForm.xGridArtColCodi
lnColDesc  = toForm.xGridArtColDesc

llOk = GridArt_GetCurrentArtFromActiveX(toForm, lcGridName, lnColCodi, lnColDesc, @laArt)
IF !llOk
    RETURN .F.
ENDIF

lnArtCodi = laArt[1]
lcArtDesc = laArt[2]

IF lnArtCodi <= 5
    IF PEMSTATUS(toForm, "edtTipStock", 5)
        toForm.edtTipStock.Value = "El registro actual no corresponde a un artículo codificado."
    ENDIF
    RETURN .T.
ENDIF

lnConn = Conectar_DB(_screen.cn)
IF VARTYPE(lnConn) # "N" OR lnConn <= 0
    RETURN .F.
ENDIF

lnRet = SQLEXEC(lnConn, ;
    "SELECT a.art_stock, a.pedidos, a.pedprov, a.art_stmin, " + ;
    "IFNULL(m.art_pct_alerta, 0) AS art_pct_alerta " + ;
    "FROM articulos a " + ;
    "LEFT JOIN art_metricas m ON m.art_codi = a.art_codi " + ;
    "WHERE a.art_codi = ?lnArtCodi", ;
    "cur_tip_art_activex")

Desconectar_DB(lnConn)

IF lnRet <= 0 OR !USED("cur_tip_art_activex") OR RECCOUNT("cur_tip_art_activex") = 0
    IF USED("cur_tip_art_activex")
        USE IN cur_tip_art_activex
    ENDIF
    RETURN .F.
ENDIF

lnStock   = VAL(TRANSFORM(NVL(cur_tip_art_activex.art_stock, 0)))
lnPedidos = VAL(TRANSFORM(NVL(cur_tip_art_activex.pedidos, 0)))
lnPedProv = VAL(TRANSFORM(NVL(cur_tip_art_activex.pedprov, 0)))
lnMin     = VAL(TRANSFORM(NVL(cur_tip_art_activex.art_stmin, 0)))
lnPct     = VAL(TRANSFORM(NVL(cur_tip_art_activex.art_pct_alerta, 0)))

lnPos = lnStock + lnPedProv - lnPedidos
lnDif = lnPos - lnMin
lnAlerta = lnMin * (1 + (lnPct / 100))


IF LEN(lcArtDesc) > 180
    lcArtDesc = LEFT(lcArtDesc, 180) + "..."
ENDIF

lcTip = ;
    "Codigo        : " + TRANSFORM(lnArtCodi)                         + CHR(13) + ;
    "Descripcion   : " + lcArtDesc                                     + CHR(13) + ;
    "Pct. alerta   : " + TRANSFORM(lnPct) + "%"                       + CHR(13) + ;
    "-----------------------------------"                               + CHR(13) + ;
    "Stock         : " + TRANSFORM(lnStock,   "999,999,999.999")      + CHR(13) + ;
    "Compras       : " + TRANSFORM(lnPedProv, "999,999,999.999")      + CHR(13) + ;
    "Pedidos       : " + TRANSFORM(lnPedidos, "999,999,999.999")      + CHR(13) + ;
    "-----------------------------------"                               + CHR(13) + ;
    "Posicion      : " + TRANSFORM(lnPos,     "999,999,999.999")      + CHR(13) + ;
    "Pos. minima   : " + TRANSFORM(lnMin,     "999,999,999.999") + ;
        " (alerta en " + ALLTRIM(TRANSFORM(lnAlerta, "999,999,999.99")) + ")" + CHR(13) + ;
    "Diferencia    : " + IIF(lnDif >= 0, "+", "-") + TRANSFORM(ABS(lnDif), "999,999,999.999")


USE IN cur_tip_art_activex

IF PEMSTATUS(toForm, "edtTipStock", 5)
    toForm.edtTipStock.Value = lcTip
ENDIF

RETURN .T.
ENDFUNC

*=========================================================
* GridArt_AgregarAListaCompras
* Toma el artículo actual del grid, pide cantidad al usuario
* y lo inserta/actualiza en temp_solicitud_compra.
* Compatible con grids nativos y ActiveX.
*=========================================================
FUNCTION GridArt_AgregarAListaCompras
LPARAMETERS toForm

LOCAL lcCur, lcFieldCodi, lcFieldDesc, lcMode
LOCAL lnArtCodi, lcArtDesc
LOCAL lnCantSug, lcCantInput, lnCant
LOCAL lnConn, lnRet, lcSQL
LOCAL lnProvCodi, lnProvCosto

IF VARTYPE(toForm) # "O"
    RETURN .F.
ENDIF

*-- Detectar modo y obtener art_codi / art_desc
IF !PEMSTATUS(toForm, "xGridArtMode", 5)
    RETURN .F.
ENDIF

lcMode = UPPER(ALLTRIM(toForm.xGridArtMode))

DO CASE
CASE lcMode == "NATIVE"
    lcCur       = toForm.xGridArtCursor
    lcFieldCodi = toForm.xGridArtFieldCodi
    lcFieldDesc = toForm.xGridArtFieldDesc

    IF EMPTY(lcCur) OR !USED(lcCur) OR EOF(lcCur)
        MESSAGEBOX("No hay artículo seleccionado.", 48, "Lista de Compras")
        RETURN .F.
    ENDIF

    lnArtCodi = VAL(TRANSFORM(EVALUATE(lcCur + "." + lcFieldCodi)))
    lcArtDesc = ALLTRIM(TRANSFORM(EVALUATE(lcCur + "." + lcFieldDesc)))

CASE lcMode == "ACTIVEX"
    LOCAL laArt[2]
    IF !PEMSTATUS(toForm, "xGridArtName", 5) OR ;
       !PEMSTATUS(toForm, "xGridArtColCodi", 5) OR ;
       !PEMSTATUS(toForm, "xGridArtColDesc", 5)
        RETURN .F.
    ENDIF

    IF !GridArt_GetCurrentArtFromActiveX(toForm, toForm.xGridArtName, ;
           toForm.xGridArtColCodi, toForm.xGridArtColDesc, @laArt)
        MESSAGEBOX("No hay artículo seleccionado.", 48, "Lista de Compras")
        RETURN .F.
    ENDIF

    lnArtCodi = laArt[1]
    lcArtDesc = laArt[2]

OTHERWISE
    RETURN .F.
ENDCASE

IF lnArtCodi <= 5
    MESSAGEBOX("El artículo seleccionado no es válido.", 48, "Lista de Compras")
    RETURN .F.
ENDIF

*-- Buscar cantidad sugerida y proveedor si están disponibles en el cursor
lnCantSug   = 0
lnProvCodi  = 0
lnProvCosto = 0

IF lcMode == "NATIVE" AND USED(lcCur)
    IF TYPE(lcCur + ".sug_neto") # "U"
        lnCantSug = NVL(EVALUATE(lcCur + ".sug_neto"), 0)
    ENDIF
    IF TYPE(lcCur + ".sugerido_comprar") # "U"
        lnCantSug = NVL(EVALUATE(lcCur + ".sugerido_comprar"), 0)
    ENDIF
    IF TYPE(lcCur + ".prov_codi_sel") # "U"
        lnProvCodi = NVL(EVALUATE(lcCur + ".prov_codi_sel"), 0)
    ENDIF
    IF TYPE(lcCur + ".artpro_costo") # "U"
        lnProvCosto = NVL(EVALUATE(lcCur + ".artpro_costo"), 0)
    ENDIF
ENDIF

*-- Verificar si ya existe en temp_solicitud_compra
lnConn = Conectar_DB(_screen.cn)
IF VARTYPE(lnConn) # "N" OR lnConn <= 0
    MESSAGEBOX("No se pudo conectar a la base de datos.", 16, "Error")
    RETURN .F.
ENDIF

lnRet = SQLEXEC(lnConn, ;
    "SELECT cant_soli FROM temp_solicitud_compra WHERE art_codi = ?lnArtCodi", ;
    "cur_chk_temp")
Desconectar_DB(lnConn)
lnConn = 0

IF lnRet > 0 AND USED("cur_chk_temp") AND RECCOUNT("cur_chk_temp") > 0
    *-- Ya existe: preguntar si modifica
    LOCAL lnCantExiste, lnResp
    lnCantExiste = NVL(cur_chk_temp.cant_soli, 0)
    USE IN cur_chk_temp

    lnResp = MESSAGEBOX( ;
        "Este artículo ya está en la lista de compras." + CHR(13) + ;
        LEFT(lcArtDesc, 55) + CHR(13) + CHR(13) + ;
        "Cantidad actual: " + TRANSFORM(lnCantExiste) + CHR(13) + ;
        "¿Desea modificar la cantidad?", ;
        36, "Ya existe en la lista")

    IF lnResp # 6
        RETURN .F.
    ENDIF

    *-- Precargar con la cantidad existente para el inputbox
    IF lnCantSug <= 0
        lnCantSug = lnCantExiste
    ENDIF
ELSE
    IF USED("cur_chk_temp")
        USE IN cur_chk_temp
    ENDIF
ENDIF

*-- InputBox cantidad
IF lnCantSug <= 0
    lnCantSug = 1
ENDIF

lcCantInput = INPUTBOX( ;
    "Artículo: " + LEFT(lcArtDesc, 50) + CHR(13) + ;
    "Cantidad a solicitar:", ;
    "Agregar a Lista de Compras", ;
    TRANSFORM(lnCantSug))

IF EMPTY(ALLTRIM(lcCantInput))
    RETURN .F.
ENDIF

lnCant = VAL(ALLTRIM(lcCantInput))

IF lnCant <= 0
    MESSAGEBOX("La cantidad debe ser mayor a cero.", 48, "Lista de Compras")
    RETURN .F.
ENDIF

*-- INSERT / UPDATE en temp_solicitud_compra
lnConn = Conectar_DB(_screen.cn)
IF VARTYPE(lnConn) # "N" OR lnConn <= 0
    MESSAGEBOX("No se pudo conectar a la base de datos.", 16, "Error")
    RETURN .F.
ENDIF

TEXT TO lcSQL NOSHOW
INSERT INTO temp_solicitud_compra
    (art_codi, cant_soli, fecha_agregado, prov_codi, artpro_costo)
VALUES
    (?lnArtCodi, ?lnCant, NOW(), NULLIF(?lnProvCodi,0), ?lnProvCosto)
ON DUPLICATE KEY UPDATE
    cant_soli      = VALUES(cant_soli),
    fecha_agregado = NOW(),
    prov_codi      = COALESCE(VALUES(prov_codi), prov_codi),
    artpro_costo   = COALESCE(NULLIF(VALUES(artpro_costo),0), artpro_costo)
ENDTEXT

lnRet = SQLEXEC(lnConn, lcSQL)
Desconectar_DB(lnConn)

IF lnRet < 0
    MESSAGEBOX("Error al guardar en la lista de compras.", 16, "Error")
    RETURN .F.
ENDIF

MESSAGEBOX( ;
    "Artículo guardado en la lista de compras." + CHR(13) + CHR(13) + ;
    LEFT(lcArtDesc, 60) + CHR(13) + ;
    "Cantidad: " + TRANSFORM(lnCant), ;
    64, "Lista de Compras")

RETURN .T.
ENDFUNC


*=========================================================
* GridArt_AddListaComprasMenuOption
* Agrega al popup contextual una opción estándar para enviar
* el artículo actual a la lista temporal de compras.
*=========================================================
FUNCTION GridArt_AddListaComprasMenuOption
LPARAMETERS tcPopupName, tnBar

IF EMPTY(tcPopupName) OR VARTYPE(tnBar) # "N"
    RETURN .F.
ENDIF

LOCAL lcBar, lcPop
lcBar = TRANSFORM(INT(tnBar))
lcPop = ALLTRIM(tcPopupName)

DEFINE BAR &lcBar OF &lcPop PROMPT [Agregar a Lista de Compras]
ON SELECTION BAR &lcBar OF &lcPop =GridArt_AgregarAListaCompras(_SCREEN.ActiveForm)

RETURN .T.
ENDFUNC



*=========================================================
* GridArt_BindTooltipEvents
* Registra los eventos necesarios para abrir/cerrar/refrescar
* el panel o form de stock según clicks, navegación y modo
* del grid (nativo o ActiveX).
*=========================================================
FUNCTION GridArt_BindTooltipEvents
LPARAMETERS toForm

IF VARTYPE(toForm) # "O"
    RETURN .F.
ENDIF

IF !PEMSTATUS(toForm, "oGridArtSink", 5)
    toForm.AddObject("oGridArtSink", "GridArtEventSink")
ENDIF
toForm.oGridArtSink.SetForm(toForm)

*-- X del panel -> cerrar
IF PEMSTATUS(toForm, "cmdTipCerrar", 5)
    BINDEVENT(toForm.cmdTipCerrar, "Click", toForm.oGridArtSink, "OnCerrarClick")
ENDIF

*-- Detectar modo
LOCAL lcGrid, loGrid, lcMode
lcMode = IIF(PEMSTATUS(toForm, "xGridArtMode", 5), UPPER(ALLTRIM(toForm.xGridArtMode)), "")
lcGrid = IIF(PEMSTATUS(toForm, "xGridArtName", 5), toForm.xGridArtName, "")

IF lcMode == "NATIVE"
    *-- Click en fondo del form -> cerrar si está fuera del grid
    BINDEVENT(toForm, "MouseDown", toForm.oGridArtSink, "OnFormMouseDown")

    *-- Eventos del grid nativo
    IF !EMPTY(lcGrid) AND PEMSTATUS(toForm, lcGrid, 5)
        loGrid = EVALUATE("toForm." + lcGrid)

        *-- Navegación por filas
        BINDEVENT(loGrid, "AfterRowColChange", toForm.oGridArtSink, "OnAfterRowColChange")
    ENDIF

    *-- Cuando el foco entra al detalle, el wheel debe afectar al detalle
    IF PEMSTATUS(toForm, "edtTipStock", 5)
        BINDEVENT(toForm.edtTipStock, "GotFocus", toForm.oGridArtSink, "OnTipGotFocus")
    ENDIF

ELSE
    *-- ACTIVEX: MouseDown en form maneja tanto click izquierdo como derecho
    BINDEVENT(toForm, "MouseDown", toForm.oGridArtSink, "OnFormMouseDownActivex")

    *-- También registrar foco del detalle si existe panel embebido
    IF PEMSTATUS(toForm, "edtTipStock", 5)
        BINDEVENT(toForm.edtTipStock, "GotFocus", toForm.oGridArtSink, "OnTipGotFocus")
    ENDIF
ENDIF

RETURN .T.
ENDFUNC

*=========================================================
* GridArtEventSink
* Objeto auxiliar que vive en el form y maneja eventos
* Sin necesidad de agregar métodos al SCX
*=========================================================
DEFINE CLASS GridArtEventSink AS Custom

    HIDDEN oForm

    PROCEDURE SetForm
    LPARAMETERS toForm
        This.oForm = toForm
    ENDPROC

    *-- Botón X del panel nativo
    PROCEDURE OnCerrarClick
        IF VARTYPE(This.oForm) = "O"
            =GridArt_CloseStockPanel(This.oForm)
        ENDIF
    ENDPROC

    PROCEDURE OnGridGotFocus
        IF VARTYPE(This.oForm) = "O"
            IF PEMSTATUS(This.oForm, "xGridArtFocusZone", 5)
                This.oForm.xGridArtFocusZone = "GRID"
            ENDIF
        ENDIF
    ENDPROC

    PROCEDURE OnTipGotFocus
        IF VARTYPE(This.oForm) = "O"
            IF PEMSTATUS(This.oForm, "xGridArtFocusZone", 5)
                This.oForm.xGridArtFocusZone = "TIP"
            ENDIF
        ENDIF
    ENDPROC

    *-- Cambio de fila en grid NATIVO: actualiza colores y tooltip
    PROCEDURE OnAfterRowColChange
    LPARAMETERS nColIndex
        IF VARTYPE(This.oForm) = "O"
            =GridArt_UpdateSelection(This.oForm)
        ENDIF
    ENDPROC

    PROCEDURE OnPopFormDestroy
        LOCAL loForm, lcGrid
        loForm = This.oForm
        IF VARTYPE(loForm) # "O"
            RETURN
        ENDIF
        IF PEMSTATUS(loForm, "oStockPopForm", 5)
            loForm.oStockPopForm = .NULL.
        ENDIF
        *-- Restaurar foco al grid
        TRY
            lcGrid = loForm.xGridArtName
            IF !EMPTY(lcGrid) AND PEMSTATUS(loForm, lcGrid, 5)
                EVALUATE("loForm." + lcGrid + ".SetFocus()")
            ENDIF
        CATCH
        ENDTRY
    ENDPROC
    
    
    *-- Click en fondo del form con grid NATIVO
    *-- Cierra tooltip si el click fue fuera del grid
    PROCEDURE OnFormMouseDown
    LPARAMETERS nButton, nShift, nXCoord, nYCoord
        LOCAL loForm, loGrid, lcGrid
        LOCAL lnGrdL, lnGrdT, lnGrdR, lnGrdB
        loForm = This.oForm
        IF VARTYPE(loForm) # "O"
            RETURN
        ENDIF
        IF !PEMSTATUS(loForm, "xTipStockAbierto", 5) OR !loForm.xTipStockAbierto
            RETURN
        ENDIF
        IF !PEMSTATUS(loForm, "xGridArtName", 5)
            RETURN
        ENDIF
        lcGrid = loForm.xGridArtName
        IF EMPTY(lcGrid) OR !PEMSTATUS(loForm, lcGrid, 5)
            =GridArt_CloseStockPanel(loForm)
            RETURN
        ENDIF
        loGrid = EVALUATE("loForm." + lcGrid)
        lnGrdL = loGrid.Left
        lnGrdT = loGrid.Top
        lnGrdR = loGrid.Left + loGrid.Width
        lnGrdB = loGrid.Top  + loGrid.Height
        IF !(nXCoord >= lnGrdL AND nXCoord <= lnGrdR AND ;
             nYCoord >= lnGrdT AND nYCoord <= lnGrdB)
            =GridArt_CloseStockPanel(loForm)
        ENDIF
    ENDPROC

    *-- MouseDown en form con grid ACTIVEX
    *-- Click izquierdo dentro del grid  ? actualiza form flotante si está abierto
    *-- Click izquierdo fuera del grid   ? cierra form flotante
    *-- Click derecho dentro del grid    ? menú contextual
    PROCEDURE OnFormMouseDownActivex
    LPARAMETERS nButton, nShift, nXCoord, nYCoord
        LOCAL loForm, loGrid, lcGrid
        LOCAL lnGrdL, lnGrdT, lnGrdR, lnGrdB
        LOCAL lcShortcut, llDentroGrid

        loForm = This.oForm
        IF VARTYPE(loForm) # "O"
            RETURN
        ENDIF

        IF !PEMSTATUS(loForm, "xGridArtName", 5)
            RETURN
        ENDIF
        lcGrid = loForm.xGridArtName
        IF EMPTY(lcGrid) OR !PEMSTATUS(loForm, lcGrid, 5)
            RETURN
        ENDIF

        loGrid = EVALUATE("loForm." + lcGrid)
        lnGrdL = loGrid.Left
        lnGrdT = loGrid.Top
        lnGrdR = loGrid.Left + loGrid.Width
        lnGrdB = loGrid.Top  + loGrid.Height

        llDentroGrid = (nXCoord >= lnGrdL AND nXCoord <= lnGrdR AND ;
                        nYCoord >= lnGrdT AND nYCoord <= lnGrdB)

        IF nButton = 2 AND llDentroGrid
            *-- Click derecho dentro del grid ? menú contextual
            lcShortcut = SYS(2015)
            DEFINE POPUP (lcShortcut) SHORTCUT RELATIVE FROM MROW(), MCOL()
            =GridArt_AddStockMenuOption(lcShortcut, 1, loForm)
            =GridArt_AddStockMenuSeparator(lcShortcut, 2)
            =GridArt_AddListaComprasMenuOption(lcShortcut, 3)
            ACTIVATE POPUP (lcShortcut)
            RELEASE POPUP (lcShortcut)
            RETURN
        ENDIF

        IF nButton = 1 AND llDentroGrid
            *-- Click izquierdo dentro del grid ? refrescar form flotante
            =GridArt_RefrescarStockForm(loForm)
            RETURN
        ENDIF

        IF nButton = 1 AND !llDentroGrid
            *-- Click izquierdo fuera del grid ? cerrar tooltip nativo
            IF PEMSTATUS(loForm, "xTipStockAbierto", 5) AND loForm.xTipStockAbierto
                =GridArt_CloseStockPanel(loForm)
            ENDIF
            *-- Cerrar form flotante si está abierto
            IF PEMSTATUS(loForm, "oStockPopForm", 5) AND VARTYPE(loForm.oStockPopForm) = "O"
                TRY
                    loForm.oStockPopForm.Release()
                CATCH
                ENDTRY
                loForm.oStockPopForm = .NULL.
            ENDIF
        ENDIF
    ENDPROC

ENDDEFINE


*=========================================================
* GridArtBtnSink
* Maneja el click del botón cerrar del form flotante
*=========================================================
DEFINE CLASS GridArtBtnSink AS Custom

    HIDDEN oForm

    PROCEDURE SetForm
    LPARAMETERS toForm
        This.oForm = toForm
    ENDPROC

	PROCEDURE OnClick
	    IF VARTYPE(This.oForm) = "O"
	        LOCAL loParent
	        TRY
	            loParent = This.oForm.oGridArtParent
	        CATCH
	            loParent = .NULL.
	        ENDTRY
	        TRY
	            This.oForm.Release()
	        CATCH
	        ENDTRY
	        *-- Limpiar referencia muerta en el form padre
	        IF VARTYPE(loParent) = "O"
	            TRY
	                IF PEMSTATUS(loParent, "oStockPopForm", 5)
	                    loParent.oStockPopForm = .NULL.
	                ENDIF
	                LOCAL lcGrid
	                lcGrid = loParent.xGridArtName
	                IF !EMPTY(lcGrid) AND PEMSTATUS(loParent, lcGrid, 5)
	                    EVALUATE("loParent." + lcGrid + ".SetFocus()")
	                ENDIF
	            CATCH
	            ENDTRY
	        ENDIF
	    ENDIF
	ENDPROC

ENDDEFINE


*=========================================================
* GridArt_ColorearGridActivex
* Colorea fila por fila el grid ActiveX usando CellBackColor
* Llamar después de cargar/refrescar datos en el grid
*=========================================================
FUNCTION GridArt_ColorearGridActivex
LPARAMETERS toForm

LOCAL loGrid, lnRows, lnCols, lnFila, lnCol
LOCAL lnArtCodi, lnConn, lnRet
LOCAL lnPos, lnMin, lnPct, lnColor
LOCAL lcSQL

IF VARTYPE(toForm) # "O"
    RETURN .F.
ENDIF

IF !PEMSTATUS(toForm, "xGridArtMode", 5)
    RETURN .F.
ENDIF

IF UPPER(ALLTRIM(toForm.xGridArtMode)) # "ACTIVEX"
    RETURN .F.
ENDIF

IF !PEMSTATUS(toForm, "xGridArtName", 5)
    RETURN .F.
ENDIF

LOCAL lcGrid, lnColCodi
lcGrid   = toForm.xGridArtName
lnColCodi = IIF(PEMSTATUS(toForm, "xGridArtColCodi", 5), toForm.xGridArtColCodi, 3)

IF EMPTY(lcGrid) OR !PEMSTATUS(toForm, lcGrid, 5)
    RETURN .F.
ENDIF

loGrid = EVALUATE("toForm." + lcGrid)

IF VARTYPE(loGrid) # "O"
    RETURN .F.
ENDIF

lnRows = loGrid.Rows
lnCols = loGrid.Cols

IF lnRows <= 1
    RETURN .F.
ENDIF

*-- Traer todos los datos de stock de una sola query
lnConn = Conectar_DB(_screen.cn)
IF VARTYPE(lnConn) # "N" OR lnConn <= 0
    RETURN .F.
ENDIF

lnRet = SQLEXEC(lnConn, ;
    "SELECT a.art_codi, a.art_stock, a.pedidos, a.pedprov, a.art_stmin, " + ;
    "IFNULL(m.art_pct_alerta, 0) AS art_pct_alerta, " + ;
    "(a.art_stock + a.pedprov - a.pedidos) AS posicion " + ;
    "FROM articulos a " + ;
    "LEFT JOIN art_metricas m ON m.art_codi = a.art_codi", ;
    "cur_gax_stock")

Desconectar_DB(lnConn)

IF lnRet <= 0 OR !USED("cur_gax_stock")
    RETURN .F.
ENDIF

SELECT cur_gax_stock
INDEX ON art_codi TAG xartcodi COMPACT

*-- Iterar filas del grid y aplicar color
LOCAL lnOldRow, lnOldCol
lnOldRow = loGrid.Row
lnOldCol = loGrid.Col

FOR lnFila = 1 TO lnRows - 1
    loGrid.Row = lnFila
    loGrid.Col = lnColCodi
    lnArtCodi  = VAL(ALLTRIM(loGrid.Text))

    IF lnArtCodi > 5 AND SEEK(lnArtCodi, "cur_gax_stock", "xartcodi")
        lnPos = VAL(TRANSFORM(NVL(cur_gax_stock.posicion,      0)))
        lnMin = VAL(TRANSFORM(NVL(cur_gax_stock.art_stmin,     0)))
        lnPct = VAL(TRANSFORM(NVL(cur_gax_stock.art_pct_alerta,20)))

        lnColor = GridArt_DynBack(lnPos, lnMin, lnPct, 0)
    ELSE
        lnColor = RGB(255,255,255)
    ENDIF

    *-- Aplicar color a todas las celdas de la fila
    FOR lnCol = 0 TO lnCols - 1
        loGrid.Row           = lnFila
        loGrid.Col           = lnCol
        loGrid.CellBackColor = lnColor
    ENDFOR
ENDFOR

*-- Restaurar posición
loGrid.Row = lnOldRow
loGrid.Col = lnOldCol

IF USED("cur_gax_stock")
    USE IN cur_gax_stock
ENDIF

RETURN .T.
ENDFUNC


*=========================================================
* GridArt_OpenStockFormNative
* Abre el detalle de stock en un form flotante separado
* para grids nativos, leyendo el articulo desde el cursor
* configurado con GridArt_BindNative.
*=========================================================
FUNCTION GridArt_OpenStockFormNative
LPARAMETERS toForm

LOCAL lcCur, lcFieldCodi, lcFieldDesc
LOCAL lnArtCodi, lcArtDesc
LOCAL lnConn, lnRet
LOCAL lnStock, lnPedidos, lnPedProv, lnMin, lnPct, lnPos, lnDif, lnAlerta
LOCAL lcTip, loPopForm, loEdit, loBtn, loBtnSink

IF VARTYPE(toForm) # "O"
    RETURN .F.
ENDIF

*-- Si ya hay un form flotante abierto, cerrarlo primero
IF PEMSTATUS(toForm, "oStockPopForm", 5) AND VARTYPE(toForm.oStockPopForm) = "O"
    TRY
        toForm.oStockPopForm.Release()
    CATCH
    ENDTRY
    toForm.oStockPopForm = .NULL.
ENDIF

IF !PEMSTATUS(toForm, "xGridArtCursor", 5) OR ;
   !PEMSTATUS(toForm, "xGridArtFieldCodi", 5) OR ;
   !PEMSTATUS(toForm, "xGridArtFieldDesc", 5)
    RETURN .F.
ENDIF

lcCur       = toForm.xGridArtCursor
lcFieldCodi = toForm.xGridArtFieldCodi
lcFieldDesc = toForm.xGridArtFieldDesc

IF EMPTY(lcCur) OR !USED(lcCur) OR RECCOUNT(lcCur) = 0 OR EOF(lcCur)
    MESSAGEBOX("No hay articulo seleccionado.", 48, "Detalle de Stock")
    RETURN .F.
ENDIF

lnArtCodi = VAL(TRANSFORM(EVALUATE(lcCur + "." + lcFieldCodi)))
lcArtDesc = ALLTRIM(TRANSFORM(EVALUATE(lcCur + "." + lcFieldDesc)))

IF lnArtCodi <= 5
    MESSAGEBOX("El articulo no tiene stock registrado.", 48, "Detalle de Stock")
    RETURN .F.
ENDIF

lnConn = Conectar_DB(_screen.cn)
IF VARTYPE(lnConn) # "N" OR lnConn <= 0
    RETURN .F.
ENDIF

lnRet = SQLEXEC(lnConn, ;
    "SELECT a.art_stock, a.pedidos, a.pedprov, a.art_stmin, " + ;
    "IFNULL(m.art_pct_alerta, 0) AS art_pct_alerta " + ;
    "FROM articulos a " + ;
    "LEFT JOIN art_metricas m ON m.art_codi = a.art_codi " + ;
    "WHERE a.art_codi = ?lnArtCodi", ;
    "cur_tip_stockform_native")

Desconectar_DB(lnConn)

IF lnRet <= 0 OR !USED("cur_tip_stockform_native") OR RECCOUNT("cur_tip_stockform_native") = 0
    IF USED("cur_tip_stockform_native")
        USE IN cur_tip_stockform_native
    ENDIF
    RETURN .F.
ENDIF

lnStock   = VAL(TRANSFORM(NVL(cur_tip_stockform_native.art_stock,     0)))
lnPedidos = VAL(TRANSFORM(NVL(cur_tip_stockform_native.pedidos,        0)))
lnPedProv = VAL(TRANSFORM(NVL(cur_tip_stockform_native.pedprov,        0)))
lnMin     = VAL(TRANSFORM(NVL(cur_tip_stockform_native.art_stmin,      0)))
lnPct     = VAL(TRANSFORM(NVL(cur_tip_stockform_native.art_pct_alerta, 0)))

USE IN cur_tip_stockform_native

lnPos = lnStock + lnPedProv - lnPedidos
lnDif = lnPos - lnMin
lnAlerta = lnMin * (1 + (lnPct / 100))


IF LEN(lcArtDesc) > 150
    lcArtDesc = LEFT(lcArtDesc, 150) + "..."
ENDIF

lcTip = ;
    "Codigo        : " + TRANSFORM(lnArtCodi)                         + CHR(13) + ;
    "Descripcion   : " + lcArtDesc                                     + CHR(13) + ;
    "Pct. alerta   : " + TRANSFORM(lnPct) + "%"                       + CHR(13) + ;
    "-----------------------------------"                               + CHR(13) + ;
    "Stock         : " + TRANSFORM(lnStock,   "999,999,999.999")      + CHR(13) + ;
    "Compras       : " + TRANSFORM(lnPedProv, "999,999,999.999")      + CHR(13) + ;
    "Pedidos       : " + TRANSFORM(lnPedidos, "999,999,999.999")      + CHR(13) + ;
    "-----------------------------------"                               + CHR(13) + ;
    "Posicion      : " + TRANSFORM(lnPos,     "999,999,999.999")      + CHR(13) + ;
    "Pos. minima   : " + TRANSFORM(lnMin,     "999,999,999.999") + ;
        " (alerta en " + ALLTRIM(TRANSFORM(lnAlerta, "999,999,999.99")) + ")" + CHR(13) + ;
    "Diferencia    : " + IIF(lnDif >= 0, "+", "-") + TRANSFORM(ABS(lnDif), "999,999,999.999")


loPopForm = CREATEOBJECT("Form")

WITH loPopForm
    .Caption     = "Detalle de Stock"
    .AutoCenter  = .T.
    .BorderStyle = 1
    .MaxButton   = .F.
    .MinButton   = .F.
    .Width       = 430
    .Height      = 260
    .BackColor   = RGB(255,255,210)
    .AlwaysOnTop = .T.
    .Icon        = 'C:\VFP9_MYSQL\imagen\VBE7_1251.ico'
*!*	    .ShowWindow  = 2
ENDWITH

loPopForm.AddObject("edt", "EditBox")
loEdit = loPopForm.edt

WITH loEdit
    .Left        = 10
    .Top         = 10
    .Width       = 408
    .Height      = 210
    .FontName    = "Courier New"
    .FontSize    = 9
    .ReadOnly    = .T.
    .BackColor   = RGB(255,255,210)
    .ForeColor   = RGB(30,30,30)
    .BorderStyle = 0
    .ScrollBars  = 0
    .Value       = lcTip
    .Visible     = .T.
ENDWITH

loPopForm.AddObject("btn", "CommandButton")
loBtn = loPopForm.btn

WITH loBtn
    .Left    = 165
    .Top     = 230
    .Width   = 100
    .Height  = 27
    .Caption = "Cerrar"
    .Visible = .T.
ENDWITH

IF !PEMSTATUS(toForm, "oStockPopForm", 5)
    toForm.AddProperty("oStockPopForm", loPopForm)
ELSE
    toForm.oStockPopForm = loPopForm
ENDIF

loBtnSink = CREATEOBJECT("GridArtBtnSink")
loBtnSink.SetForm(loPopForm)

loPopForm.AddProperty("oBtnSink", loBtnSink)
loPopForm.AddProperty("oGridArtParent", toForm)

BINDEVENT(loBtn, "Click", loPopForm.oBtnSink, "OnClick")

loPopForm.Show()
TRY
    lcGrid = toForm.xGridArtName
    IF !EMPTY(lcGrid) AND PEMSTATUS(toForm, lcGrid, 5)
        EVALUATE("toForm." + lcGrid + ".SetFocus()")
    ENDIF
CATCH
ENDTRY

RETURN .T.
ENDFUNC



FUNCTION GridArt_RefrescarStockFormNative
LPARAMETERS toForm

LOCAL loPopForm
LOCAL lcCur, lcFieldCodi, lcFieldDesc
LOCAL lnArtCodi, lcArtDesc
LOCAL lnConn, lnRet
LOCAL lnStock, lnPedidos, lnPedProv, lnMin, lnPct, lnPos, lnDif, lnAlerta
LOCAL lcTip

IF VARTYPE(toForm) # "O"
    RETURN .F.
ENDIF

IF !PEMSTATUS(toForm, "oStockPopForm", 5)
    RETURN .F.
ENDIF

loPopForm = toForm.oStockPopForm
IF VARTYPE(loPopForm) # "O"
    RETURN .F.
ENDIF

TRY
    lcTip = loPopForm.Caption
CATCH
    toForm.oStockPopForm = .NULL.
    RETURN .F.
ENDTRY

lcCur       = toForm.xGridArtCursor
lcFieldCodi = toForm.xGridArtFieldCodi
lcFieldDesc = toForm.xGridArtFieldDesc

IF EMPTY(lcCur) OR !USED(lcCur) OR RECCOUNT(lcCur) = 0 OR EOF(lcCur)
    RETURN .F.
ENDIF

lnArtCodi = VAL(TRANSFORM(EVALUATE(lcCur + "." + lcFieldCodi)))
lcArtDesc = ALLTRIM(TRANSFORM(EVALUATE(lcCur + "." + lcFieldDesc)))

IF lnArtCodi <= 5
    RETURN .F.
ENDIF

lnConn = Conectar_DB(_screen.cn)
IF VARTYPE(lnConn) # "N" OR lnConn <= 0
    RETURN .F.
ENDIF

lnRet = SQLEXEC(lnConn, ;
    "SELECT a.art_stock, a.pedidos, a.pedprov, a.art_stmin, " + ;
    "IFNULL(m.art_pct_alerta, 0) AS art_pct_alerta " + ;
    "FROM articulos a " + ;
    "LEFT JOIN art_metricas m ON m.art_codi = a.art_codi " + ;
    "WHERE a.art_codi = ?lnArtCodi", ;
    "cur_tip_stockform_native2")

Desconectar_DB(lnConn)

IF lnRet <= 0 OR !USED("cur_tip_stockform_native2") OR RECCOUNT("cur_tip_stockform_native2") = 0
    IF USED("cur_tip_stockform_native2")
        USE IN cur_tip_stockform_native2
    ENDIF
    RETURN .F.
ENDIF

lnStock   = VAL(TRANSFORM(NVL(cur_tip_stockform_native2.art_stock,     0)))
lnPedidos = VAL(TRANSFORM(NVL(cur_tip_stockform_native2.pedidos,        0)))
lnPedProv = VAL(TRANSFORM(NVL(cur_tip_stockform_native2.pedprov,        0)))
lnMin     = VAL(TRANSFORM(NVL(cur_tip_stockform_native2.art_stmin,      0)))
lnPct     = VAL(TRANSFORM(NVL(cur_tip_stockform_native2.art_pct_alerta, 0)))

USE IN cur_tip_stockform_native2

lnPos = lnStock + lnPedProv - lnPedidos
lnDif = lnPos - lnMin
lnAlerta = lnMin * (1 + (lnPct / 100))


IF LEN(lcArtDesc) > 150
    lcArtDesc = LEFT(lcArtDesc, 150) + "..."
ENDIF

lcTip = ;
    "Codigo        : " + TRANSFORM(lnArtCodi)                         + CHR(13) + ;
    "Descripcion   : " + lcArtDesc                                     + CHR(13) + ;
    "Pct. alerta   : " + TRANSFORM(lnPct) + "%"                       + CHR(13) + ;
    "-----------------------------------"                               + CHR(13) + ;
    "Stock         : " + TRANSFORM(lnStock,   "999,999,999.999")      + CHR(13) + ;
    "Compras       : " + TRANSFORM(lnPedProv, "999,999,999.999")      + CHR(13) + ;
    "Pedidos       : " + TRANSFORM(lnPedidos, "999,999,999.999")      + CHR(13) + ;
    "-----------------------------------"                               + CHR(13) + ;
    "Posicion      : " + TRANSFORM(lnPos,     "999,999,999.999")      + CHR(13) + ;
    "Pos. minima   : " + TRANSFORM(lnMin,     "999,999,999.999") + ;
        " (alerta en " + ALLTRIM(TRANSFORM(lnAlerta, "999,999,999.99")) + ")" + CHR(13) + ;
    "Diferencia    : " + IIF(lnDif >= 0, "+", "-") + TRANSFORM(ABS(lnDif), "999,999,999.999")


TRY
    loPopForm.edt.Value = lcTip
CATCH
ENDTRY

RETURN .T.
ENDFUNC




*=========================================================
* GridArt_OpenStockForm
* Abre el detalle de stock en un form flotante separado
* Necesario para grids ActiveX donde ZOrder no funciona
*=========================================================
FUNCTION GridArt_OpenStockForm
LPARAMETERS toForm

LOCAL lcCur, lcFieldCodi, lcFieldDesc
LOCAL lnArtCodi, lcArtDesc
LOCAL lnConn, lnRet
LOCAL lnStock, lnPedidos, lnPedProv, lnMin, lnPct, lnPos, lnDif, lnAlerta
LOCAL lcTip, loPopForm

IF VARTYPE(toForm) # "O"
    RETURN .F.
ENDIF

*-- Si ya hay un form flotante abierto, cerrarlo primero
IF PEMSTATUS(toForm, "oStockPopForm", 5) AND VARTYPE(toForm.oStockPopForm) = "O"
    TRY
        toForm.oStockPopForm.Release()
    CATCH
    ENDTRY
    toForm.oStockPopForm = .NULL.
ENDIF

*-- Obtener artículo actual del grid ActiveX
LOCAL laArt[2]
IF !PEMSTATUS(toForm, "xGridArtName", 5) OR ;
   !PEMSTATUS(toForm, "xGridArtColCodi", 5) OR ;
   !PEMSTATUS(toForm, "xGridArtColDesc", 5)
    RETURN .F.
ENDIF

IF !GridArt_GetCurrentArtFromActiveX(toForm, toForm.xGridArtName, ;
       toForm.xGridArtColCodi, toForm.xGridArtColDesc, @laArt)
    MESSAGEBOX("No hay artículo seleccionado.", 48, "Detalle de Stock")
    RETURN .F.
ENDIF

lnArtCodi = laArt[1]
lcArtDesc = laArt[2]

IF lnArtCodi <= 5
    MESSAGEBOX("El artículo no tiene stock registrado.", 48, "Detalle de Stock")
    RETURN .F.
ENDIF

*-- Query MySQL
lnConn = Conectar_DB(_screen.cn)
IF VARTYPE(lnConn) # "N" OR lnConn <= 0
    RETURN .F.
ENDIF

lnRet = SQLEXEC(lnConn, ;
    "SELECT a.art_stock, a.pedidos, a.pedprov, a.art_stmin, " + ;
    "IFNULL(m.art_pct_alerta, 0) AS art_pct_alerta " + ;
    "FROM articulos a " + ;
    "LEFT JOIN art_metricas m ON m.art_codi = a.art_codi " + ;
    "WHERE a.art_codi = ?lnArtCodi", ;
    "cur_tip_stockform")

Desconectar_DB(lnConn)

IF lnRet <= 0 OR !USED("cur_tip_stockform") OR RECCOUNT("cur_tip_stockform") = 0
    IF USED("cur_tip_stockform")
        USE IN cur_tip_stockform
    ENDIF
    RETURN .F.
ENDIF

lnStock   = VAL(TRANSFORM(NVL(cur_tip_stockform.art_stock,     0)))
lnPedidos = VAL(TRANSFORM(NVL(cur_tip_stockform.pedidos,        0)))
lnPedProv = VAL(TRANSFORM(NVL(cur_tip_stockform.pedprov,        0)))
lnMin     = VAL(TRANSFORM(NVL(cur_tip_stockform.art_stmin,      0)))
lnPct     = VAL(TRANSFORM(NVL(cur_tip_stockform.art_pct_alerta, 0)))
USE IN cur_tip_stockform

lnPos = lnStock + lnPedProv - lnPedidos
lnDif = lnPos - lnMin
lnAlerta = lnMin * (1 + (lnPct / 100))


IF LEN(lcArtDesc) > 180
    lcArtDesc = LEFT(lcArtDesc, 180) + "..."
ENDIF

lcTip = ;
    "Codigo        : " + TRANSFORM(lnArtCodi)                         + CHR(13) + ;
    "Descripcion   : " + lcArtDesc                                     + CHR(13) + ;
    "Pct. alerta   : " + TRANSFORM(lnPct) + "%"                       + CHR(13) + ;
    "-----------------------------------"                               + CHR(13) + ;
    "Stock         : " + TRANSFORM(lnStock,   "999,999,999.999")      + CHR(13) + ;
    "Compras       : " + TRANSFORM(lnPedProv, "999,999,999.999")      + CHR(13) + ;
    "Pedidos       : " + TRANSFORM(lnPedidos, "999,999,999.999")      + CHR(13) + ;
    "-----------------------------------"                               + CHR(13) + ;
    "Posicion      : " + TRANSFORM(lnPos,     "999,999,999.999")      + CHR(13) + ;
    "Pos. minima   : " + TRANSFORM(lnMin,     "999,999,999.999") + ;
        " (alerta en " + ALLTRIM(TRANSFORM(lnAlerta, "999,999,999.99")) + ")" + CHR(13) + ;
    "Diferencia    : " + IIF(lnDif >= 0, "+", "-") + TRANSFORM(ABS(lnDif), "999,999,999.999")


*-- Crear form flotante
LOCAL loPopForm, loEdit, loBtn, loBtnSink
loPopForm = CREATEOBJECT("Form")

WITH loPopForm
    .Caption     = "Detalle de Stock"
    .AutoCenter  = .T.
    .BorderStyle = 1
    .MaxButton   = .F.
    .MinButton   = .F.
    .Width       = 430
    .Height      = 260
    .BackColor   = RGB(255,255,210)
    .AlwaysOnTop = .T.
    .Icon        = 'C:\VFP9_MYSQL\imagen\VBE7_1251.ico'
*!*	    .ShowWindow  = 2
*!*	    .ZOrder = 0 
ENDWITH

loPopForm.AddObject("edt", "EditBox")
loEdit = loPopForm.edt
WITH loEdit
    .Left        = 10
    .Top         = 10
    .Width       = 408
    .Height      = 210
    .FontName    = "Courier New"
    .FontSize    = 9
    .ReadOnly    = .T.
    .BackColor   = RGB(255,255,210)
    .ForeColor   = RGB(30,30,30)
    .BorderStyle = 0
    .ScrollBars  = 2
    .Value       = lcTip
    .Visible     = .T.
ENDWITH

loPopForm.AddObject("btn", "CommandButton")
loBtn = loPopForm.btn
WITH loBtn
    .Left    = 165
    .Top     = 230
    .Width   = 100
    .Height  = 27
    .Caption = "Cerrar"
    .Visible = .T.
ENDWITH

*-- Guardar referencia en el form padre ANTES de Show
IF !PEMSTATUS(toForm, "oStockPopForm", 5)
    toForm.AddProperty("oStockPopForm", loPopForm)
ELSE
    toForm.oStockPopForm = loPopForm
ENDIF

*-- Sink para el botón cerrar
loBtnSink = CREATEOBJECT("GridArtBtnSink")
loBtnSink.SetForm(loPopForm)
loPopForm.AddProperty("oBtnSink", loBtnSink)
loPopForm.AddProperty("oGridArtParent", toForm)
BINDEVENT(loBtn, "Click", loPopForm.oBtnSink, "OnClick")

*-- NO bindear Destroy — causa cierre prematuro al perder foco
*-- El foco al grid se restaura únicamente desde OnClick (botón cerrar)

*-- Mostrar modeless
loPopForm.Show()

RETURN .T.
ENDFUNC


*=========================================================
* GridArt_RefrescarStockForm
* Actualiza el form flotante con el artículo actual
*=========================================================
FUNCTION GridArt_RefrescarStockForm
LPARAMETERS toForm

LOCAL loPopForm, loEdit
LOCAL lnArtCodi, lcArtDesc
LOCAL lnConn, lnRet
LOCAL lnStock, lnPedidos, lnPedProv, lnMin, lnPct, lnPos, lnDif, lnAlerta
LOCAL lcTip

IF VARTYPE(toForm) # "O"
    RETURN .F.
ENDIF

*-- Verificar que el form flotante sigue abierto
IF !PEMSTATUS(toForm, "oStockPopForm", 5)
    RETURN .F.
ENDIF

loPopForm = toForm.oStockPopForm
IF VARTYPE(loPopForm) # "O"
    RETURN .F.
ENDIF

*-- Verificar que no fue cerrado por el usuario
TRY
    LOCAL lcTest
    lcTest = loPopForm.Caption
CATCH
    toForm.oStockPopForm = .NULL.
    RETURN .F.
ENDTRY

*-- Obtener artículo actual
LOCAL laArt[2]
IF !GridArt_GetCurrentArtFromActiveX(toForm, toForm.xGridArtName, ;
       toForm.xGridArtColCodi, toForm.xGridArtColDesc, @laArt)
    RETURN .F.
ENDIF

lnArtCodi = laArt[1]
lcArtDesc = laArt[2]

IF lnArtCodi <= 5
    RETURN .F.
ENDIF

*-- Query MySQL
lnConn = Conectar_DB(_screen.cn)
IF VARTYPE(lnConn) # "N" OR lnConn <= 0
    RETURN .F.
ENDIF

lnRet = SQLEXEC(lnConn, ;
    "SELECT a.art_stock, a.pedidos, a.pedprov, a.art_stmin, " + ;
    "IFNULL(m.art_pct_alerta, 0) AS art_pct_alerta " + ;
    "FROM articulos a " + ;
    "LEFT JOIN art_metricas m ON m.art_codi = a.art_codi " + ;
    "WHERE a.art_codi = ?lnArtCodi", ;
    "cur_tip_stockform2")

Desconectar_DB(lnConn)

IF lnRet <= 0 OR !USED("cur_tip_stockform2") OR RECCOUNT("cur_tip_stockform2") = 0
    IF USED("cur_tip_stockform2")
        USE IN cur_tip_stockform2
    ENDIF
    RETURN .F.
ENDIF

lnStock   = VAL(TRANSFORM(NVL(cur_tip_stockform2.art_stock,     0)))
lnPedidos = VAL(TRANSFORM(NVL(cur_tip_stockform2.pedidos,        0)))
lnPedProv = VAL(TRANSFORM(NVL(cur_tip_stockform2.pedprov,        0)))
lnMin     = VAL(TRANSFORM(NVL(cur_tip_stockform2.art_stmin,      0)))
lnPct     = VAL(TRANSFORM(NVL(cur_tip_stockform2.art_pct_alerta, 0)))
USE IN cur_tip_stockform2

lnPos = lnStock + lnPedProv - lnPedidos
lnDif = lnPos - lnMin
lnAlerta = lnMin * (1 + (lnPct / 100))


IF LEN(lcArtDesc) > 180
    lcArtDesc = LEFT(lcArtDesc, 180) + "..."
ENDIF

lcTip = ;
    "Codigo        : " + TRANSFORM(lnArtCodi)                         + CHR(13) + ;
    "Descripcion   : " + lcArtDesc                                     + CHR(13) + ;
    "Pct. alerta   : " + TRANSFORM(lnPct) + "%"                       + CHR(13) + ;
    "-----------------------------------"                               + CHR(13) + ;
    "Stock         : " + TRANSFORM(lnStock,   "999,999,999.999")      + CHR(13) + ;
    "Compras       : " + TRANSFORM(lnPedProv, "999,999,999.999")      + CHR(13) + ;
    "Pedidos       : " + TRANSFORM(lnPedidos, "999,999,999.999")      + CHR(13) + ;
    "-----------------------------------"                               + CHR(13) + ;
    "Posicion      : " + TRANSFORM(lnPos,     "999,999,999.999")      + CHR(13) + ;
    "Pos. minima   : " + TRANSFORM(lnMin,     "999,999,999.999") + ;
        " (alerta en " + ALLTRIM(TRANSFORM(lnAlerta, "999,999,999.99")) + ")" + CHR(13) + ;
    "Diferencia    : " + IIF(lnDif >= 0, "+", "-") + TRANSFORM(ABS(lnDif), "999,999,999.999")


*-- Actualizar el editbox del form flotante
TRY
    loPopForm.edt.Value = lcTip
CATCH
ENDTRY

RETURN .T.
ENDFUNC