close all
sele 0
use facturas
go top
scan 
 aux=fac_nro
 skip
 if fac_nro<>aux+1
 	brow
 endif
 skip -1
endscan