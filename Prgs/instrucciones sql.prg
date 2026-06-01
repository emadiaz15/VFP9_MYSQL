open data "c:\hp electricidad\base - hp"
*select a.fac_fec as "Fecha",a.fac_conc as "Movim",a.fac_nro as "Nro",c.cli_nomb as "Nombre",b.artfac_cant as "Cant" from facturas as a ;
*	inner join facturas_articulos as b on a.fac_codi=b.fac_codi,clientes as c where c.cli_codi=a.cli_codi and b.artfac_sstock<>"S" and ;
*	b.art_codi=204100 and a.anulado<>"S"
select distinct a.recep_fec as "Fecha",a.recep_conc as "Movim",a.prov_fac as "Nro",c.prov_nomb as "Nombre",b.artrecep_cant as "Cant" from recepciones as a ;
	inner join recepciones_articulos as b on a.recep_codi=b.recep_codi,proveedores as c where c.prov_codi=a.prov_codi and ;
	b.art_codi=4027025
	
