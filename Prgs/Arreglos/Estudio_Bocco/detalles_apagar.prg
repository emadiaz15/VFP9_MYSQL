create cursor fac(recep_fec D,recep_codi N(8),recep_tipo C(1),recep_pto N(4),prov_fac N(8),imp_pag N(15,2),recep_conc C(1),total N(15,2))
create cursor sic(sini_fech D,sini_cod N(8),prov_sal N(15,2),sini_pag N(15,2))
create cursor dic(debc_fech D,debc_codi N(8),debc_tot N(15,2),debc_impag N(15,2))
create cursor facsic(recep_codi N(8),sini_cod N(8),debc_codi N(8),facsic_fec D)

create cursor totalcbtes(conc C(3),punto N(4),numero N(8),impabona N(15,2),parcial L,recep_codi N(8))


DO c:\vfp9_mysql\prgs\conexion.prg

pagpro= conectar_db(_screen.cn)
	SQLEXEC(pagpro,"select * from proveedores order by prov_codi;","cur_prove")
desconectar_db(pagpro)

IF USED("cur_prove")
	SELECT cur_prove
	LOCATE
	SCAN
		xcodipro = cur_prove.prov_codi
		cuit=VAL(cur_prov.prov_cuit)
		cond=cur_prov.cond_codi
		pagpro= conectar_db(_screen.cn)
			SQLEXEC(pagpro,"call usp_pfacimp(?xcodipro);","fac")
			index on recep_codi to SYS(2015)
				
			SQLEXEC(pagpro,"SELECT sini_fech,sini_cod,prov_sal,sini_pag FROM saldosiniprov WHERE pagado<>'S' AND anulado<>'S' AND prov_codi=?xcodipro order by sini_cod;","sic")
			index on sini_cod to SYS(2015)

			SQLEXEC(pagpro,"SELECT debc_fech,debc_codi,debc_tot,debc_impag FROM debintc WHERE pagado<>'S' AND prov_codi=?xcodipro order by debc_codi;","dic")
			index on debc_codi to SYS(2015)		
		desconectar_db(pagpro)
		
		sele fac
		go top
		scan
			insert into facsic(recep_codi,sini_cod,debc_codi,facsic_fec) ;
						values(fac.recep_codi,0,0,fac.recep_fec)
		endscan
		sele sic
		go top
		scan
			insert into facsic(recep_codi,sini_cod,debc_codi,facsic_fec) ;
						values(0,sic.sini_cod,0,sic.sini_fech)
		endscan
		sele dic
		go top
		scan
			insert into facsic(recep_codi,sini_cod,debc_codi,facsic_fec) ;
						values(0,0,dic.debc_codi,dic.debc_fech)
		endscan
		sele facsic
		index on facsic_fec to SYS(2015)
		set rela to recep_codi into fac addi
		set rela to sini_cod into sic addi
		set rela to debc_codi into dic addi

		sele fac
		go top
		sele sic
		go top
		sele dic
		go top
		sele facsic
		go top
		i=1
		scan
			.list1.list(i,1)=dtoc(facsic_fec)
			if recep_codi>0
				do case
					case fac.recep_conc="F"
						do case
							case fac.prov_tipfac="A"
								.list1.list(i,2)="FA"
							case fac.prov_tipfac="B"
								.list1.list(i,2)="FB"
							case fac.prov_tipfac="C"
								.list1.list(i,2)="FC"
						endcase
					case fac.recep_conc="N"
						do case
							case fac.prov_tipfac="A"
								.list1.list(i,2)="NCA"
							case fac.prov_tipfac="B"
								.list1.list(i,2)="NCB"
							case fac.prov_tipfac="C"
								.list1.list(i,2)="NCC"
						endcase
					case fac.recep_conc="D"
						do case
							case fac.prov_tipfac="A"
								.list1.list(i,2)="NDA"
							case fac.prov_tipfac="B"
								.list1.list(i,2)="NDB"
							case fac.prov_tipfac="C"
								.list1.list(i,2)="NDC"
						endcase
				endcase
			else
				IF sini_cod>0
					.list1.list(i,2)="SIC"
				ELSE
					.list1.list(i,2)="DIC"
				ENDIF
			endif
			.list1.list(i,3)=iif(recep_codi>0,allt(str(fac.prov_pto)),"0")
			.list1.list(i,4)=iif(recep_codi>0,str(fac.prov_fac),IIF(sini_cod>0,str(sic.sini_cod),STR(dic.debc_codi)))
			.list1.list(i,5)=iif(recep_codi>0,str(fac.total,10,2),IIF(sini_cod>0,str(sic.prov_sal,10,2),STR(dic.debc_tot,10,2)))
			.list1.list(i,6)=iif(recep_codi>0,str(fac.imp_pag,10,2),IIF(sini_cod>0,str(sic.sini_pag,10,2),STR(dic.debc_impag,10,2)))
			.list1.list(i,7)=iif(recep_codi>0,str(fac.total-fac.imp_pag,10,2),IIF(sini_cod>0,str(sic.prov_sal-sic.sini_pag,10,2),STR(dic.debc_tot-dic.debc_impag,10,2)))
			if fac.recep_conc="N"
				.list1.list(i,5)="  -"+allt(.list1.list(i,5))
				.list1.list(i,6)="  -"+allt(.list1.list(i,6))
				.list1.list(i,7)="  -"+allt(.list1.list(i,7))
			endif
			if i=1
				.list1.list(i,8)=str(ConverNro(.list1.list(i,8))+ConverNro(.list1.list(i,7)),10,2)
			else
				.list1.list(i,8)=str(ConverNro(.list1.list(i-1,8))+ConverNro(.list1.list(i,7)),10,2)
			endif
			.list1.list(i,9)=IIF(recep_codi>0,STR(recep_codi),STR(debc_codi))
			i=i+1
		ENDSCAN
		SELECT cur_prove
	ENDSCAN
ELSE
	MESSAGEBOX("No se econtraron registros de Proveedores",48,"Aviso del Sistema")
ENDIF
