FUNCTION Monto2Letra
LPARAMETERS tyMonto,lcletra
*, tlDolares
LOCAL lyEntero, lyCentavos, lnNumeroBloques, lnPrimerDigito, lnSegundoDigito, lnTercerDigito, ;
	  lcBloque, lnBloqueCero, lcLetra

DIMENSION laUnidades(29), laDecenas(9), laCentenas(9) 

tyMonto = ROUND(tyMonto, 2)
lyEntero = INT(tyMonto)
lcLetra = IIF(lyEntero = 0, "CERO", "")
lyCentavos = (tyMonto - lyEntero) * 100

laUnidades(1) = "UN"
laUnidades(2) = "DOS"
laUnidades(3) = "TRES"
laUnidades(4) = "CUATRO"
laUnidades(5) = "CINCO"
laUnidades(6) = "SEIS"
laUnidades(7) = "SIETE"
laUnidades(8) = "OCHO"
laUnidades(9) = "NUEVE"
laUnidades(10) = "DIEZ"
laUnidades(11) = "ONCE"
laUnidades(12) = "DOCE"
laUnidades(13) = "TRECE"
laUnidades(14) = "CATORCE"
laUnidades(15) = "QUINCE"
laUnidades(16) = "DIECISEIS"
laUnidades(17) = "DIECISIETE"
laUnidades(18) = "DIECIOCHO"
laUnidades(19) = "DIECINUEVE"
laUnidades(20) = "VEINTE"
laUnidades(21) = "VENTIUN"
laUnidades(22) = "VEINTIDOS"
laUnidades(23) = "VEINTITRES"
laUnidades(24) = "VEINTICUATRO"
laUnidades(25) = "VEINTICINCO"
laUnidades(26) = "VEINTISEIS"
laUnidades(27) = "VEINTISIETE"
laUnidades(28) = "VEINTIOCHO"
laUnidades(29) = "VEINTINUEVE"

laDecenas(1) = "DIEZ"
laDecenas(2) = "VEINTE"
laDecenas(3) = "TREINTA"
laDecenas(4) = "CUARENTA"
laDecenas(5) = "CINCUENTA"
laDecenas(6) = "SESENTA"
laDecenas(7) = "SETENTA"
laDecenas(8) = "OCHENTA"
laDecenas(9) = "NOVENTA"

laCentenas(1) = "CIENTO"
laCentenas(2) = "DOSCIENTOS"
laCentenas(3) = "TRESCIENTOS"
laCentenas(4) = "CUATROCIENTOS"
laCentenas(5) = "QUINIENTOS"
laCentenas(6) = "SEISCIENTOS"
laCentenas(7) = "SETECIENTOS"
laCentenas(8) = "OCHOCIENTOS"
laCentenas(9) = "NOVECIENTOS"

lnNumeroBloques = 1

DO WHILE lyEntero > 0
	lnPrimerDigito = 0
	lnSegundoDigito = 0
	lnTercerDigito = 0
	lcBloque = ""
	lnBloqueCero = 0
	FOR i = 1 TO 3
		lnDigito = MOD(lyEntero, 10)
		IF lnDigito <> 0 THEN
			DO CASE
				CASE i = 1
					lcBloque = " " + laUnidades(lnDigito)
					lnPrimerDigito = lnDigito
				CASE i = 2
					IF lnDigito <= 2 THEN
						lcBloque = " " + laUnidades((lnDigito * 10) + lnPrimerDigito)
					ELSE
						lcBloque = " " + laDecenas(lnDigito) + IIF(lnPrimerDigito <> 0, " Y", "") + lcBloque
					ENDIF
					lnSegundoDigito = lnDigito
				CASE i = 3
					lcBloque = " " + IIF(lnDigito = 1 AND lnPrimerDigito = 0 AND lnSegundoDigito = 0, "CIEN", ;
					laCentenas(lnDigito)) + lcBloque
					lnTercerDigito = lnDigito
				ENDCASE
		ELSE
			lnBloqueCero = lnBloqueCero + 1
		ENDIF
		lyEntero = INT(lyEntero / 10)
		IF lyentero = 0 THEN
			EXIT FOR
		ENDIF
	ENDFOR
	DO CASE
		CASE lnNumeroBloques = 1
			lcLetra = lcBloque
		CASE lnNumeroBloques = 2
			lcLetra = lcBloque + IIF(lnBloqueCero <> 3, " MIL", "") + lcLetra
		CASE lnNumeroBloques = 3
			lcLetra = lcBloque + IIF(lnPrimerDigito = 1 AND lnSegundoDigito = 0 AND lnTercerDigito = 0, ;
			" MILLON", " MILLONES") + lcLetra
		ENDCASE
	lnNumeroBloques = lnNumeroBloques + 1
ENDDO
*IF tlDolares THEN
*lcLetra = ALLTRIM(lcLetra) + " CON " + ;
*	REPLICATE("0", 2 - LEN(ALLTRIM(STR(lyCentavos)))) + ALLTRIM(STR(lyCentavos)) + "/100"
*ELSE
	lcLetra = ALLTRIM(lcLetra) + " CON " +;
	REPLICATE("0", 2 - LEN(ALLTRIM(STR(lyCentavos)))) + ALLTRIM(STR(lyCentavos)) + "/100.-"
*ENDIF
*+ IIF(INT(tyMonto) = 1, " PESO ", " PESOS ") 
*=messagebox(allt(lcletra))
RETURN lcLetra
ENDFUNC