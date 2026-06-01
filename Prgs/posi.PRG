close all
creat cursor posic(codigo N(8),art_desc C(35),st N(10,3),ped N(10,3),cpr N(10,3),posicion N(10,3),posmin N(10,3))
set point to ","
set dele on
sele 0
use articulos
set order to rub_codi
seek 970000
scan for inlist(rub_codi,6830000,6840000)
	articulo=art_codi
	dimension totped[1,1]
	totped[1,1]=0
	select sum(artped_cant-artped_ent) from pedidos_articulos where art_codi=articulo and artped_ent<artped_cant into array totped
	dimension totcom[1,1]
	totcom[1,1]=0				
	select sum(b.artord_cant-b.artord_ent) from compras as a inner join compras_articulos as b ;
		on a.orden_codi=b.orden_codi where a.anulado<>"S" and art_codi=articulo and artord_ent<artord_cant into array totcom
	calculo=art_stock+totcom-totped
	insert into posic(codigo,art_desc,st,ped,cpr,posicion,posmin);
				values(articulos.art_codi,articulos.art_desc,articulos.art_stock,totped,totcom,calculo,articulos.art_stmin)
*	=messagebox(allt(str(art_stock+totcom-totped,10,3)))
endscan
sele posic
go top
sele * from posic order by codigo to file "\\terminal-9\c$\documents and settings\administrador.hpelectricidad.000\escritorio\centilux.xls" noconsole