&&api_client.prg

DEFINE CLASS APIClient AS Custom
    cBaseUrl = ""
    cAuthToken = ""

    FUNCTION SetBaseUrl(tcUrl)
        THIS.cBaseUrl = IIF(RIGHT(tcUrl,1)="/", tcUrl, tcUrl+"/")
    ENDFUNC

    FUNCTION SetAuthToken(tcToken)
        THIS.cAuthToken = tcToken
    ENDFUNC

    FUNCTION SendRequest(tcMethod, tcEndpoint, tcBody, tlShowRaw)
        LOCAL loHttp, lcUrl, lcResponse
        loHttp = CREATEOBJECT("WinHttp.WinHttpRequest.5.1")
        lcUrl = THIS.cBaseUrl + tcEndpoint
        loHttp.Open(tcMethod, lcUrl, .F.)
        loHttp.SetRequestHeader("Content-Type", "application/json; charset=utf-8")
        IF !EMPTY(THIS.cAuthToken)
            loHttp.SetRequestHeader("Authorization", "Bearer " + THIS.cAuthToken)
        ENDIF
        TRY
            loHttp.Send(tcBody)
            lcResponse = loHttp.ResponseText
        CATCH TO loEx
            lcResponse = "Error: " + loEx.Message
        ENDTRY
        IF tlShowRaw
            ? "URL:", lcUrl
            ? "Método:", tcMethod
            ? "Respuesta:", lcResponse
        ENDIF
        RETURN lcResponse
    ENDFUNC

    FUNCTION Get(tcEndpoint, tlShowRaw)
        RETURN THIS.SendRequest("GET", tcEndpoint, "", tlShowRaw)
    ENDFUNC

    FUNCTION Post(tcEndpoint, tcJsonBody, tlShowRaw)
        RETURN THIS.SendRequest("POST", tcEndpoint, tcJsonBody, tlShowRaw)
    ENDFUNC

    FUNCTION Put(tcEndpoint, tcJsonBody, tlShowRaw)
        RETURN THIS.SendRequest("PUT", tcEndpoint, tcJsonBody, tlShowRaw)
    ENDFUNC

    FUNCTION Patch(tcEndpoint, tcJsonBody, tlShowRaw)
        RETURN THIS.SendRequest("PATCH", tcEndpoint, tcJsonBody, tlShowRaw)
    ENDFUNC

    FUNCTION Delete(tcEndpoint, tlShowRaw)
        RETURN THIS.SendRequest("DELETE", tcEndpoint, "", tlShowRaw)
    ENDFUNC
ENDDEFINE
