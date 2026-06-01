close all
set dele on
set point to ","
create cursor posiart(nro N(8),des C(38),st N(10,3),com N(10,3),ped N(10,3),pos N(10,3))
sele 0
use articulos
set order to art_codi
select a.art_codi,b.art_desc from articulos_proveedores as a inner join articulos as b ;
	 on a.art_codi=b.art_codi where a.prov_codi=5 and !deleted() order by a.art_codi into cursor auxiart
sele auxiart
go top
set rela to art_codi into articulos addi
scan
	if art_codi=4
		skip
		loop
	endif
	artaux=art_codi
	dimension totped[1,1]
	totped[1,1]=0
	select sum(b.artped_cant-b.artped_ent) from pedidos as a inner join pedidos_articulos as b ;
		on a.ped_codi=b.ped_codi where b.art_codi=artaux and b.artped_ent<b.artped_cant and a.cumplido<>"S" into array totped
	dimension totcom[1,1]
	totcom[1,1]=0
	select sum(b.artord_cant-b.artord_ent) from compras as a inner join compras_articulos as b ;
		on a.orden_codi=b.orden_codi where a.anulado<>"S" and a.cumplido<>"S" and art_codi=artaux and artord_ent<artord_cant into array totcom
*	=messagebox(allt(str(articulos.art_codi))+chr(13)+ ;
*				allt(articulos.art_desc)+chr(13)+ ;
*				allt(str(totcom,10,3))+chr(13)+;
*				allt(str(totped,10,3)))
	posicion=articulos.art_stock+totcom-totped
	insert into posiart(nro,des,st,com,ped,pos) ;
				values(auxiart.art_codi,articulos.art_desc,articulos.art_stock,totcom,totped,posicion)
endscan
sele posiart
go top
sele * from posiart to file "\\terminal-9\c$\documents and settings\administrador.hpelectricidad.000\escritorio\CABLES.xls" noconsole
set point to