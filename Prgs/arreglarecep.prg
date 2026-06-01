close all
sele 0
use "c:\dho srl\recepciones.dbf" alias recint9
set order to recep_codi
sele 0
use recepciones
set order to recep_codi
set rela to recep_codi into recint9
go top
scan for recep_codi<=23212 
	repla recep_impng with recint9.recep_impng
	repla neto_1 with recint9.neto_1
	repla neto_2 with recint9.neto_2
	repla recep_ivari with recint9.recep_ivari
	repla recep_ivarni with recint9.recep_ivarni
	repla imp_pag with recint9.imp_pag
	wait wind allt(str(recint9.recep_codi))+"  -----   "+allt(str(recep_codi)) nowait
endscan