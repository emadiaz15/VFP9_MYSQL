*set path to "E:\"
set date british
set cent on
set exclusive off
set dele on
create cursor auxcheq(fecha D,nro C(10),banco C(25),plaza C(25),impo N(10,2))
select gomonth(a.movtippag_fvto,1) as "fecha",a.movtippag_nro as "nro",b.ban_desc as "banco", ;
	a.movtippag_pza as "plaza",a.movtippag_imp as "impo",d.cli_nomb from recibos_pagos as a ;
	inner join bancos as b on a.ban_codi=b.ban_codi,recibos as c,clientes as d where ;
	c.rec_codi=a.rec_codi and c.cli_codi=d.cli_codi and a.tippag_codi=3 ;
	and gomonth(a.movtippag_fvto,1)>=date() and gomonth(a.movtippag_fvto,1)<=date()+3;
	order by a.movtippag_fvto into cursor auxcheq
sele auxcheq
if reccount()>0
	preg=messagebox("ATENCIÓN!!!"+chr(13)+chr(13)+ ;
			   "Hay cheques próximos a vencer."+chr(13)+;
			   "¿Desea ver el detalle completo?",4+48+256,"Hp Electricidad")
	if preg=6
		do form vencheq
		read events
	endif
endif