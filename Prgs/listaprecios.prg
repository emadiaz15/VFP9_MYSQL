*!*	set talk off
*!*	set dele on
*!*	set date british
*!*	set cent on
set point to ","
SET CONSOLE OFF
SET NOTIFY OFF

SET LIBRARY TO C:\VFP9_MYSQL\Prgs\librerias.prg
set path to C:\vfp9_mysql, ;
			C:\VFP9_MYSQL\Prgs

LOCAL xcadena
xcadena = Crear_Estruc_Conex_Mysql("USER_CONNECT")
_screen.AddProperty("cn",xcadena)

SET DECIMALS TO 3
prcxls= conectar_db(_screen.cn)
	SQLEXEC(prcxls,"select a.*,b.rub_desc from articulos a inner join rubros b on a.rub_codi=b.rub_codi where a.art_codi>5 order by a.rub_codi,a.art_codi;","cur_artxls")
desconectar_db(prcxls)
SET DECIMALS TO

IF RECCOUNT("cur_artxls")>0
	prelis= MESSAGEBOX("¿Imprime lista de precios con existencia de stock?",4+64,"Aviso del Sistema")
	go top
	local rubroc,fila,columna,hoja
	store 0 to rubroc
	set devi to printer prompt
	columna=1
	hoja=1
	@ 1,25 say "LISTADO DE PRECIOS EN DOLARES AL "+allt(dtoc(date()))+" (s/iva)" font 'Courier New',12 style 'BUT'
	*@ 1,25 say "LISTADO DE PRECIOS EN PESOS AL "+allt(dtoc(date()))+" (s/iva)" font 'Courier New',12 style 'BU'
	@ 3,0 say repl("=",104)
	IF prelis=6
		@ 4,0 say "CODIGO  DESCRIPCION                    EXIS  PRECIO  CODIGO  DESCRIPCION                    EXIS" font 'Courier New',9 style 'NT'
	ELSE
		@ 4,0 say "CODIGO  DESCRIPCION                          PRECIO  CODIGO  DESCRIPCION                        " font 'Courier New',9 style 'NT'
	ENDIF
	@ 4,90 say "PRECIO" font 'Courier New',9 style 'NT'
	@ 5,0 say repl("=",104)
	fila=6
	do while !eof()
		rubroc=cur_artxls.rub_codi
		columna=0
		if fila=5
			@ 1,2 say "Fecha: "+allt(dtoc(date())) font 'Courier New',9 style 'NT'
			@ 1,89 say "HOJA: "+allt(str(hoja)) font 'Courier New',9 style 'NT'
			@ 2,0 say repl("=",104)
			IF prelis=6
				@ 3,0 say "CODIGO  DESCRIPCION                    EXIS  PRECIO  CODIGO  DESCRIPCION                    EXIS" font 'Courier New',9 style 'NT'
			ELSE
				@ 3,0 say "CODIGO  DESCRIPCION                          PRECIO  CODIGO  DESCRIPCION                        " font 'Courier New',9 style 'NT'
			ENDIF
			@ 3,90 say "PRECIO" font 'Courier New',9 style 'NT'
			@ 4,0 say repl("=",104)
		endif
		@ fila,columna say repl("0",8-len(allt(str(cur_artxls.rub_codi))))+allt(str(cur_artxls.rub_codi));
			font 'Courier New',8 style 'BT'
		@ fila,columna+7 say substr(allt(cur_artxls.rub_desc),1,36) font 'Courier New',8 style 'BT'
		fila=fila+1
		do while cur_artxls.rub_codi=rubroc
			columna=0
			if fila=5
	*			@ 1,34 clear
				@ 1,2 say "Fecha: "+allt(dtoc(date())) font 'Courier New',9 style 'NT'
				@ 1,89 say "HOJA: "+allt(str(hoja)) font 'Courier New',9 style 'NT'
				@ 2,0 say repl("=",104)
				IF prelis=6
		 	  		@ 3,0 say "CODIGO  DESCRIPCION                    EXIS  PRECIO  CODIGO  DESCRIPCION                    EXIS" font 'Courier New',9 style 'NT'
		 	  	ELSE
		 	  		@ 3,0 say "CODIGO  DESCRIPCION                          PRECIO  CODIGO  DESCRIPCION                        " font 'Courier New',9 style 'NT'
		 	  	ENDIF
		 	  	@ 3,90 say "PRECIO" font 'Courier New',9 style 'NT'
				@ 4,0 say repl("=",104)
			endif
			@ fila,columna say repl("0",8-len(allt(str(cur_artxls.art_codi))))+allt(str(cur_artxls.art_codi)) font 'Courier New',8 style 'NT'
	*		@ fila,columna+7 say substr(allt(cur_artxls.art_desc),1,33) font 'Courier New',8 style 'N'
			@ fila,columna+7 say substr(allt(cur_artxls.art_desc),1,40) font 'Courier New',8 style 'NT'
			IF prelis=6
				@ fila,columna+36 say cur_artxls.art_stock pict "99999" font 'Courier New',8 style 'NT'
			ENDIF
			@ fila,columna+39 say cur_artxls.art_precio pict "99999.999" font 'Courier New',8 style 'NT'
			skip
			if rubroc=rub_codi
				columna=47
				@ fila,columna say repl("0",8-len(allt(str(cur_artxls.art_codi))))+allt(str(cur_artxls.art_codi)) font 'Courier New',8 style 'NT'
	*			@ fila,columna+7 say substr(allt(cur_artxls.art_desc),1,33) font 'Courier New',8 style 'N'
				@ fila,columna+7 say substr(allt(cur_artxls.art_desc),1,40) font 'Courier New',8 style 'NT'
				IF prelis=6
					@ fila,columna+36 say cur_artxls.art_stock pict "99999" font 'Courier New',8 style 'NT'
				ENDIF
				@ fila,columna+42 say cur_artxls.art_precio pict "99999.999" font 'Courier New',8 style 'NT'
				skip
			endif
			if rubroc<>rub_codi
				fila=fila+2
			else
				fila=fila+1
			endif
			if fila>=75
				fila=5
				hoja=hoja+1
	*			wait "Presione una tecla para acceder a otra página..." wind
	*			@ 05,00 clear
			endif
		enddo
		if fila>=75
			cancel
			exit
			fila=5
			hoja=hoja+1
	*		wait "Presione una tecla para acceder a otra página..." wind
	*		@ 05,00 clear
	*	else
	*		if !eof()
	*			fila=fila+1
	*		endif
		endif
	enddo
	set device to screen
	set printer to
ENDIF
