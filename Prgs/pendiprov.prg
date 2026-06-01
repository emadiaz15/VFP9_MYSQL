close all
set dele on
create cursor pp(art_codi N(8),art_desc C(38),art_stock N(10,3),comprados N(10,3),pedidos N(10,3),posi N(10,3),stockmin N(10,3))
sele 0
use proveedores
sele 0
use articulos
set order to art_codi
sele 0
use articulos_proveedores
set rela to art_codi into articulos addi
set rela to prov_codi into proveedores addi
set filter to prov_codi=13
set order to artprov
go top
scan
	arti=art_codi
	stmin=articulos.art_stmin
	dimension totped[1,1]
	totped[1,1]=0
	select sum(artped_cant-artped_ent) from pedidos_articulos where art_codi=arti and artped_ent<artped_cant into array totped
	dimension totcom[1,1]
	totcom[1,1]=0
	select sum(b.artord_cant-b.artord_ent) from compras as a inner join compras_articulos as b ;
		on a.orden_codi=b.orden_codi where a.anulado<>"S" and art_codi=arti and artord_ent<artord_cant into array totcom
	insert into pp(art_codi,art_desc,art_stock,comprados,pedidos,posi,stockmin) ;
			values(arti,articulos.art_desc,articulos.art_stock,totcom[1,1],totped[1,1],articulos.art_stock+totcom[1,1]-totped[1,1],stmin)
endscan
sele pp
go top
brow

