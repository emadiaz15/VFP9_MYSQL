create cursor fac(fac_fec D,fac_codi N(8),fac_tipo C(1),fac_pto N(4),fac_nro N(8),imp_pag N(10,2),fac_conc C(1),total N(10,2))
create cursor siv(sini_fech D,sini_cod N(8),cli_sal N(10,2),sini_pag N(10,2))
create cursor facsiv(fac_codi N(8),sini_cod N(8),facsiv_fec D)


SELECT fac_fec,fac_codi,fac_tipo,fac_pto,fac_nro,imp_pag,fac_conc, ;
	fac_ng+neto_1+neto_2+fac_ivari+fac_ivarni as "total" FROM facturas WHERE pagado<>"S" ;
	AND anulado<>"S" AND cli_codi=355 order by fac_codi INTO CURSOR fac
index on fac_codi to fac_codi
	
SELECT sini_fech,sini_cod,cli_sal,sini_pag FROM saldosiniciales WHERE pagado<>"S" ;
	AND anulado<>"S" AND cli_codi=355 order by sini_cod INTO CURSOR siv
index on sini_cod to sini_cod

sele fac
go top
scan
	insert into facsiv(fac_codi,sini_cod,facsiv_fec) ;
				values(fac.fac_codi,0,fac.fac_fec)
endscan
sele siv
go top
scan
	insert into facsiv(fac_codi,sini_cod,facsiv_fec) ;
				values(0,siv.sini_cod,siv.sini_fech)
endscan

sele facsiv
index on facsiv_fec to facsiv_fec
set rela to fac_codi into fac addi
set rela to sini_cod into siv addi
go top

sele fac
brow nowait

sele siv
brow nowait

sele facsiv
brow nowait