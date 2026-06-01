close all
local codaux
sele 0
use facturas
set order to fac_codi
seek 8333
skip
if found()
	codaux=fac_codi-2
	do while !eof()
		repla fac_codi with codaux
		codaux=codaux+1
		skip
	enddo
endif