close all
create cursor artlamp(art_codi N(8),art_desc C(38),art_stock N(10,2),art_stmin N(10,2),cantped N(10,2),cantcom N(10,2),posi N(10))
set dele on
set point to ","
set 
sele 0
use articulos
set order to art_codi
set filter to between(art_codi,5400160,5510150)
go top
scan
	codart=art_codi
	dimension totped[1,1]
	totped[1,1]=0
	select sum(artped_cant-artped_ent) from pedidos_articulos where art_codi=codart and artped_ent<artped_cant into array totped
	dimension totcom[1,1]
	totcom[1,1]=0				
	select sum(b.artord_cant-b.artord_ent) from compras as a inner join compras_articulos as b ;
		on a.orden_codi=b.orden_codi where a.anulado<>"S" and art_codi=codart and artord_ent<artord_cant into array totcom
	insert into artlamp(art_codi,art_desc,art_stock,art_stmin,cantped,cantcom,posi) ;
				values(codart,articulos.art_desc,articulos.art_stock,articulos.art_stmin,totped,totcom,articulos.art_stock+totcom-totped)
endscan

sele artlamp
go top
select * from artlamp to file "\\terminal-9\c$\documents and settings\administrador.hpelectricidad.000\escritorio\lamparas.xls" noconsole
set point to