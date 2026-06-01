close all
create cursor mem(codi D,ob M)
set defa to "d:\hp electricidad"
select aju_codi,aju_observ from ajustes into cursor mem
sele mem

*index on aju_codi to cc
set defa to "f"
sele 0
use ajustes
set order to aju_codi
set rela to aju_codi into mem addi
go top
scan
	if aju_codi>1560
		exit
	endif
	repla aju_observ with mem.aju_observ
endscan

