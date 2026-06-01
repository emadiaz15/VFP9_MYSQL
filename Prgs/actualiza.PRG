close all
sele 0
use articulos
set order to art_codi
do while .T.
	if last()=27
		exit
	endif
	articulo=0
	@ 05,06 say "Código: " get articulo pict "@L########"
	read
	seek articulo
	if found()
		@ 07,06 say art_desc
		@ 09,06 say "Stock: " get art_stock pict "@L######.###"
	endif
enddo
	
