PUBLIC scn1, scn2, conec1, conec2

scn1="Driver={MySQL ODBC 5.1 Driver};Server=localhost;Port=3306;Database=db_recep;Uid=admin;Pwd=Flatw194;"
scn2="Driver={MySQL ODBC 5.1 Driver};Server=192.168.0.222;Port=3306;Database=db_dhoelec;Uid=admin;Pwd=Admin121074;"

conec1 = SQLSTRINGCONNECT(scn1)
	SQLEXEC(conec1,"set @con1 = 0;")
	SQLEXEC(conec1,"select cast((@con1 := @con1 + 1) as decimal(7)) rear_codi,a.* from recepciones_articulos a;","cur_recepok")
SQLDISCONNECT(conec1)

conec2 = SQLSTRINGCONNECT(scn2)
	SQLEXEC(conec2,"set @con2 = 0;")
	SQLEXEC(conec2,"select cast((@con2 := @con2 + 1) as decimal(7)) rear_codi,a.* from recepciones_articulos a;","cur_recepmal")
SQLDISCONNECT(conec2)

SELECT cur_recepmal
LOCATE
SELECT * FROM cur_recepmal INTO CURSOR traspaso READWRITE

SELECT traspaso
INDEX on rear_codi TO rermal addi

SELECT cur_recepok
INDEX on rear_codi TO rerok addi
SET RELATION TO rear_codi INTO traspaso addi

LOCATE
SET FILTER TO SUBSTR(ALLTRIM(artrecep_dasc),ATC('5/8', artrecep_dasc),3) = '5/8'

SELECT traspaso
LOCATE
SET FILTER TO SUBSTR(ALLTRIM(artrecep_dasc),ATC('5/8', artrecep_dasc),3) = '5/8'

SELECT cur_recepok
LOCATE
SCAN
	xcan= cur_recepok.artrecep_cant
	SELECT traspaso
	REPLACE artrecep_cant WITH xcan
	SELECT cur_recepok
ENDSCAN

SET RELATION TO

conec2 = SQLSTRINGCONNECT(scn2)
	SQLEXEC(conec2,"delete from recepciones_articulos;")
SQLDISCONNECT(conec2)

SELECT traspaso
SET FILTER TO
LOCATE
LOCAL xrecep, xart, xcanr, xprec, xdasc, xconc, xstock, xdap, xciva, xord
SCAN
	xrecep = traspaso.recep_codi
	xart   = traspaso.art_codi
	xcanr  = traspaso.artrecep_cant
	xprec  = traspaso.artrecep_prec
	xdasc  = traspaso.artrecep_dasc
	xconc  = traspaso.concepto
	xstock = traspaso.recep_sstock
	xdap   = traspaso.dap_codi
	xciva  = traspaso.calciva
	xord   = traspaso.orden_codi
	conec2 = SQLSTRINGCONNECT(scn2)
		SQLEXEC(conec2,"insert into recepciones_articulos values(?xrecep,?xart,?xcanr,?xprec,?xdasc,?xconc,?xstock,?xdap,?xciva,?xord);")
	SQLDISCONNECT(conec2)
	SELECT traspaso
ENDSCAN

MESSAGEBOX("Proceso finalizado correctamente",0+64,"Aviso del Sistema")




