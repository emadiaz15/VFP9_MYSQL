close all
set point to ","
set separator to "."
set dele on
local coditran1,coditran2,lugent1,lugent2,flete1,flete2
coditran1=0
coditran2=0
lugent1=""
lugent2=""
flete1=0
flete2=0
codirem=31253
nrofac=0
sele 0
use remitos_transportes
set order to rem_codi
seek codirem
if found()
	coditran1=tran_codi
	lugent1=flete_lugent
	do case
		case flete_cargo="P"
			flete1=1
		case flete_cargo="C"
			flete1=2
	endcase
	skip
	if rem_codi=codirem
		coditran2=tran_codi
		lugent2=flete_lugent
		do case
			case flete_cargo="P"
				flete2=1
			case flete_cargo="C"
				flete2=2
		endcase
	endif
endif
dimension tra[2,5]
store "" to tra[1,1],tra[1,2],tra[1,5],tra[2,1],tra[2,2],tra[2,5]
store 0 to tra[1,3],tra[1,4],tra[2,3],tra[2,4]
sele 0
use transportes
set order to tran_codi
seek coditran1
tra[1,1]=allt(tran_nomb)
tra[1,2]=allt(tran_domi)
tra[1,3]=tran_cartel
tra[1,4]=tran_tel1
tra[1,5]=allt(lugent1)
seek coditran2
tra[2,1]=allt(tran_nomb)
tra[2,2]=allt(tran_domi)
tra[2,3]=tran_cartel
tra[2,4]=tran_tel1
tra[2,5]=allt(lugent2)
for n=1 to 3
	do case
		case n=1
			comprobante="ORIGINAL"
		case n=2
			comprobante="DUPLICADO"
		case n=3
			comprobante="TRIPLICADO"
	endcase
	report form remito for remitos_articulos.rem_codi=codirem to printer prompt noconsole
next n
set point to
set separator to