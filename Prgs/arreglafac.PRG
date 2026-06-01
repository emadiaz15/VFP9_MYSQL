close all
*sele 0
*use facturas
*set order to fac_codi
*sele 0
*use facturas_articulos
*set order to fac_codi
sele 0
use remitos
set order to rem_codi

*sele facturas
*set filter to fac_codi>=4185
*go top
*scan
*	repla fac_codi with fac_codi-1
*endscan
*set filter to

*sele facturas_articulos
*set filter to fac_codi>=4185
*go top
*scan
*	repla fac_codi with fac_codi-1
*endscan
*set filter to

sele remitos
set filter to fac_codi>0 and fac_codi>=4185
go top
scan
	repla fac_codi with fac_codi-1
endscan
set filter to