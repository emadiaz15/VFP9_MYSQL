SET NULL ON

SET LIBRARY TO "c:\vfp9_mysql\prgs\librerias.prg"

PUBLIC string_cn

string_cn = Crear_Estruc_Conex_MySQL("USER_CONNECT")

PUBLIC cn

cn=SQLSTRINGCONNECT(string_cn)

SELECT * FROM "h:\transportes.dbf" WHERE !DELETED() INTO CURSOR tranmysql
GO top

SCAN
	cod=tran_codi
	nom=ALLTRIM(tran_nomb)
	dom=ALLTRIM(tran_domi)
	loc=loca_codi
	cart=tran_cartel
	tel1=tran_tel1
	tel2=tran_tel2
	cel=tran_cel
	cuit=tran_cuit
	mail=ALLTRIM(tran_email)
	cnd=cond_codi
	SQLEXEC(cn,"insert into transportes values(?cod,?nom,?dom,?loc,?cart,?tel1,?tel2,?cel,?cuit,?mail,?cnd,'');")
ENDSCAN
=MESSAGEBOX("Proceso terminado",0+64,"Aviso de Sistema")

cerrar_cursor("tranmysql")

SQLDISCONNECT(cn)
