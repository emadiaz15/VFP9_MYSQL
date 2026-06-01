SET TALK OFF
SET DATE BRITISH
SET CENTURY ON

local saldo,detallar,xopcion,xcodiprov,xfecdes,xfechas,xconex, ;
	  vta,ncred,pag,auxdebe,auxhaber,regdebe,reghaber,saldotot

CREATE CURSOR movimientos(mprov_codi N(8), mprov_nomb C(60), mprov_saldo N(15,2))

saldotot = 0

xconex = "Driver={MySql ODBC 5.1 Driver};Server=192.168.0.222;Port=3306;Database=db_dhoelec;Uid=admin;Pwd=Admin121074;"

xfecdes=CTOD('01/01/2023')
xfechas=CTOD('31/12/2023')
** CTOD('31/12/2023')
frmctapro= SQLSTRINGCONNECT(xconex)
	SQLEXEC(frmctapro,"select * from proveedores order by prov_codi;","cur_prov")
*!*		SQLEXEC(frmctapro,"select * from clientes where zona_codi = 9 and cli_favor > 0 order by cli_nomb;","cur_prov")
SQLDISCONNECT(frmctapro)
SELECT cur_prov
GO top
*!*	cadena='Saldos_Proveedores_12-2023'+'.xls'
*!*	archi=putfile('Guardar como',cadena,'xls')
*!*	gnvcFile = FCREATE(archi)
SCAN
	STORE 0 TO saldo,vta,ncred,pag,auxdebe,auxhaber,auxdebe,auxhaber,regdebe,reghaber
	detallar=1

	xcodiprov=cur_prov.prov_codi

	frmctapro= SQLSTRINGCONNECT(xconex)
		xopcion=1
		SQLEXEC(frmctapro,"call usp_ctaprov(?xopcion,?xcodiprov,?xfecdes,?xfechas);","sic")
		sum sini_imp to si
		xopcion=2
		SQLEXEC(frmctapro,"call usp_ctaprov(?xopcion,?xcodiprov,?xfecdes,?xfechas);","compras")
		sum com_imp to com
		xopcion=3
		SQLEXEC(frmctapro,"call usp_ctaprov(?xopcion,?xcodiprov,?xfecdes,?xfechas);","notascred")		
		sum cre_imp to ncred
		xopcion=4
		SQLEXEC(frmctapro,"call usp_ctaprov(?xopcion,?xcodiprov,?xfecdes,?xfechas);","pagos")
		sum pag_imp to pag
		xopcion=5
		SQLEXEC(frmctapro,"call usp_ctaprov(?xopcion,?xcodiprov,?xfecdes,?xfechas);","regul")
		sum regul.reg_imp for regul.regp_conc="D" to regdebe
		sum regul.reg_imp for regul.regp_conc="H" to reghaber
		xopcion=12
		SQLEXEC(frmctapro,"call usp_ctaprov(?xopcion,?xcodiprov,?xfecdes,?xfechas);","debint")
		sum debin_imp to di
			 
		saldo=round(si+com+di-ncred-pag+regdebe-reghaber,2)

		xopcion=6
		SQLEXEC(frmctapro,"call usp_ctaprov(?xopcion,?xcodiprov,?xfecdes,?xfechas);","verifsic")
		xopcion=7
		SQLEXEC(frmctapro,"call usp_ctaprov(?xopcion,?xcodiprov,?xfecdes,?xfechas);","veriffac")
		xopcion=8
		SQLEXEC(frmctapro,"call usp_ctaprov(?xopcion,?xcodiprov,?xfecdes,?xfechas);","verifcre")
		xopcion=9
		SQLEXEC(frmctapro,"call usp_ctaprov(?xopcion,?xcodiprov,?xfecdes,?xfechas);","verifdeb")
	 		xopcion=10
		SQLEXEC(frmctapro,"call usp_ctaprov(?xopcion,?xcodiprov,?xfecdes,?xfechas);","verifrec")
		xopcion=11
		SQLEXEC(frmctapro,"call usp_ctaprov(?xopcion,?xcodiprov,?xfecdes,?xfechas);","verifregul")
		xopcion=13
		SQLEXEC(frmctapro,"call usp_ctaprov(?xopcion,?xcodiprov,?xfecdes,?xfechas);","verifdebint")
	SQLDISCONNECT(frmctapro)

	select * from veriffac union (select * from verifsic) union ;
		(select * from verifcre) union ;
		(select * from verifdeb) union ;
		(select * from verifrec) union ;
		(select * from verifregul) union ;
		(select * from verifdebint) into cursor detacta
	sele detacta
	index on dtos(mov_fech)+str(recep_codi) to SYS(2015)
	if detallar=1
		vta=0
		sele detacta
		go top
		SCAN
			frmctapro= SQLSTRINGCONNECT(xconex)
				do case
					case tipmov_codi=1 or tipmov_codi=7 or tipmov_codi=8
						SQLEXEC(frmctapro,"select * from recepciones where recep_codi=?detacta.recep_codi;","cur_famov")
					case tipmov_codi=11
						SQLEXEC(frmctapro,"select * from regulaprov where regp_codi=?detacta.regp_codi;","cur_regmov")
					case tipmov_codi=13
					case tipmov_codi=14
						SQLEXEC(frmctapro,"select * from debintc where debc_codi=?detacta.debc_codi;","cur_dimov")
				ENDCASE
				SQLEXEC(frmctapro,"select tipmov_desc from tiposmovimientos where tipmov_codi=?detacta.tipmov_codi;","cur_tipm")
			SQLDISCONNECT(frmctapro)		
			SELECT detacta
			do case
				case tipmov_codi=1
					saldo=saldo+mov_impo
					com=com+mov_impo
				case tipmov_codi=7
					saldo=saldo-mov_impo
					ncred=ncred+mov_impo
				case tipmov_codi=8
					saldo=saldo+mov_impo
					com=com+mov_impo
				case tipmov_codi=3
					saldo=saldo-mov_impo
					pag=pag+mov_impo
				case tipmov_codi=11
					if cur_regmov.regp_conc="D"
						saldo=saldo+mov_impo
						com=com+mov_impo
					else
						saldo=saldo-mov_impo
						ncred=ncred+mov_impo
					endif			
				case tipmov_codi=13
					if mov_impo>0
						com=com+mov_impo
					else
						ncred=ncred+ABS(mov_impo)
					endif			
					saldo=saldo+mov_impo
				case tipmov_codi=14
					saldo=saldo+mov_impo
					com=com+mov_impo
			ENDCASE
		ENDSCAN
		SELECT cur_prov
	ENDIF
	IF !EOF()
		saldotot = saldotot + saldo
		WAIT WINDOW ALLTRIM(cur_prov.prov_nomb)+' '+ALLTRIM(STR(saldo,15,2))+'  '+ALLTRIM(STR(saldotot,15,2)) nowait
	ENDIF
	INSERT INTO movimientos values(cur_prov.prov_codi, cur_prov.prov_nomb, saldo)
*!*		=FPUTS(gnvcFile , "Proveedor: "+PADR(ALLTRIM(STR(cur_prov.prov_codi)),6," ")+" - "+PADR(ALLTRIM(cur_prov.prov_nomb),60," ")+"   "+"Saldo: "+ALLTRIM(STR(saldo,15,2)))

ENDSCAN
*!*	=FPUTS(gnvcFile , "SALDO TOTAL DE PROVEEDORES AL 31/12/2023: "+ALLTRIM(STR(saldotot,15,2)))
*!*	=FCLOSE(gnvcFile )

SELECT movimientos

COPY TO "C:\Users\Administrador\Desktop\TOTPAGAR\saldosprov_02.xls" TYPE xls

MESSAGEBOX("Proceso finalizado correctamente....",64,"Aviso del Sistema")

*!*	MESSAGEBOX("El Saldo de este Cliente es: $ "+ALLTRIM(STR(saldo,15,2)),64,"Aviso del Sistema")
