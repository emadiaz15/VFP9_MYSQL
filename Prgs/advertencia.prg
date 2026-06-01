parameter fila
preg=messagebox("Para ingresar más Items debe eliminar el cargo ingresado"+chr(13)+ ;
				"dado que el cargo se calcula sobre el neto total"+chr(13)+ ;
				chr(13)+ ;
				"¿Desea elminar el cargo ingresado ahora?",4+48+256,"Advertencia!!!")
if preg=6
	with altarecep
		.grid1.row=fila
		.grid1.col=6
		acu=acu-ConverNro(.grid1.text)
		.grid1.removeitem(fila)
	endwith
	opcion=0
	on key label INS do form cualartprov with codiprov,cond,opcion,dato1,dato2,dato3,dato4,codigo,cant,descri,pruni,prtot
endif
return