close all
set talk off
local acu,iva,x
acu=0
iva=0
x=0
sele 0
use iva
set order to iva_codi
sele 0
use facturas_articulos
set order to fac_codi
go top
sele 0
use facturas
set order to fac_codi
set filter to fac_conc="D"
set rela to fac_codi into facturas_articulos addi
set rela to iva_codi into iva addi
go top
scan
	sele facturas_articulos
	x=0
	do while fac_codi=facturas.fac_codi
		x=x+1
		codi=fac_codi
		acu=acu+round(artfac_cant*artfac_impo,2)
*		messagebox(allt(str(facturas.fac_codi))+"   "+allt(artfac_nd))
		if facturas.ivand=0
			repla calciva with "NO"
		else
			if x=2
*				messagebox(allt(str(facturas.fac_tot,10,2))+"  "+allt(str(acu,10,2)))
				iva=round((acu*iva.iva_1)/100,2)
				if iva>facturas.ivand
					skip-1
					if fac_codi=codi
						repla calciva with "NO"
					endif
					skip
				endif
				acu=0
			endif
		endif
		skip
	enddo
	sele facturas
endscan
set filter to