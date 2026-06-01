&& JSON Utilities PRG

DEFINE CLASS JSONUtils AS Custom

    FUNCTION JSONToCursor(tcJson, tcCursor)
        LOCAL loJS, loData, lnCount, i, lcFields, lcFieldName, loItem, loKeys, lnKeys, lcType, lcSql

        IF EMPTY(tcJson)
            RETURN .F.
        ENDIF

        TRY
            loJS = CREATEOBJECT("ScriptControl")
            loJS.Language = "JScript"
            loData = loJS.Eval("(" + tcJson + ")")
        CATCH
            RETURN .F.
        ENDTRY

        *-- Si no es un array, error
        IF VARTYPE(loData) # "O" OR !loJS.Eval("Array.isArray(" + "(" + tcJson + ")" + ")")
            RETURN .F.
        ENDIF

        lnCount = loJS.Eval("(" + tcJson + ").length")
        IF lnCount = 0
            RETURN .F.
        ENDIF

        *-- Obtener claves del primer objeto
        loKeys = loJS.Eval("Object.keys(" + "(" + tcJson + ")[0])")
        lnKeys = loJS.Eval("Object.keys(" + "(" + tcJson + ")[0]).length")

        *-- Crear SQL dinámico
        lcFields = ""
        FOR i = 0 TO lnKeys - 1
            lcFieldName = ALLTRIM(loJS.Eval("Object.keys(" + "(" + tcJson + ")[0])[" + TRANSFORM(i) + "]"))
            lcFields = lcFields + IIF(EMPTY(lcFields), "", ",") + lcFieldName + " C(254)"
        NEXT

        lcSql = "CREATE CURSOR " + tcCursor + " (" + lcFields + ")"
        &lcSql

        *-- Insertar registros
        FOR i = 0 TO lnCount - 1
            loItem = loJS.Eval("(" + tcJson + ")[" + TRANSFORM(i) + "]")
            APPEND BLANK
            FOR j = 0 TO lnKeys - 1
                lcFieldName = ALLTRIM(loJS.Eval("Object.keys(" + "(" + tcJson + ")[0])[" + TRANSFORM(j) + "]"))
                REPLACE &lcFieldName WITH TRANSFORM(loItem.&lcFieldName)
            NEXT
        NEXT

        RETURN .T.
    ENDFUNC

ENDDEFINE