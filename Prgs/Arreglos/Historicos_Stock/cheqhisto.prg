SET CENTURY on
SET DATE BRITISH
LOCAL cn, xarti, xstact, xmov, xstpos, xresul
DIMENSION xstact[1,1], xmov[1,1], xstpos[1,1]

STORE 0 TO xarti, xresul, xstact[1,1], xmov[1,1], xstpos[1,1]

CREATE CURSOR art_error(art_codi N(8),hs_anterior N(15,3),hs_cant N(15,3), hs_saldo N(15,3), hs_resul N(15,3))

DO "C:\VFP9_MYSQL\Prgs\conexion.prg"

cn= conectar_db(_screen.cn)
	SQLEXEC(cn,"select * from histostock order by hs_codi;","cur_histo")
desconectar_db(cn)

IF RECCOUNT("cur_histo")>0
	SELECT cur_histo
	GO top
	SELECT art_codi FROM cur_histo ORDER BY art_codi GROUP BY art_codi INTO CURSOR cur_artis
	IF RECCOUNT("cur_artis")>0
		SELECT cur_artis
		GO top
		SCAN
			STORE 0 TO xarti, xstact[1,1], xmov[1,1], xstpos[1,1]
			xarti = cur_artis.art_codi
			SELECT SUM(hs_anterior) FROM cur_histo WHERE art_codi = xarti GROUP BY art_codi INTO ARRAY xstact
			SELECT SUM(hs_cant) FROM cur_histo WHERE art_codi = xarti GROUP BY art_codi  INTO ARRAY xmov
			SELECT SUM(hs_saldo) FROM cur_histo WHERE art_codi = xarti GROUP BY art_codi  INTO ARRAY xstpos
			
			xresul = xstact[1,1] + xmov[1,1]
			
			INSERT INTO art_error VALUES (xarti, xstact[1,1], xmov[1,1], xstpos[1,1], xresul)
			
			SELECT cur_artis
		ENDSCAN
	ENDIF
	
	IF RECCOUNT("art_error")>0
		SET SAFETY OFF
		SELECT cur_histo
		GO top
		COPY TO "C:\Users\Administrador\Desktop\histo_total_08-05-2026.xls" TYPE xl5
		SELECT art_error
		GO top
		COPY TO "C:\Users\Administrador\Desktop\histo_08-05-2026.xls" TYPE xl5
		SET SAFETY ON
		MESSAGEBOX("Archivo Excel generado exitosamente",64,"Archivos Excel")
	ELSE
		MESSAGEBOX("No se encontraron artículos con problemas en Históricos de Stock",48,"Historicos de Stock")
	ENDIF
ENDIF
