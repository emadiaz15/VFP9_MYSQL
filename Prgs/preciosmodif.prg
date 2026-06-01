close all
set talk off
set dele on
set date british
set cent on
set point to ","
sele 0
use rubros
set order to rub_codi
sele 0
use articulos
set order to art_codi
*set rela to rub_codi into rubros addi
go top
select distinct b.art_codi,c.art_precio,c.art_desc,c.rub_codi from histocosto as a inner join articulos_proveedores as b ;
	on a.artpro_codi=b.artpro_codi,articulos as c where c.art_codi=b.art_codi and ;
	a.histo_fech>ctod("02/06/2017") into cursor auxi
*index on art_codi to cc
set safety off
index on str(rub_codi)+str(art_codi) to SYS(2015)
set safety on
set rela to art_codi into articulos addi
set rela to rub_codi into rubros addi
local rubroc,fila,columna,hoja
store 0 to rubroc
*set devi to file "\\Terminal-9\c$\Costos Faltantes.xls" ascii
set devi to printer prompt
columna=1
hoja=1
@ 1,25 say "PRECIOS MODIFICADOS AL "+allt(dtoc(date()))+" (s/iva)" font 'Courier New',12 style 'BU'
@ 3,0 say repl("=",104)
@ 4,0 say "CODIGO  DESCRIPCION                    EXIS  PRECIO  CODIGO  DESCRIPCION                    EXIS" font 'Courier New',9 style 'N'
*@ 4,0 say "CODIGO  DESCRIPCION                          PRECIO  CODIGO  DESCRIPCION                        " font 'Courier New',9 style 'N'
@ 4,119 say "PRECIO" font 'Courier New',9 style 'N'
@ 5,0 say repl("=",104)
fila=6
artaux=0
do while !eof()
	if art_codi=4
		skip
		loop
	endif
	if artaux=art_codi
		skip
		loop
	endif
	artaux=art_codi
*	sele auxi
*	set order to cc
*	seek artaux
*	if found()
*		sele articulos
*		if art_codi=4
*			skip
*			loop
*		endif
*	else
*		sele articulos
*		skip
*		loop
*	endif
	rubroc=rub_codi
	columna=0
	if fila=5
		@ 1,2 say "Fecha: "+allt(dtoc(date())) font 'Courier New',9 style 'N'
		@ 1,105 say "HOJA: "+allt(str(hoja)) font 'Courier New',9 style 'N'
		@ 2,0 say repl("=",104)
		@ 3,0 say "CODIGO  DESCRIPCION                    EXIS  PRECIO  CODIGO  DESCRIPCION                    EXIS" font 'Courier New',9 style 'N'
*		@ 3,0 say "CODIGO  DESCRIPCION                          PRECIO  CODIGO  DESCRIPCION                        " font 'Courier New',9 style 'N'
		@ 3,119 say "PRECIO" font 'Courier New',9 style 'N'
		@ 4,0 say repl("=",104)
	endif
	@ fila,columna say repl("0",8-len(allt(str(rubros.rub_codi))))+allt(str(rubros.rub_codi));
		font 'Courier New',8 style 'B'
	@ fila,columna+9 say substr(allt(rubros.rub_desc),1,36) font 'Courier New',8 style 'B'
	fila=fila+1
	do while rub_codi=rubroc
		columna=0
		if fila=5
*			@ 1,34 clear
			@ 1,2 say "Fecha: "+allt(dtoc(date())) font 'Courier New',9 style 'N'
			@ 1,105 say "HOJA: "+allt(str(hoja)) font 'Courier New',9 style 'N'
			@ 2,0 say repl("=",104)
 	  		@ 3,0 say "CODIGO  DESCRIPCION                    EXIS  PRECIO  CODIGO  DESCRIPCION                    EXIS" font 'Courier New',9 style 'N'
*			@ 3,0 say "CODIGO  DESCRIPCION                          PRECIO  CODIGO  DESCRIPCION                        " font 'Courier New',9 style 'N'
			@ 3,119 say "PRECIO" font 'Courier New',9 style 'N'
			@ 4,0 say repl("=",104)
		endif
		@ fila,columna say repl("0",8-len(allt(str(articulos.art_codi))))+allt(str(articulos.art_codi)) font 'Courier New',8 style 'N'
*		@ fila,columna+7 say substr(allt(art_desc),1,33) font 'Courier New',8 style 'N'
		@ fila,columna+9 say substr(allt(articulos.art_desc),1,40) font 'Courier New',8 style 'N'
		@ fila,columna+47 say articulos.art_stock pict "99999" font 'Courier New',8 style 'N'
		@ fila,columna+53 say articulos.art_precio pict "99999.999" font 'Courier New',8 style 'N'
		skip
		if rubroc=rub_codi
			columna=64
			@ fila,columna say repl("0",8-len(allt(str(articulos.art_codi))))+allt(str(articulos.art_codi)) font 'Courier New',8 style 'N'
*			@ fila,columna+7 say substr(allt(art_desc),1,33) font 'Courier New',8 style 'N'
			@ fila,columna+9 say substr(allt(articulos.art_desc),1,40) font 'Courier New',8 style 'N'
			@ fila,columna+47 say articulos.art_stock pict "99999" font 'Courier New',8 style 'N'
			@ fila,columna+53 say articulos.art_precio pict "99999.999" font 'Courier New',8 style 'N'
			skip
		endif
		if rubroc<>rub_codi
			fila=fila+2
		else
			fila=fila+1
		endif
		if fila>=68
			fila=5
			hoja=hoja+1
*			wait "Presione una tecla para acceder a otra página..." wind
*			@ 05,00 clear
		endif
	enddo
	if fila>=68
		fila=5
		hoja=hoja+1
*		wait "Presione una tecla para acceder a otra página..." wind
*		@ 05,00 clear
*	else
*		if !eof()
*			fila=fila+1
*		endif
	endif
enddo
set devi to screen
set point to