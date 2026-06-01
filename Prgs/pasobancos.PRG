close all
sele 0
use "C:\Users\Administrador\Desktop\Saldosflexx\EXCEL TABLAS SISTEMA MIO\segucheq"
set filter to ban_codi>0
sele 0
use recibos_pagos
set order to recpag_cod

sele segucheq
set rela to recpag_codi into recibos_pagos addi
*!*	set filter to ban_codi>0 and recpag_codi<=22971
go top
scan
	repla recibos_pagos.ban_codi with ban_codi
	repla recibos_pagos.suc_codi with suc_codi
	wait wind at 20,120 allt(str(recibos_pagos.recpag_codi))+"     "+allt(str(recpag_codi)) nowait
endscan
