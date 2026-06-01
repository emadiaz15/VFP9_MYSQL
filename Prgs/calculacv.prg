		valor=0
		with thisform
			select sum(a.artfac_cant) as "cant" from facturas_articulos as a ;
				 inner join facturas as b on a.fac_codi=b.fac_codi where ;
				 a.art_codi=.text1.value and between(b.fac_fec,.text9.value,.text10.value) ;
				 and b.anulado<>"S" and b.fac_conc="F" into cursor cantvent
			select sum(a.artfac_cant) as "ccred" from facturas_articulos as a ;
				 inner join facturas as b on a.fac_codi=b.fac_codi where ;
				 a.art_codi=.text1.value and between(b.fac_fec,.text9.value,.text10.value) ;
				 and b.anulado<>"S" and b.fac_conc="N" into cursor cantcred
			select sum(a.artfac_cant*a.artfac_impo) as "vtas" from facturas_articulos as a ;
				 inner join facturas as b on a.fac_codi=b.fac_codi where ;
				 a.art_codi=.text1.value and between(b.fac_fec,.text9.value,.text10.value) ;
				 and b.anulado<>"S" and b.fac_conc="F" into cursor ventas
			select sum(a.artfac_cant*a.artfac_impo) as "cred" from facturas_articulos as a ;
				 inner join facturas as b on a.fac_codi=b.fac_codi where ;
				 a.art_codi=.text1.value and between(b.fac_fec,.text9.value,.text10.value) ;
				 and b.anulado<>"S" and b.fac_conc="N" into cursor creditos
			select b.artrecep_cant as "can",b.artrecep_cant*b.artrecep_prec as "cto",a.recep_conc as "concepto" ;
				 from recepciones as a inner join recepciones_articulos as b on ;
				 a.recep_codi=b.recep_codi where b.art_codi=.text1.value and ;
				 between(a.recep_fec,.text9.value,.text10.value) into cursor recep
			.text11.value=cantvent.cant-cantcred.ccred
			if cantvent.cant>0
				promvta=(ventas.vtas-creditos.cred)/(cantvent.cant-cantcred.ccred)
			else
				promvta=0
			endif
		
			sele recep
			go top
			if reccount()>0
				acucant=0
				acuprec=0
				do while acucant<=.text11.value and !eof()
					if concepto="N"
						acucant=acucant-can
						acuprec=acuprec-cto
					else
						acucant=acucant+can
						acuprec=acuprec+cto
					endif
					skip
				enddo
				if acucant>.text11.value
					acucant=cantvent.cant
				endif
				promcpra=acuprec/acucant
				.text12.value=((promvta/promcpra)-1)*100
			else
				.text12.value=0
			endif
		endwith
