*!*	select a.orden_fech,a.orden_codi,c.prov_nomb,b.art_codi,iif(b.art_codi=4,b.artord_dasc,d.art_desc),b.artord_cant,b.artord_ent from compras as a inner join compras_articulos as b ;
*!*		 on a.orden_codi=b.orden_codi,proveedores as c, articulos as d where c.prov_codi=a.prov_codi and d.art_codi=b.art_codi and a.cumplido<>"S" and a.anulado<>"S" ;
*!*		 and a.prov_codi<>46 and b.artord_ent<b.artord_cant and a.orden_fech<=ctod("31/05/2012") and !deleted() order by a.prov_codi,a.orden_fech,a.prov_codi into cursor pendi

*!*	OTRA

*!*	select a.orden_codi,a.orden_fech,b.prov_nomb from compras as a inner join proveedores as b on a.prov_codi=b.prov_codi where a.cumplido<>"S" ;
*!*		 and a.anulado<>"S" and !deleted() and a.orden_fech<=ctod("31/05/2012") and a.prov_codi<>46 order by b.prov_nomb,a.orden_codi
