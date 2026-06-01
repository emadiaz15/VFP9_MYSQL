SET TALK OFF
SET DATE BRITISH
SET CENTURY ON
local saldo,detallar,xopcion,xcodicli,xfecdes,xfechas,xconex, ;
	  vta,ncred,pag,auxdebe,auxhaber,regdebe,reghaber,saldotot

saldotot = 0

xconex = "Driver={MySql ODBC 5.1 Driver};Server=192.168.0.222;Port=3306;Database=db_dhoelec;Uid=admin;Pwd=Admin121074;"

xfecdes=CTOD('01/12/2023')
xfechas=CTOD('31/12/2023')
frmctacli= SQLSTRINGCONNECT(xconex)
	SQLEXEC(frmctacli,"select * from clientes order by cli_codi;","cur_clie")
*!*		SQLEXEC(frmctacli,"select * from clientes where zona_codi = 9 and cli_favor > 0 order by cli_nomb;","cur_clie")
SQLDISCONNECT(frmctacli)
SELECT cur_clie
GO top
cadena='Saldos_Clientes_12-2023'+'.txt'
archi=putfile('Guardar como',cadena,'txt')
gnvcFile = FCREATE(archi)
SCAN
STORE 0 TO saldo,vta,ncred,pag,auxdebe,auxhaber,auxdebe,auxhaber,regdebe,reghaber
detallar=1

xcodicli=cur_clie.cli_codi

frmctacli= SQLSTRINGCONNECT(xconex)
	xopcion=1
	SQLEXEC(frmctacli,"call usp_ctacli(?xopcion,?xcodicli,?xfecdes,?xfechas);","siv")
	sum sini_imp to si
	xopcion=2
	SQLEXEC(frmctacli,"call usp_ctacli(?xopcion,?xcodicli,?xfecdes,?xfechas);","ventas")
	sum ven_imp to vta
	xopcion=3
	SQLEXEC(frmctacli,"call usp_ctacli(?xopcion,?xcodicli,?xfecdes,?xfechas);","notascred")
	sum cre_imp to ncred
	xopcion=4
	SQLEXEC(frmctacli,"call usp_ctacli(?xopcion,?xcodicli,?xfecdes,?xfechas);","pagos")
	sum pag_imp to pag
	xopcion=5
	SQLEXEC(frmctacli,"call usp_ctacli(?xopcion,?xcodicli,?xfecdes,?xfechas);","regul")
	SUM regul.reg_imp FOR regul.reg_conc="D" to regdebe
	SUM regul.reg_imp FOR regul.reg_conc="H" to reghaber
	xopcion=12
	SQLEXEC(frmctacli,"call usp_ctacli(?xopcion,?xcodicli,?xfecdes,?xfechas);","debint")
	sum debin_imp to di
	saldo=round(si+vta+di-ncred-pag+regdebe-reghaber,2) 
	
	xopcion=6
	SQLEXEC(frmctacli,"call usp_ctacli(?xopcion,?xcodicli,?xfecdes,?xfechas);","verifsiv")
	xopcion=7
	SQLEXEC(frmctacli,"call usp_ctacli(?xopcion,?xcodicli,?xfecdes,?xfechas);","veriffac")
	xopcion=8
	SQLEXEC(frmctacli,"call usp_ctacli(?xopcion,?xcodicli,?xfecdes,?xfechas);","verifcre")
	xopcion=9
	SQLEXEC(frmctacli,"call usp_ctacli(?xopcion,?xcodicli,?xfecdes,?xfechas);","verifdeb")
 	xopcion=10
	SQLEXEC(frmctacli,"call usp_ctacli(?xopcion,?xcodicli,?xfecdes,?xfechas);","verifrec")
	xopcion=11
	SQLEXEC(frmctacli,"call usp_ctacli(?xopcion,?xcodicli,?xfecdes,?xfechas);","verifregul")
	xopcion=13
	SQLEXEC(frmctacli,"call usp_ctacli(?xopcion,?xcodicli,?xfecdes,?xfechas);","verifdebint")
SQLDISCONNECT(frmctacli)

select * from veriffac union (select * from verifsiv) union ;
	(select * from verifcre) union ;
	(select * from verifdeb) union ;
	(select * from verifrec) union ;
	(select * from verifregul) union ;
	(select * from verifdebint) into cursor detacta
sele detacta
index on dtos(mov_fech)+str(fac_codi) to SYS(2015)
if detallar=1

	vta=0
	sele detacta
	go top
	SCAN
		SELECT detacta
		do case
			case tipmov_codi=1
				saldo=saldo+mov_impo
				vta=vta+mov_impo
			case tipmov_codi=7
				saldo=saldo-mov_impo
				ncred=ncred+mov_impo
			case tipmov_codi=8
				saldo=saldo+mov_impo
				vta=vta+mov_impo
			case tipmov_codi=2
				saldo=saldo-mov_impo
				pag=pag+mov_impo
			case tipmov_codi=11
				if cur_regmov.reg_conc="D"
					saldo=saldo+mov_impo
					vta=vta+mov_impo
				else
					saldo=saldo-mov_impo
					ncred=ncred+mov_impo
				endif			
			case tipmov_codi=12
				if mov_impo>0
					vta=vta+mov_impo
				else
					ncred=ncred+mov_impo
				endif			
				saldo=saldo+mov_impo
			case tipmov_codi=14
				saldo=saldo+mov_impo
				vta=vta+mov_impo
		ENDCASE
	ENDSCAN
	SELECT cur_clie
ENDIF
IF !EOF()
	saldotot = saldotot + saldo
	WAIT WINDOW ALLTRIM(cur_clie.cli_nomb)+' '+ALLTRIM(STR(saldo,15,2))+'  '+ALLTRIM(STR(saldotot,15,2)) nowait
ENDIF

=FPUTS(gnvcFile , "Cliente: "+PADR(ALLTRIM(STR(cur_clie.cli_codi)),6," ")+" - "+PADR(ALLTRIM(cur_clie.cli_nomb),60," ")+"   "+"Saldo: "+ALLTRIM(STR(saldo,15,2)))
*!*	MESSAGEBOX("El Saldo de este Cliente "+ALLTRIM(cur_clie.cli_nomb)+" es: $ "+ALLTRIM(STR(saldo,15,2)),64,"Aviso del Sistema")
*!*	frmctacli= SQLSTRINGCONNECT(xconex)
*!*		SQLEXEC(frmctacli,"update clientes set cli_saldo = ?saldo where cli_codi = ?xcodicli;")
*!*	SQLDISCONNECT(frmctacli)

ENDSCAN
=FPUTS(gnvcFile , "SALDO TOTAL DE CLIENTES AL 31/12/2023: "+ALLTRIM(STR(saldotot,15,2)))
=FCLOSE(gnvcFile )

MESSAGEBOX("Proceso finalizado correctamente....",64,"Aviso del Sistema")

*!*	MESSAGEBOX("El Saldo de este Cliente es: $ "+ALLTRIM(STR(saldo,15,2)),64,"Aviso del Sistema")
