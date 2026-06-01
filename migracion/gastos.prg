SET NULL ON

SET LIBRARY TO "c:\vfp9_mysql\prgs\librerias.prg"

PUBLIC string_cn

string_cn = Crear_Estruc_Conex_MySQL("USER_CONNECT")

PUBLIC cn

cn=SQLSTRINGCONNECT(string_cn)

SELECT * FROM "h:\gastos.dbf" WHERE !DELETED() INTO CURSOR fac
GO top

SCAN
	cod=gas_codi
	fec=gas_fech
	per=per_codi
	tipg=tipgas_codi
	obs=ALLTRIM(gas_obser)
	dto=gas_dto
	pto=gas_pto
	nro=gas_cbte
	tip=gas_tipcbte
	rto=gas_rto
	ivac=iva_codi
	piva=gas_piva
	pbto=gas_btos
	impp=imp_pag
	pag=pagado
	cnc=gas_conc
	dol=cotiz_dolar
	tot=gas_impo
	ing=gas_impng
	alt1=altiva_1
	alt2=altiva_2
	ivnd=ivand
	ivnc=ivanc
	dxp=gas_dtopag
	cta=IIF(cc=.T.,1,0)
	iva=gas_iva
	nc=IIF(gas_nc=.T.,1,0)
	SQLEXEC(cn,"insert into gastos values(?cod,?fec,?per,?tipg,?obs,?dto,?pto,?nro,?tip,?rto,?ivac,?piva,?pbto,?impp,?pag,?cnc,?dol,?tot,0,0,?ing,?alt1,?alt2,?ivnd,?ivnc,?dxp,?cta,?iva,0,0,?nc);")
ENDSCAN
=MESSAGEBOX("Proceso terminado",0+64,"Aviso de Sistema")

cerrar_cursor("fac")

SQLDISCONNECT(cn)