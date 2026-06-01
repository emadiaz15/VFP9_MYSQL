SET NULL ON

SET LIBRARY TO "c:\vfp9_mysql\prgs\librerias.prg"

PUBLIC string_cn

string_cn = Crear_Estruc_Conex_MySQL("USER_CONNECT")

PUBLIC cn

cn=SQLSTRINGCONNECT(string_cn)

SELECT * FROM "h:\personas.dbf" WHERE !DELETED() INTO CURSOR pers
GO top

SCAN
	codp=per_codi
	nom=per_desc
	dom=per_domi
	loc=loca_codi
	car=per_cartel
	tel1=per_tel1
	tel2=per_tel2
	cel=per_cel
	cuit=per_cuit
	email=per_email
	cond=cond_codi
	per=percepcion
	dto=dtoxpago
	sal=prov_saldo
	fav=prov_afvor
	ex=IIF(excento=.t.,1,0)
	SQLEXEC(cn,"insert into personas values(?codp,?nom,?dom,?loc,?car,?tel1,?tel2,?cel,?cuit,?email,?cond,?per,?dto,?sal,?fav,?ex,'',0);")
ENDSCAN
=MESSAGEBOX("Proceso terminado",0+64,"Aviso de Sistema")

cerrar_cursor("pers")

SQLDISCONNECT(cn)