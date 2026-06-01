texto='REPARACION DE 1 TRANSFORMADOR DE 40 KVA, TIPO DISTRIBUCION, RELACION 33 kV/13.2kV, AL CUAL SE LE DEBEN REALIZAR LOS ººSIGUIENTES TRABAJOS DESENCUBADO Y DESARMADO, BOBINADO COMPLETO DE LA COLUMNA V, SECADO DE AUTOCLAVE, ARMADO Y PRUEBAS DE ENSAYO CORRESPONDIENTES.-'
if len(texto)>44
	posin=1
	poscar=44
	contcar=44
	do while contcar<=len(texto)
		if !inlist(subst(texto,contcar,1)," ",".","-","_")
			do while !inlist(subst(texto,contcar,1)," ",".","-","_")
				poscar=poscar-1
				contcar=contcar-1
*!*					if posin>1
*!*						posin=posin-1
*!*					endif
			enddo
		endif
*!*			messagebox("contcar: "+allt(str(contcar))+chr(13)+ ;
*!*					   "poscar: "+allt(str(poscar))+chr(13)+ ;
*!*					   "posin: "+allt(str(posin)))
		messagebox(subst(texto,posin,poscar))
		contcar=contcar+1
		posin=contcar
		restcar=len(texto)-(contcar-1)
		if restcar<=44
			messagebox(subst(texto,posin,restcar))
			exit
*			if contcar+44>len(texto)
*				poscar=contcar+((contcar+44)-len(texto))
*	            contcar=contcar+poscar
		else
			contcar=contcar+44
			poscar=44
		endif
*	contcar=contcar+1
*	posin=contcar
	enddo
endif