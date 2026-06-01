close all
codigo=0
dimension fact[1,1]
fact[1,1]=0
dimension nc[1,1]
nc[1,1]=0
dimension recepfac[1,1]
recepfac[1,1]=0
dimension recepnc[1,1]
recepnc[1,1]=0
dimension ent[1,1]
ent[1,1]=0
dimension sal[1,1]
sal[1,1]=0
valor=0
create cursor cierinve(art_codi N(8),art_desc C(45),art_stock N(10,3))
set talk off
sele 0
use articulos
set order to art_codi
scan for art_codi<>4
	codigo=art_codi
	select round(sum(b.artfac_cant),2) from facturas as a inner join facturas_articulos as b ;
		on a.fac_codi=b.fac_codi where b.art_codi=codigo and a.fac_fec>ctod("31/01/2004") ;
		and a.fac_conc<>"N" and a.anulado<>"S" and b.artfac_sstock<>"S" into array fact
	select round(sum(b.artfac_cant),2) from facturas as a inner join facturas_articulos as b ;
		on a.fac_codi=b.fac_codi where b.art_codi=codigo and a.fac_fec>ctod("31/01/2004") ;
		and a.fac_conc="N" and a.anulado<>"S" and b.artfac_sstock<>"S" into array nc
	select round(sum(b.artrecep_cant),2) from recepciones as a inner join recepciones_articulos ;
		as b on a.recep_codi=b.recep_codi where b.art_codi=codigo and a.recep_fec>ctod("31/12/2004") ;
		and a.recep_conc<>"N" and b.recep_sstock<>"S" into array recepfac
	select round(sum(b.artrecep_cant),2) from recepciones as a inner join recepciones_articulos ;
		as b on a.recep_codi=b.recep_codi where b.art_codi=codigo and a.recep_fec>ctod("31/12/2004") ;
		and a.recep_conc="N" and b.recep_sstock<>"S" into array recepnc
	select round(sum(b.artaju_cant),2) from ajustes as a inner join ajustes_articulos as b ;
		on b.art_codi=codigo and a.aju_fech>ctod("31/12/2004") and a.aju_conc="E" ;
		into array ent
	select round(sum(b.artaju_cant),2) from ajustes as a inner join ajustes_articulos as b ;
		on b.art_codi=codigo and a.aju_fech>ctod("31/12/2004") and a.aju_conc="S" ;
		into array sal
	valor=articulos.art_stock+fact[1,1]-nc[1,1]-recepfac[1,1]+recepnc[1,1]-ent[1,1]+sal[1,1]
	insert into cierinve(art_codi,art_desc,art_stock) ;
		values(articulos.art_codi,articulos.art_desc,valor)
	
endscan
sele cierinve
brow