close all
set dele on
create cursor pend(art_codi N(8),art_desc C(38),posicion N(10,3))
sele 0
use articulos
set order to art_codi
sele 0
use articulos_proveedores
set order to art_codi
set rela to art_codi into articulos addi
set filter to prov_codi=74
scan
dimension totped[1,1]
	codi=art_codi
	totped[1,1]=0
	select sum(artped_cant-artped_ent) from pedidos_articulos where art_codi=codi and artped_ent<artped_cant into array totped
	dimension totcom[1,1]
	totcom[1,1]=0
	select sum(b.artord_cant-b.artord_ent) from compras as a inner join compras_articulos as b ;
		on a.orden_codi=b.orden_codi where a.anulado<>"S" and art_codi=codi and artord_ent<artord_cant into array totcom
	INSERT INTO pend (art_codi, art_desc, posicion) ;
     VALUES (articulos.art_codi, articulos.art_desc, round(articulos.art_stock+totcom[1,1]-totped[1,1],3))
endscan
sele pend
go top
select * from pend to printer prompt noconsole
