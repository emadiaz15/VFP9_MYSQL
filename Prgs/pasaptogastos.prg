close all
sele 0
use gastos
set order to gas_codi
sele 0
use "c:\nueva carpeta\gastos\puntogastos.dbf"
index on gas_codi to gas_codi
set rela to gas_codi into gastos
go top
scan
	repla gastos.gas_pto with gas_pto
endscan