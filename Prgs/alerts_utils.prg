*=========================================================
* alerts_utils.prg
* Utilidades reutilizables para formularios de alertas y stock.
*
* Responsabilidades principales:
* - Operaciones seguras sobre cursores (ZAP, INDEX, ORDER)
* - Parseo liviano de métricas JSON almacenadas en texto/memo
* - Conversión de métricas mensuales a cursores VFP
* - Armado del cursor mensual de Compras/Ventas
* - Helpers visuales para selección y borde de fila activa
*
* Uso típico:
* 1) Preparar o limpiar cursores auxiliares
* 2) Extraer métricas mensuales desde JSON
* 3) Consolidar datos en cur_vc_months
* 4) Aplicar lógica visual de fila actual en grids
*=========================================================

*---------------------------------------------------------
* AU_SafetyOff
* Devuelve el estado actual de SET SAFETY para poder
* restaurarlo luego de operaciones sensibles.
*---------------------------------------------------------
FUNCTION AU_SafetyOff
    RETURN SET("SAFETY")
ENDFUNC

FUNCTION AU_SafetyRestore(tcPrev)
    IF VARTYPE(tcPrev) = "C" AND UPPER(tcPrev) = "ON"
        SET SAFETY ON
    ELSE
        SET SAFETY OFF
    ENDIF
ENDFUNC


*---------------------------------------------------------
* AU_ZapSeguro(tcAlias)
* Hace ZAP sobre un cursor/alias válido preservando y
* restaurando el estado previo de SET SAFETY.
*---------------------------------------------------------
FUNCTION AU_ZapSeguro
LPARAMETERS tcAlias
LOCAL lcPrev

IF VARTYPE(tcAlias) <> "C" OR EMPTY(tcAlias) OR !USED(tcAlias)
    RETURN .F.
ENDIF

lcPrev = AU_SafetyOff()
SET SAFETY OFF

SELECT (tcAlias)
ZAP

AU_SafetyRestore(lcPrev)
RETURN .T.
ENDFUNC


*---------------------------------------------------------
* AU_IndexSeguro(tcAlias, tcExpr, tcTag)
* Recrea de forma segura un índice/tag sobre un cursor,
* evitando prompts de sobrescritura por SAFETY ON.
*---------------------------------------------------------
FUNCTION AU_IndexSeguro
LPARAMETERS tcAlias, tcExpr, tcTag
LOCAL lcPrev, lcCmd

IF VARTYPE(tcAlias) <> "C" OR EMPTY(tcAlias) OR !USED(tcAlias)
    RETURN .F.
ENDIF
IF VARTYPE(tcExpr) <> "C" OR EMPTY(tcExpr)
    RETURN .F.
ENDIF
IF VARTYPE(tcTag) <> "C" OR EMPTY(tcTag)
    tcTag = "tag1"
ENDIF

lcPrev = AU_SafetyOff()
SET SAFETY OFF

SELECT (tcAlias)
IF TAGNO(tcTag, tcAlias) > 0
    DELETE TAG (tcTag)
ENDIF

lcCmd = "INDEX ON " + tcExpr + " TAG " + tcTag
&lcCmd

AU_SafetyRestore(lcPrev)
RETURN .T.
ENDFUNC


*---------------------------------------------------------
* AU_SetOrderTag(tcAlias, tcTag)
* Activa el orden de un cursor a partir de un tag ya
* existente, validando alias y nombre de tag.
*---------------------------------------------------------
FUNCTION AU_SetOrderTag
LPARAMETERS tcAlias, tcTag

IF VARTYPE(tcAlias) <> "C" OR EMPTY(tcAlias) OR !USED(tcAlias)
    RETURN .F.
ENDIF
IF VARTYPE(tcTag) <> "C" OR EMPTY(tcTag)
    RETURN .F.
ENDIF

SELECT (tcAlias)
SET ORDER TO TAG (tcTag)
RETURN .T.
ENDFUNC


*=========================================================
* PARSEO JSON DE MÉTRICAS
* Helpers livianos para leer objetos JSON serializados
* en campos Character/Memo sin depender de parser externo.
*=========================================================

*---------------------------------------------------------
* AU_ExtraerArrayJson(tcJsonObj, tcClave)
* Extrae como texto el array asociado a una clave JSON.
* Soporta fuentes Character o Memo.
*---------------------------------------------------------
FUNCTION AU_ExtraerArrayJson
LPARAMETERS tcJsonObj, tcClave
LOCAL lcJson, lnPos, lnIni, lnFin, lc

IF !INLIST(VARTYPE(tcJsonObj), "C", "M")
    RETURN ""
ENDIF

lcJson = ALLTRIM("" + tcJsonObj)

IF EMPTY(lcJson)
    RETURN ""
ENDIF

IF VARTYPE(tcClave) <> "C" OR EMPTY(tcClave)
    RETURN ""
ENDIF

*-- Busca "clave": sin exigir que el "[" venga pegado
*-- Así funciona tanto con "months":[ como con "months": [
lnPos = ATC('"' + ALLTRIM(tcClave) + '":', lcJson)
IF lnPos <= 0
    RETURN ""
ENDIF

lnIni = lnPos + LEN('"' + ALLTRIM(tcClave) + '":')

*-- Saltar espacios, tabs y saltos de línea entre ":" y "["
DO WHILE lnIni <= LEN(lcJson) AND SUBSTR(lcJson, lnIni, 1) $ " " + CHR(9) + CHR(13) + CHR(10)
    lnIni = lnIni + 1
ENDDO

*-- Si lo que sigue no es "[", la clave no apunta a un array
IF SUBSTR(lcJson, lnIni, 1) <> "["
    RETURN ""
ENDIF

lnFin = AT("]", SUBSTR(lcJson, lnIni))
IF lnFin <= 0
    RETURN ""
ENDIF
lnFin = lnIni + lnFin - 1

lc = SUBSTR(lcJson, lnIni, lnFin - lnIni + 1)
RETURN lc
ENDFUNC


*---------------------------------------------------------
* AU_JsonGetNum(tcJson, tcKey, tnDefault)
* Lee un valor numérico desde un objeto JSON textual.
* Normaliza decimal con punto para evitar efectos del
* SET POINT activo en el entorno.
*---------------------------------------------------------
FUNCTION AU_JsonGetNum
LPARAMETERS tcJson, tcKey, tnDefault
LOCAL lcJson, lnPos, lnIni, lnFin, lcNum, lcPunto, lnResult

IF VARTYPE(tnDefault) <> "N"
    tnDefault = 0
ENDIF

IF !INLIST(VARTYPE(tcJson), "C", "M")
    RETURN tnDefault
ENDIF

lcJson = ALLTRIM("" + tcJson)

IF EMPTY(lcJson) OR VARTYPE(tcKey) <> "C" OR EMPTY(tcKey)
    RETURN tnDefault
ENDIF

lnPos = ATC('"' + ALLTRIM(tcKey) + '":', lcJson)
IF lnPos <= 0
    RETURN tnDefault
ENDIF

lnIni = lnPos + LEN('"' + ALLTRIM(tcKey) + '":')
DO WHILE lnIni <= LEN(lcJson) AND SUBSTR(lcJson, lnIni, 1) $ " " + CHR(9) + CHR(13) + CHR(10)
    lnIni = lnIni + 1
ENDDO

lnFin = lnIni
DO WHILE lnFin <= LEN(lcJson)
    IF SUBSTR(lcJson, lnFin, 1) $ ",}"
        EXIT
    ENDIF
    lnFin = lnFin + 1
ENDDO

lcNum = ALLTRIM(SUBSTR(lcJson, lnIni, lnFin - lnIni))
lcNum = STRTRAN(lcNum, ",", ".")

*-- Forzar punto como decimal para que VAL() no trunque
*-- independientemente del SET POINT activo en el sistema
lcPunto = SET("POINT")
SET POINT TO "."
lnResult = VAL(lcNum)
SET POINT TO (lcPunto)

RETURN lnResult
ENDFUNC


*---------------------------------------------------------
* AU_JsonGetStr(tcJson, tcKey, tcDefault)
* Lee un valor string desde un objeto JSON textual y
* devuelve un valor por defecto si la clave no existe.
*---------------------------------------------------------
FUNCTION AU_JsonGetStr
LPARAMETERS tcJson, tcKey, tcDefault
LOCAL lcJson, lnPos, lnIni, lnFin

IF VARTYPE(tcDefault) <> "C"
    tcDefault = ""
ENDIF

IF !INLIST(VARTYPE(tcJson), "C", "M")
    RETURN tcDefault
ENDIF

lcJson = ALLTRIM("" + tcJson)

IF EMPTY(lcJson) OR VARTYPE(tcKey) <> "C" OR EMPTY(tcKey)
    RETURN tcDefault
ENDIF

lnPos = ATC('"' + ALLTRIM(tcKey) + '":"', lcJson)
IF lnPos <= 0
    RETURN tcDefault
ENDIF

lnIni = lnPos + LEN('"' + ALLTRIM(tcKey) + '":"')
lnFin = AT('"', SUBSTR(lcJson, lnIni))
IF lnFin <= 0
    RETURN tcDefault
ENDIF

RETURN SUBSTR(lcJson, lnIni, lnFin - 1)
ENDFUNC


*---------------------------------------------------------
* AU_MesesDeMetricas_A_Cursor(tcJsonObj, tcCursorOut)
* Convierte el array months[] de un JSON de métricas en
* un cursor VFP con estructura (mes, qty).
*---------------------------------------------------------
FUNCTION AU_MesesDeMetricas_A_Cursor
LPARAMETERS tcJsonObj, tcCursorOut
LOCAL lcArr, lnPos, lnA, lnB, lnEnd, lcObj, lcMes, lnQty

IF VARTYPE(tcCursorOut) <> "C" OR EMPTY(tcCursorOut)
    tcCursorOut = SYS(2015)
ENDIF

IF USED(tcCursorOut)
    USE IN (tcCursorOut)
ENDIF

CREATE CURSOR (tcCursorOut) (mes C(7), qty N(15,3))

lcArr = AU_ExtraerArrayJson(tcJsonObj, "months")
IF EMPTY(lcArr)
    RETURN tcCursorOut
ENDIF

lnPos = 1
DO WHILE lnPos <= LEN(lcArr)
    lnA = AT("{", SUBSTR(lcArr, lnPos))
    IF lnA <= 0
        EXIT
    ENDIF
    lnA = lnPos + lnA - 1

    lnEnd = AT("}", SUBSTR(lcArr, lnA))
    IF lnEnd <= 0
        EXIT
    ENDIF
    lnB = lnA + lnEnd - 1

    lcObj = SUBSTR(lcArr, lnA, lnB - lnA + 1)

    lcMes = AU_JsonGetStr(lcObj, "ym", "")
    lnQty = AU_JsonGetNum(lcObj, "qty", 0)

    IF !EMPTY(lcMes)
        INSERT INTO (tcCursorOut) (mes, qty) VALUES (lcMes, lnQty)
    ENDIF

    lnPos = lnB + 1
ENDDO

RETURN tcCursorOut
ENDFUNC


*=========================================================
* ARMADO CURSOR MENSUAL COMPRAS / VENTAS
* Consolida métricas JSON en un cursor listo para UI
* o gráficos mensuales.
*=========================================================
*=========================================================
* AU_ActualizarCursorVC
* Llena o reutiliza el cursor mensual Compras/Ventas a
* partir de ventas_metrics y compras_metrics del alias
* de alertas, sin recrearlo si ya existe.
*=========================================================
FUNCTION AU_ActualizarCursorVC
LPARAMETERS tcAliasAlerts, tcCursorVC
LOCAL lcMesRaw, lcMesUI, lnQty, lcCurV, lcCurC
LOCAL lcAnio, lcMes, lcSafety

IF VARTYPE(tcAliasAlerts) <> "C" OR EMPTY(tcAliasAlerts) OR !USED(tcAliasAlerts)
    RETURN .F.
ENDIF

IF VARTYPE(tcCursorVC) <> "C" OR EMPTY(tcCursorVC)
    tcCursorVC = "cur_vc_months"
ENDIF

*---------------------------------------------------------
* Crear o limpiar cursor destino SIN popup
*---------------------------------------------------------
IF USED(tcCursorVC)
    lcSafety = SET("SAFETY")
    SET SAFETY OFF

    SELECT (tcCursorVC)
    ZAP

    IF UPPER(ALLTRIM(lcSafety)) == "ON"
        SET SAFETY ON
    ELSE
        SET SAFETY OFF
    ENDIF
ELSE
    CREATE CURSOR (tcCursorVC) ( ;
        mes      C(7), ;
        compras  N(15,3), ;
        ventas   N(15,3) )
ENDIF

SELECT (tcAliasAlerts)

lcCurV = AU_MesesDeMetricas_A_Cursor(EVALUATE(tcAliasAlerts + ".ventas_metrics"), SYS(2015))
lcCurC = AU_MesesDeMetricas_A_Cursor(EVALUATE(tcAliasAlerts + ".compras_metrics"), SYS(2015))

*-------------------------------------------------
* VENTAS
*-------------------------------------------------
IF USED(lcCurV)
    SELECT (lcCurV)
    GO TOP
    SCAN
        lcMesRaw = ALLTRIM(mes)

        IF LEN(lcMesRaw) = 7 AND SUBSTR(lcMesRaw,5,1) = "-"
            lcAnio  = LEFT(lcMesRaw,4)
            lcMes   = RIGHT(lcMesRaw,2)
            lcMesUI = lcMes + "/" + lcAnio
        ELSE
            lcMesUI = lcMesRaw
        ENDIF

        lnQty = qty

        SELECT (tcCursorVC)
        LOCATE FOR mes = lcMesUI
        IF FOUND()
            REPLACE ventas WITH ventas + lnQty
        ELSE
            INSERT INTO (tcCursorVC) (mes, compras, ventas) ;
                VALUES (lcMesUI, 0, lnQty)
        ENDIF

        SELECT (lcCurV)
    ENDSCAN
ENDIF

*-------------------------------------------------
* COMPRAS
*-------------------------------------------------
IF USED(lcCurC)
    SELECT (lcCurC)
    GO TOP
    SCAN
        lcMesRaw = ALLTRIM(mes)

        IF LEN(lcMesRaw) = 7 AND SUBSTR(lcMesRaw,5,1) = "-"
            lcAnio  = LEFT(lcMesRaw,4)
            lcMes   = RIGHT(lcMesRaw,2)
            lcMesUI = lcMes + "/" + lcAnio
        ELSE
            lcMesUI = lcMesRaw
        ENDIF

        lnQty = qty

        SELECT (tcCursorVC)
        LOCATE FOR mes = lcMesUI
        IF FOUND()
            REPLACE compras WITH compras + lnQty
        ELSE
            INSERT INTO (tcCursorVC) (mes, compras, ventas) ;
                VALUES (lcMesUI, lnQty, 0)
        ENDIF

        SELECT (lcCurC)
    ENDSCAN
ENDIF

IF USED(lcCurV)
    USE IN (lcCurV)
ENDIF

IF USED(lcCurC)
    USE IN (lcCurC)
ENDIF

SELECT (tcCursorVC)
GO TOP

RETURN .T.
ENDFUNC

*=========================================================
* HELPERS UI DE SELECCIÓN
* Funciones auxiliares para detectar fila activa y
* posicionar borde visual sobre el grid.
*=========================================================


*---------------------------------------------------------
* AU_EsFilaActual(tcAlias, tnCurRec)
* Indica si el registro actual del alias coincide con el
* RECNO que la UI considera como fila activa.
*---------------------------------------------------------
FUNCTION AU_EsFilaActual
LPARAMETERS tcAlias, tnCurRec
IF VARTYPE(tcAlias) <> "C" OR EMPTY(tcAlias) OR !USED(tcAlias)
    RETURN .F.
ENDIF
IF VARTYPE(tnCurRec) <> "N" OR tnCurRec <= 0
    RETURN .F.
ENDIF
RETURN (RECNO(tcAlias) = tnCurRec)
ENDFUNC



*---------------------------------------------------------
* AU_PosicionarBordeFila(toForm, toGrid, toShape)
* Reubica el shape visual que marca la fila activa sobre
* un grid, usando la fila y altura actuales.
*---------------------------------------------------------
FUNCTION AU_PosicionarBordeFila
LPARAMETERS toForm, toGrid, toShape
LOCAL lnRow, lnHeader, lnTop

IF VARTYPE(toForm) <> "O" OR VARTYPE(toGrid) <> "O" OR VARTYPE(toShape) <> "O"
    RETURN .F.
ENDIF

IF toGrid.ActiveRow <= 0
    toShape.Visible = .F.
    RETURN .F.
ENDIF

lnRow = toGrid.ActiveRow
lnHeader = IIF(PEMSTATUS(toGrid,"HeaderHeight",5), toGrid.HeaderHeight, 0)
lnTop = toGrid.Top + lnHeader + ((lnRow - 1) * toGrid.RowHeight)

WITH toShape
    .BackStyle   = 0
    .BorderWidth = IIF(PEMSTATUS(toShape, "BorderWidth", 5), .BorderWidth, 2)
    .Left        = toGrid.Left + 1
    .Top         = lnTop + 1
    .Width       = toGrid.Width - 2
    .Height      = toGrid.RowHeight - 2
    .Visible     = .T.
    .ZOrder(0)
ENDWITH

RETURN .T.
ENDFUNC