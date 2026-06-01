close all
sele 0
use facturas
set order to fac_codi
sele 0
use auxi
set order to fac_codi
sele facturas
seek 8335
if found()
	scan for between(fac_codi,8335,8638)
		sele auxi
		appe blank
		repla fac_codi with facturas.fac_codi
		repla fac_nro with facturas.fac_nro
		repla fac_pto with facturas.fac_pto
		repla fac_tipo with facturas.fac_tipo
		repla fac_fec with facturas.fac_fec
		repla imp_pag with facturas.imp_pag
		repla cli_codi with facturas.cli_codi
		repla iva_codi with facturas.iva_codi
		repla fac_dto with facturas.fac_dto
		repla ped_codi with facturas.ped_codi
		repla fac_conc with facturas.fac_conc
		repla pagado with facturas.pagado
		repla nc_texto with facturas.nc_texto
		repla anulado with facturas.anulado
		repla altiva_1 with facturas.altiva_1
		repla altiva_2 with facturas.altiva_2
		repla fac_tot with facturas.fac_tot
		repla fac_pie with facturas.fac_pie
		repla ivanc with facturas.ivanc
		repla ivand with facturas.ivand
		repla com_codi with facturas.com_codi
		repla ven_codi with facturas.ven_codi
		repla porc_codi with facturas.porc_codi
		repla otra_comi with facturas.otra_comi
		sele facturas
	endscan
endif
