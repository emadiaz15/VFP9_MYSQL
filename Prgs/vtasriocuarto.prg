* PARA SABER LOS CODIGOS DE PROVINCIA *
*select a.*,b.cp_nro,c.provi_nomb from localidades as a inner join codipostales as b on a.cp_codi=b.cp_codi, provincias as c where c.provi_codi=a.provi_codi ;
*	and INLIST(a.loca_nomb,"RIO CUARTO","RÍO CUARTO")
	
* PARA CALCULAR VENTAS

*!*	*!*	select round(sum(iif(a.fac_conc="N",-a.fac_tot,a.fac_tot)),2) from facturas as a inner join clientes as b on a.cli_codi=b.cli_codi, localidades as c where c.loca_codi=b.loca_codi and ;
*!*	*!*		between(a.fac_fec,ctod("01/06/2018"),ctod("30/06/2018")) and inlist(c.loca_codi,554,393,562,51,268,521,162,725,738) and a.anulado<>"S"

*select b.cli_nomb,iif(a.fac_conc="N",-a.fac_tot,a.fac_tot) from facturas as a inner join clientes as b on a.cli_codi=b.cli_codi, localidades as c where c.loca_codi=b.loca_codi and ;
*	between(a.fac_fec,ctod("01/08/2014"),ctod("31/08/2014")) and inlist(c.loca_codi,554,393,562,51,268,521,162)


*!*	select a.fac_fec,a.fac_conc,a.fac_tipo,a.fac_nro,iif(a.fac_conc="N",-a.fac_tot,a.fac_tot),b.cli_nomb from facturas as a inner join clientes as b on a.cli_codi=b.cli_codi, localidades as c where c.loca_codi=b.loca_codi and ;
*!*		between(a.fac_fec,ctod("01/11/2018"),ctod("30/11/2018")) and inlist(c.loca_codi,554,393,562,51,268,521,162,738) and a.anulado<>"S"

select round(sum(iif(a.fac_conc="N",-a.fac_tot,a.fac_tot)),2)from facturas as a inner join clientes as b on a.cli_codi=b.cli_codi, localidades as c where c.loca_codi=b.loca_codi and ;
	between(a.fac_fec,ctod("01/12/2018"),ctod("31/12/2018")) and inlist(c.loca_codi,554,393,562,51,268,521,162,738) and a.anulado<>"S"
	
