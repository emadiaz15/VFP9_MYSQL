PUBLIC cn1, cn2

cn1 = SQLSTRINGCONNECT("Driver={MySql ODBC 5.1 Driver};Server=localhost;Port=3306;Database=db_pruebas;Uid=admin;Pwd=Flatw194;")
cn2 = SQLSTRINGCONNECT("Driver={MySql ODBC 5.1 Driver};Server=192.168.0.222;Port=3306;Database=db_dhoelec;Uid=admin;Pwd=Admin121074;")

SQLEXEC(cn1,"select * from facturas where cotiz_dolar > 0 order by fac_codi;","cur_fac1")

SELECT cur_fac1

LOCATE
LOCAL xfac, xdolar

SCAN
	xfac = cur_fac1.fac_codi
	xdolar = cur_fac1.cotiz_dolar
*	SQLEXEC(cn2,"select concat('Codiped2: ',TRIM(CAST(ped_codi as char)),' ','Fecha: ',TRIM(CAST(date_format(ped_fech,'%d/%m/%Y') as char))) cadena from pedidos where ped_codi = ?xped;","auxi")
	SQLEXEC(cn2,"update facturas set cotiz_dolar = ?xdolar where fac_codi = ?xfac;")
*!*		=MESSAGEBOX("Codiped1: "+ALLTRIM(STR(cur_ped1.ped_codi))+' '+'Cotiz: $ '+ALLTRIM(STR(cur_ped1.cotiz_dolar,15,3))+CHR(13)+CHR(13)+ ;
*!*					ALLTRIM(auxi.cadena))
ENDSCAN

SQLDISCONNECT(cn1)
SQLDISCONNECT(cn2)
