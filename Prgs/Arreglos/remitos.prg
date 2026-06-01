SET DATE BRITISH
SET CENTURY on

PUBLIC cn

*!*	SELECT * FROM remitos ORDER BY rem_codi INTO CURSOR cur_rem
*!*	SELECT * FROM remitos_articulos ORDER BY rem_codi INTO CURSOR cur_remart
SELECT * FROM remitos_transportes ORDER BY rem_codi INTO CURSOR cur_remtra

*!*	USE IN remitos
*!*	USE IN remitos_articulos
USE IN remitos_transportes

cn= conectar_db(_screen.cn)

*!*	SELECT cur_rem
*!*	LOCATE
*!*	SCAN
*!*		xrcod=cur_rem.rem_codi
*!*		xnro =cur_rem.rem_nro
*!*		xpto =cur_rem.rem_pto
*!*		xfech=cur_rem.rem_fech
*!*		xfac =cur_rem.fac_codi
*!*		xtra =cur_rem.tran_codi
*!*		xcli =cur_rem.cli_codi
*!*		xpro =cur_rem.prov_codi
*!*		xfle =cur_rem.flete_carg
*!*		xpes =cur_rem.flete_peso
*!*		xval =cur_rem.flete_valo
*!*		xlug =cur_rem.flete_luge
*!*		xobs =cur_rem.rem_observ
*!*		xanu =cur_rem.anulado
*!*		
*!*		SQLEXEC(cn,"insert into remitos values(?xrcod,?xnro,?xpto,?xfech,?xfac,?xtra,?xcli,?xpro,?xfle,?xpes,?xval,?xlug,?xobs,?xanu);")
*!*	ENDSCAN

*!*	SELECT cur_remart
*!*	LOCATE
*!*	SCAN
*!*		xrcod=cur_remart.rem_codi
*!*		xacod=cur_remart.art_codi
*!*		xnro =cur_remart.rem_nro
*!*		xcan =cur_remart.artrem_can
*!*		xdas =cur_remart.artrem_das
*!*		xdac =cur_remart.dac_codi
*!*		xdap =cur_remart.dap_codi
*!*		xdde =cur_remart.artrem_dde
*!*		xsst =cur_remart.artrem_sst
*!*		xarp =cur_remart.artped_cod
*!*		
*!*		SQLEXEC(cn,"insert into remitos_articulos values(?xrcod,?xacod,?xnro,?xcan,?xdas,?xdac,?xdap,?xdde,?xsst,?xarp);")
*!*	ENDSCAN

SELECT cur_remtra
LOCATE
SCAN
	xrcod=cur_remtra.rem_codi
	xtra =cur_remtra.tran_codi
	xlug =cur_remtra.flete_luge
	xcar =cur_remtra.flete_carg
	
	SQLEXEC(cn,"insert into remitos_transportes values(?xrcod,?xtra,?xlug,?xcar);")
ENDSCAN


MESSAGEBOX("La operación a finalizado con éxito",64,"Aviso del Sistema")

desconectar_db(cn)