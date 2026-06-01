select a.movtippag_nro,a.movtippag_fvto,a.movtippag_fvto+30 as "fcobro",d.ban_desc, ;
	a.movtippag_imp,c.cli_nomb,c.cli_cuit,a.movtippag_pza from recibos_pagos as a ;
	inner join recibos as b on a.rec_codi=b.rec_codi,clientes as c,bancos as d where ;
	c.cli_codi=b.cli_codi and d.ban_codi=a.ban_codi and a.tippag_codi=3 and ;
	a.movtippag_fvto+30>=date() and a.pag_codi=0 and a.gas_codi=0 order by a.movtippag_fvto into cursor cheques
go top
dimension meses(1,3)
x=0
scan
	if x=0
		meses(1,1)=month(fcobro)
		meses(1,2)=year(fcobro)
		meses(1,3)=movtippag_imp
	endif
	if val(allt(str(meses(alen(meses,1),1)))+allt(str(meses(alen(meses,1),2))))<>val(allt(str(month(fcobro)))+allt(str(year(fcobro)))) and x>=1
		dimension meses(alen(meses,1)+1,3)
		meses(alen(meses,1),1)=month(fcobro)
		meses(alen(meses,1),2)=year(fcobro)
		meses(alen(meses,1),3)=movtippag_imp
	endif
	x=x+1
endscan
fila=5
for x=1 to alen(meses,1)
	@ fila,10 say allt(str(meses(x,1)))
	@ fila,15 say allt(str(meses(x,2)))
	@ fila,25 say allt(str(meses(x,3),10,2))
	fila=fila+1
next