LOCAL lnI
AUSED(laCursores) && Poner tablas abiertas en un array
FOR lnI = 1 TO ALEN(laCursores) STEP 2
	SELECT (laCursores(lnI))
	IF ".TMP" $ DBF() && Es un cursor
		USE IN (laCursores(lnI)) &&Cerrarlo
	ENDIF
ENDFOR 