close all
set talk off
set dele on
set date british
set cent on
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
	go top
	local rubroc,fila,columna,hoja
	store 0 to rubroc
	getcp()
	set devi to file "C:\Lista de Precios.xls" ascii
	columna=1
	hoja=1
	*@ 1,9 say "LISTADO DE PRECIOS EN PESOS AL "+allt(dtoc(date()))+" (s/iva)" font 'Courier New',12 style 'BU'
	@ 1,9 say "LISTADO DE PRECIOS EN DOLARES AL "+allt(dtoc(date()))+" (s/iva)" font 'Courier New',12 style 'BU'
	@ 3,0 say repl("=",104)
	@ 4,0 say "CODIGO  DESCRIPCION                                      PRECIO" font 'Courier New',9 style 'N'
	@ 5,0 say repl("=",104)
	fila=6
	columna=0
	do while !eof()
		rubroc=cur_artxls.rub_codi
	*	if fila=5
	*		@ 1,2 say "Fecha: "+allt(dtoc(date())) font 'Courier New',9 style 'N'
	*		@ 1,115 say "HOJA: "+allt(str(hoja)) font 'Courier New',9 style 'N'
	*		@ 2,0 say repl("=",104)
	*		@ 3,0 say "CODIGO  DESCRIPCION                                      PRECIO" font 'Courier New',9 style 'N'
	*		@ 4,0 say repl("=",104)
	*	endif
		@ fila,columna say repl("0",8-len(allt(str(cur_artxls.rub_codi))))+allt(str(cur_artxls.rub_codi));
			font 'Courier New',8 style 'B'
		@ fila,columna+10 say substr(allt(cur_artxls.rub_desc),1,36) font 'Courier New',8 style 'B'
		fila=fila+1
		do while cur_artxls.rub_codi=rubroc
	*		if fila=5
	**			@ 1,34 clear
	*			@ 1,2 say "Fecha: "+allt(dtoc(date())) font 'Courier New',9 style 'N'
	*			@ 1,115 say "HOJA: "+allt(str(hoja)) font 'Courier New',9 style 'N'
	*			@ 2,0 say repl("=",104)
	*	  		@ 3,0 say "CODIGO  DESCRIPCION                                      PRECIO" font 'Courier New',9 style 'N'
	* 			@ 4,0 say repl("=",104)
	*		endif
			@ fila,columna say repl("0",8-len(allt(str(cur_artxls.art_codi))))+allt(str(cur_artxls.art_codi)) font 'Courier New',8 style 'N'
			@ fila,columna+10 say substr(allt(cur_artxls.art_desc),1,40) font 'Courier New',8 style 'N'
			@ fila,columna+52 say cur_artxls.art_precio pict "9999999.999" font 'Courier New',8 style 'N'
			skip
			if rubroc<>cur_artxls.rub_codi
				fila=fila+2
			else
				fila=fila+1
			endif
			if fila>=68
				fila=3
	*			hoja=hoja+1
	**			wait "Presione una tecla para acceder a otra página..." wind
	**			@ 05,00 clear
			endif
		enddo
		if fila>=68
			fila=3
	*		hoja=hoja+1
	*		wait "Presione una tecla para acceder a otra página..." wind
	*		@ 05,00 clear
	*	else
	*		if !eof()
	*			fila=fila+1
	*		endif
		endif
	enddo
	set devi to screen
	set point to
ENDIF