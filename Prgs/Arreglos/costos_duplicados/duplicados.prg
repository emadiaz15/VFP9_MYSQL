SET DATE BRITISH
SET CENTURY ON
*!*	CREATE CURSOR cur_elimi(histo_codi N(8))

DO "C:\VFP9_MYSQL\Prgs\conexion.prg"

PUBLIC cn
LOCAL xap, xfech, xhistoc

WAIT WINDOW "Espere unos minutos por favor... Procesando consulta en la base de datos..." NOWAIT
cn= conectar_db(_screen.cn)
	SQLEXEC(cn,"call a_dupli();","cur_dupli")
desconectar_db(cn)
LOCATE

cn= conectar_db(_screen.cn)
	SQLEXEC(cn,"select * from histocosto where DATE(histo_fech) >= ('2022-01-01') order by histo_codi desc;","cur_histo")
desconectar_db(cn)
LOCATE

SELECT * FROM cur_histo WHERE ALLTRIM(DTOC(TTOD(histo_fech)))+ALLTRIM(STR(artpro_codi)) in ;
	(SELECT ALLTRIM(DTOC(TTOD(histo_fech)))+ALLTRIM(STR(artpro_codi)) FROM cur_dupli) ORDER BY artpro_codi, histo_codi DESC ;
	INTO CURSOR cur_manip

SELECT cur_manip
*!*	SET FILTER TO artpro_codi= 2
LOCATE
*!*	BROWSE
SCAN
	xhistoc = cur_manip.histo_codi
	xap     = cur_manip.artpro_codi
	xfech   = TTOD(cur_manip.histo_fech)
	IF TTOD(cur_manip.histo_fech) = xfech
		IF cur_manip.histo_codi = xhistoc
			SKIP
		ENDIF
		DO WHILE TTOD(cur_manip.histo_fech) = xfech
			cn= conectar_db(_screen.cn)
				SQLEXEC(cn,"delete from histocosto where histo_codi = ?cur_manip.histo_codi;")			
			desconectar_db(cn)
*!*				INSERT INTO cur_elimi value(cur_manip.histo_codi)
			SKIP
		ENDDO
		SKIP -1
	ELSE
		SKIP
	ENDIF
ENDSCAN

*!*	SELECT cur_elimi
*!*	LOCATE
*!*	BROWSE