SET NULL ON

SET LIBRARY TO "c:\vfp9_mysql\prgs\librerias.prg"

PUBLIC string_cn

string_cn = Crear_Estruc_Conex_MySQL("USER_CONNECT")

PUBLIC cn

cn=SQLSTRINGCONNECT(string_cn)

SELECT * FROM "h:\proveedores.dbf" WHERE !DELETED() INTO CURSOR promysql
GO top

SCAN
	cod=prov_codi
	nom=ALLTRIM(prov_nomb)
	dom=ALLTRIM(prov_domi)
	loc=loca_codi
	cart=prov_cartel
	tel1=prov_tel1
	tel2=prov_tel2
	cel=ALLTRIM(prov_cel)
	cuit=prov_cuit
	mail=ALLTRIM(prov_email)
	cnd=cond_codi
	per=percepcion
	dto=dtoxpago
	sal=prov_saldo
	fav=prov_afvor
	ultl=prov_ultiletra
	ultp=prov_ultipto
	SQLEXEC(cn,"insert into proveedores values(?cod,?nom,?dom,?loc,?cart,?tel1,?tel2,?cel,?cuit,?mail,?cnd,?per,?dto,?sal,?fav,?ultl,?ultp);")
ENDSCAN
=MESSAGEBOX("Proceso terminado",0+64,"Aviso de Sistema")

cerrar_cursor("promysql")

SQLDISCONNECT(cn)
