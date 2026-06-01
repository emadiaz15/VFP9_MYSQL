close all
set dele on
create cursor traspaso(fac_codi N(8),imp_pag N(10,2),fac_ng N(10,2),neto_1 N(10,2),neto_2 N(10,2),fac_ivari N(10,2),fac_ivarni N(10,2))
sele 0
use facturas
set order to fac_codi
go top
scan
	insert into traspaso(fac_codi,imp_pag,fac_ng,neto_1,neto_2,fac_ivari,fac_ivarni) ;
			values(facturas.fac_codi,facturas.imp_pag,facturas.fac_ng,facturas.neto_1,facturas.neto_2,facturas.fac_ivari,facturas.fac_ivarni)
endscan

sele traspaso
index on fac_codi to cod
go top
set path to "h"
sele 0
use h:\facturas
set order to fac_codi
go top

set rela to fac_codi into traspaso
scan
	repla imp_pag with traspaso.imp_pag
	repla fac_ng with traspaso.fac_ng
	repla neto_1 with traspaso.neto_1
	repla neto_2 with traspaso.neto_2
	repla fac_ivari with traspaso.fac_ivari
	repla fac_ivarni with traspaso.fac_ivarni
endscan
go top
brow nowait
sele traspaso
brow nowait