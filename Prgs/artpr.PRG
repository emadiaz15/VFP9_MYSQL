close all
set dele on
local art,valor
art=0
valor=0
create cursor listado(codigo N(8),descripcion C(38),stock N(10,3),compras N(10,3),pedidos N(10,3),posicion N(10,3),posmin N(10,3))
sele 0
use articulos
set order to art_codi
sele 0
use articulos_proveedores
set rela to art_codi into articulos addi
go top
set filter to prov_codi=65
scan for !deleted()
	valor=0
	art=art_codi
	dimension totped[1,1]
	totped[1,1]=0		 
	select sum(artped_cant-artped_ent) from pedidos_articulos where art_codi=art and artped_ent<artped_cant into array totped
	dimension totcom[1,1]
	totcom[1,1]=0				
	select sum(b.artord_cant-b.artord_ent) from compras as a inner join compras_articulos as b ;
		on a.orden_codi=b.orden_codi where a.anulado<>"S" and art_codi=art and artord_ent<artord_cant into array totcom
	valor=articulos.art_stock+totcom-totped
	wait wind allt(allt(str(art))+"  "+allt(articulos.art_desc)) nowait
	insert into listado(codigo,descripcion,stock,compras,pedidos,posicion,posmin) ;
					values(art,articulos.art_desc,articulos.art_stock,totcom,totped,valor,articulos.art_stmin)
endscan
set safety off
set point to ","
selec * from listado to file "c:\Documents and Settings\Administrador.HPELECTRICIDAD\Escritorio\Interelec.xls" order by codigo noconsole
set point to
set safety on
