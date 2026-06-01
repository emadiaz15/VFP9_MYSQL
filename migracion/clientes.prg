SET NULL ON

SET LIBRARY TO "c:\vfp9_mysql\prgs\librerias.prg"

PUBLIC string_cn

string_cn = Crear_Estruc_Conex_MySQL("USER_CONNECT")

PUBLIC cn

cn=SQLSTRINGCONNECT(string_cn)

SELECT * FROM "h:\clientes.dbf" WHERE !DELETED() INTO CURSOR climysql
GO top

SCAN
	cod=cli_codi
	nom=ALLTRIM(cli_nomb)
	dom=ALLTRIM(cli_domi)
	cuit=cli_cuit
	cart=cli_cartel
	tel1=cli_tel1
	tel2=cli_tel2
	cel=ALLTRIM(cli_cel)
	mail=ALLTRIM(cli_email)
	loc=loca_codi
	cnd=cond_codi
	sal=cli_saldo
	zon=zona_codi
	fav=cli_favor
	SQLEXEC(cn,"insert into clientes values(?cod,?nom,?dom,?cuit,?cart,?tel1,?tel2,?cel,?mail,?loc,?cnd,?sal,?zon,?fav);")
ENDSCAN
=MESSAGEBOX("Proceso terminado",0+64,"Aviso de Sistema")

cerrar_cursor("climysql")

SQLDISCONNECT(cn)
