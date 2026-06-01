SET NULL ON

SET LIBRARY TO "c:\vfp9_mysql\prgs\librerias.prg"

PUBLIC string_cn

string_cn = Crear_Estruc_Conex_MySQL("USER_CONNECT")

PUBLIC cn

cn=SQLSTRINGCONNECT(string_cn)

SELECT * FROM "h:\facturas.dbf" WHERE !DELETED() INTO CURSOR fac
GO top

SCAN
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
	ng=fac_ng
	ne1=neto_1
	ne2=neto_2
	ivri=fac_ivari
	ivrni=fac_ivarni
	tot=fac_tot
	pie=fac_pie
	com=com_codi
	ven=ven_codi
	porc=porc_codi
	otc=otra_comi
	ncae=cae
	fvt=IIF(LEN(ALLTRIM(DTOS(fvtocae)))=0,.NULL.,fvtocae)
	barr=barra
	SQLEXEC(cn,"insert into facturas values(?cod,?nro,?pto,?tip,?fec,?imp,?cli,?iva,?dto,?ped,?cnc,?pag,?nct,?anu,?ng,?ne1,?ne2,?ivri,?ivrni,?tot,?pie,?com,?ven,?porc,?otc,?ncae,?fvt,?barr);")
ENDSCAN
=MESSAGEBOX("Proceso terminado",0+64,"Aviso de Sistema")

cerrar_cursor("fac")

SQLDISCONNECT(cn)