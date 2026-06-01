close all
create cursor auxicos(artpro_codi N(10),art_codi N(8),prov_codi N(8),artpro_costo N(10,3),artpro_ctovta N(10,3),artpro_desc C(45),moneda C(1),lista L)
sele 0
use articulos
set order to art_codi
sele 0
use articulos_proveedores
set order to artpro_cod
sele artpro_codi,art_codi,prov_codi,artpro_costo,iif(moneda="D",artpro_ctovta*4.90,artpro_ctovta) as "artpro_ctovta",artpro_desc,moneda,lista ;
	 from articulos_proveedores where prov_codi<>46 and art_codi>0 and prov_codi>0 and !deleted() order by art_codi,artpro_ctovta desc into cursor auxicostos
sele auxicostos
set rela to artpro_codi into articulos_proveedores addi
set rela to art_codi into articulos addi
go top
scan
	arti=art_codi
	*repla articulos_proveedores.lista with .T.
	if arti=art_codi
		do while arti=art_codi
			if artpro_costo=round(articulos.art_precio/1.47,3)
				repla articulos_proveedores.lista with .T.
			endif
			skip
		enddo
		skip-1
*	else
*		repla articulos_proveedores.lista with .T.
	endif
endscan
