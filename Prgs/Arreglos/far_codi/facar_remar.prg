DO "c:\vfp9_mysql\prgs\conexion.prg"

PUBLIC cn
LOCAL xfar, xrer, xcan

cn= conectar_db(_screen.cn)
	SQLEXEC(cn,"call a_imp_paso1();","cur_remar")
	SQLEXEC(cn,"select far_codi,fac_codi,art_codi,artfac_cant,rpad(SUBSTR(artfac_dasc,1,60), 60,' ') artfac_dasc,remitado from facturas_articulos;","cur_facar")
desconectar_db(cn)

SELECT cur_facar
INDEX on ALLTRIM(STR(fac_codi))+ALLTRIM(STR(art_codi))+SUBSTR(ALLTRIM(artfac_dasc),1,45) TO codiff
SELECT cur_remar
INDEX on ALLTRIM(STR(fac_codi))+ALLTRIM(STR(art_codi))+SUBSTR(ALLTRIM(artfac_dasc),1,45) TO codifr
SET RELATION TO ALLTRIM(STR(fac_codi))+ALLTRIM(STR(art_codi))+SUBSTR(ALLTRIM(artfac_dasc),1,45) INTO cur_facar addi

SELECT cur_remar
IF RECCOUNT("cur_remar") > 0
	LOCATE
	SCAN
		xfar = cur_facar.far_codi
		IF xfar > 0
			xrer = cur_remar.rer_codi
			xcan = cur_facar.artfac_cant
			cn= conectar_db(_screen.cn)
				SQLEXEC(cn,"insert into facar_remar values(?xfar, ?xrer, ?xcan);")
			desconectar_db(cn)
		ENDIF
	ENDSCAN
ENDIF

MESSAGEBOX("Proceso Finalizado Correctamente",0+64,"Aviso del Sistema")

cerrar_cursor("cur_remar")
cerrar_cursor("cur_facar")