close all
sele 0
use recibos_facturas
set filter to between(fac_codi,4184,17554)
set order to rec_codi
go bott
*brow
scan for between(recfac_codi,7845,15272)
	wait wind allt(str(recfac_codi))+"  "+allt(str(fac_codi)) nowait
	repla fac_codi with fac_codi-1
	wait wind allt(str(recfac_codi))+"  "+allt(str(fac_codi)) nowait
endscan