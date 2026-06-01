set talk off
codicli=39
dimension credi[1,1]
credi[1,1]=0
select sum(round(b.artfac_cant*b.artfac_impo,2))+a.ivanc as "cred" from facturas as a ;
	inner join facturas_articulos as b on a.fac_codi=b.fac_codi where a.cli_codi=codicli and ;
	a.fac_conc="N" and a.pagado<>"S" and a.anulado<>"S" group by b.fac_codi into cursor creditos
sum creditos.cred to array credi
display memo like credi