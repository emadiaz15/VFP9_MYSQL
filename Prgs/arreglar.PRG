close all
set talk off
sele 0
use facturas_articulos
set order to fac_codi
select * from remitos where rem_fech>ctod("28/02/2004") into cursor auxiliar
index on rem_nro to numero
sele 0
use articulos
set order to art_codi
*sele 0
*use ajustes
*set order to aju_codi
sele 0
use remitos_articulos
*select art_codi,art_desc,art_stock from "d:\hp electricidad\articulos" order by art_codi into cursor auxiliar
set rela to rem_nro into auxiliar addi
set rela to art_codi into articulos addi
*scan
*	repla articulos.art_stock with art_stock
*endscan
set order to rem_nro
seek 2037
do while !eof()
	if artrem_sstock="S"
		skip
		loop
	endif
	if auxiliar.fac_codi>0
		sele facturas_articulos
		seek auxiliar.fac_codi
*		=messagebox(str(remitos_articulos.rem_nro)+"      "+str(remitos_articulos.art_codi),"Remitos")
*		=messagebox(str(fac_codi)+"      "+str(art_codi),"Facturas")
		do while art_codi<>remitos_articulos.art_codi	
			skip
		enddo
		if artfac_sstock="S"
			sele remitos_articulos
			repla articulos.art_stock with articulos.art_stock-artrem_cant
		endif
		sele remitos_articulos
	else
		repla articulos.art_stock with articulos.art_stock-artrem_cant
	endif
*	do case
*		case ajustes.aju_conc="E"
*			repla articulos.art_stock with articulos.art_stock+artaju_cant
*		case ajustes.aju_conc="S"
*			repla articulos.art_stock with articulos.art_stock-artaju_cant
*	endcase
*	if auxiliar.fac_codi=0
*		if artrem_sstock<>"S"
*			repla articulos.art_stock with articulos.art_stock+artrem_cant
*		endif
*	endif
	skip
enddo