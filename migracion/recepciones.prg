SET NULL ON

SET LIBRARY TO "c:\vfp9_mysql\prgs\librerias.prg"

PUBLIC string_cn

string_cn = Crear_Estruc_Conex_MySQL("USER_CONNECT")

PUBLIC cn

cn=SQLSTRINGCONNECT(string_cn)

SELECT * FROM "h:\recepciones.dbf" WHERE !DELETED() INTO CURSOR fac
GO top

SCAN
	cod=recep_codi
	fec=recep_fec
	pro=prov_codi
	obs=ALLTRIM(recep_obser)
	dto=recep_dto
	tip=prov_tipfac
	pto=prov_pto
	nro=prov_fac
	rto=prov_rto
	iva=iva_codi
	piva=perc_iva
	pbto=perc_btos
	impp=imp_pag
	pag=pagado
	cnc=recep_conc
	dol=cotiz_dolar
	fng=recep_impng
	iri=recep_ivari
	irni=recep_ivarni
	ne1=neto_1
	ne2=neto_2
	tot=recep_tot
	dtop=recep_dtopag
	cta=IIF(cc=.T.,1,0)
	anu=anulado
	SQLEXEC(cn,"insert into recepciones values(?cod,?fec,?pro,?obs,?dto,?tip,?pto,?nro,?rto,?iva,?piva,?pbto,?impp,?pag,?cnc,?dol,?fng,?iri,?irni,?ne1,?ne2,?tot,?dtop,?cta,?anu);")
ENDSCAN
=MESSAGEBOX("Proceso terminado",0+64,"Aviso de Sistema")

cerrar_cursor("fac")

SQLDISCONNECT(cn)

