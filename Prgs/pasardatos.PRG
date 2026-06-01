SET NULL ON

SET LIBRARY TO "c:\desarrollador\sistema prueba\prgs\librerias.prg"

PUBLIC string_cn

string_cn = Crear_Estruc_Conex_MySQL("USER_CONNECT")

PUBLIC cn

cn=SQLSTRINGCONNECT(string_cn)

SELECT * FROM facturas INTO CURSOR fac
GO top

SCAN
	IF DELETED()
		SKIP
		LOOP
	ENDIF
	cod=fac_codi
	nro=fac_nro
	pto=fac_pto
	tip=fac_tipo
	fec=fac_fec
	imp=imp_pag
	cli=cli_codi
	iva=iva_codi
	dto=fac_dto
	ped=ped_codi
	cnc=fac_conc
	pag=pagado
	nct=nc_texto
	anu=anulado
	fng=fac_ng
	ne1=neto_1
	ne2=neto_2
	iri=fac_ivari
	irni=fac_ivarni
	tot=fac_tot
	pie=ALLTRIM(fac_pie)
	com=com_codi
	ven=ven_codi
	por=porc_codi
	otcom=otra_comi
	nca=ALLTRIM(cae)
	fvc=IIF(EMPTY(fvtocae),('2008-02-01'),fvtocae)
	brr=ALLTRIM(barra)
	
*!*		IF EMPTY(fvc)
*!*			brow
*!*			SQLEXEC(cn,"insert into facturas values(?cod,?nro,?pto,?tip,?fec,?imp,?cli,?iva,?dto,?ped,?cnc,?pag,?nct,?anu,?fng,?ne1,?ne2,?iri,?irni,?tot,?pie,?com,?ven,?por,?otcom,?nca,?brr);")
*!*			cancel
*!*		else
		SQLEXEC(cn,"insert into facturas values(?cod,?nro,?pto,?tip,?fec,?imp,?cli,?iva,?dto,?ped,?cnc,?pag,?nct,?anu,?fng,?ne1,?ne2,?iri,?irni,?tot,?pie,?com,?ven,?por,?otcom,?nca,?fvc,?brr);")
*!*		ENDIF
ENDSCAN
=MESSAGEBOX("Proceso terminado",0+64,"Aviso de Sistema")


