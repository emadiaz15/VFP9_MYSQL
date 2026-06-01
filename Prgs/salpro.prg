set path to "H:\"
set exclusive off

select prov_codi,prov_nomb,prov_saldo,prov_afvor,round(prov_saldo-prov_afvor,2) as "impo" ;
	from proveedores where round(prov_saldo-prov_afvor,2)<>0 and !deleted() and prov_codi<>46 ;
	and prov_codi<>153 and prov_codi<>229 and prov_codi<>216 and prov_codi<>222 and prov_codi<>223 ;
	and prov_codi<>178 and prov_codi<>225 and prov_codi<>82 and prov_codi<>171 order by prov_nomb into cursor sal
	
sele sal
go top

report form saldosprov to printer prompt noconsole