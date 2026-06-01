close all
set point to ","
set separator to "."
sele 0
use clientes
sele 0
use facturas
set rela to cli_codi into clientes
sele 0
use facturas_articulos
set rela to fac_codi into facturas
nrorem=6486
codifac=33410
*acu=999.90
impiva1=21.00
impiva2=10.50
totsiva=3335.52
*round(acu-(acu*.0/100),2)
ivari=700.46
*round(totsiva*impiva1/100,2)
ivarni=350.23
*round(totsiva*impiva2/100,2)
totalri=totsiva+ivari
totalrni=totsiva+ivari+ivarni
*for n=1 to 2
*	if n=1
*		comprobante="ORIGINAL"
*	else
		comprobante="DUPLICADO"
*	endif
	report form factura for facturas_articulos.fac_codi=codifac to printer prompt noconsole
*next n
set point to
set separator to