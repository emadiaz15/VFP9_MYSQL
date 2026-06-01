close all
sele 0
use recibos_pagos
set order to recpag_cod
set filter to recpag_codi>=38498 and tippag_codi=3
go top
scan
	if ban_codi>0 and suc_codi>0
		texban=repl('0',3-len(allt(str(ban_codi))))+allt(str(ban_codi))
		texsuc=repl('0',3-len(allt(str(suc_codi))))+allt(str(suc_codi))
		repla chequenro with texban+texsuc+allt(movtippag_nro)
		repla activo with "S"
	endif
endscan
