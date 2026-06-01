LOCAL empresa,xrubroc,xfila,xfilpag,xcolumna,xhoja

SET DECIMALS TO 3
prcxls= conectar_db(_screen.cn)
	SQLEXEC(prcxls,"select a.*,b.rub_desc from articulos a inner join rubros b on a.rub_codi=b.rub_codi where a.art_codi>5 order by a.rub_codi,a.art_codi;","cur_artxls")
	SQLEXEC(prcxls,"select TRIM(param_desc) as param_desc from parametros where param_codi=13;","cur_empre")
	SQLEXEC(prcxls,"select param_impo from parametros where param_codi=3;","cur_cuit")
desconectar_db(prcxls)
SET DECIMALS TO

IF RECCOUNT("cur_artxls")>0
	xhoja=1
	empresa=ALLTRIM(cur_empre.param_desc)+" - CUIT: "+SUBSTR(ALLTRIM(STR(cur_cuit.param_impo,11)),1,2)+"-"+ ;
		SUBSTR(ALLTRIM(STR(cur_cuit.param_impo,11)),3,8)+"-"+SUBSTR(ALLTRIM(STR(cur_cuit.param_impo,11)),11,1)
	cerrar_cursor("cur_empre")
	cerrar_cursor("cur_cuit")
	wait'Espere Un Momento Exportando Datos' window nowait
	_screen.mousepointer=11
	TmpSheet=GetObject('','Excel.Sheet')
	XLApp=TmpSheet.Application
	XLApp.visible=.T.
	XLApp.WindowState = -4137
	XLApp.workbooks.add()
	XLSheet=XLApp.ActiveSheet	
	XLSheet.Columns("A:A").ColumnWidth = 1
	XLSheet.Columns("B:B").ColumnWidth = 8.71
	XLSheet.Columns("C:C").ColumnWidth = 35
	XLSheet.Columns("D:D").ColumnWidth = 9.71
	XLSheet.Columns("E:E").ColumnWidth = 1.29
	XLSheet.Columns("F:F").ColumnWidth = 8.71
	XLSheet.Columns("G:G").ColumnWidth = 35
	XLSheet.Columns("H:H").ColumnWidth = 9.71
	XLSheet.Columns("I:I").ColumnWidth = 1.29
	XLSheet.Rows(4).RowHeight = 7.5
	**** COMIENZA ENCABEZADO  *******
	XLSheet.cells(1,8).HorizontalAlignment=4
	Xlsheet.cells(1,8)=empresa
	XLSheet.Cells(1,8).font.bold=.T.
	XLSheet.Cells(1,8).font.size="10"
	XLSheet.Cells(1,8).font.name="Courier New"
	XLSheet.cells(3,5).HorizontalAlignment=3
	Xlsheet.cells(3,5)="LISTADO DE PRECIOS EN DOLARES AL "+allt(dtoc(date()))+" (s/iva)"
	XLSheet.Cells(3,5).font.bold=.T.
	XLSheet.Cells(3,5).font.underline=.T.
	XLSheet.Cells(3,5).font.size="12"
	XLSheet.Cells(3,5).font.name="Courier New"
	Xlsheet.cells(3,8)="HOJA: "+ALLTRIM(STR(xhoja))
	Xlsheet.cells(3,8).font.size="9"
	XLSheet.Cells(3,8).font.bold=.T.
	XLSheet.Cells(3,8).font.name="Arial Black"
	XLSheet.Range(XLSheet.Cells(3,8),XLSheet.Cells(3,8)).HorizontalAlignment=3
	XLSheet.Range("B5:H5").BORDERS(3).LineStyle=9 
	XLSheet.Range("B5:H5").BORDERS(4).LineStyle=9
	XLSheet.Cells(5,2)="CÓDIGO"
	XLSheet.Cells(5,3)="DESCR IPCIÓN"
 	XLSheet.Cells(5,4)="PRECIO"
	XLSheet.Cells(5,6)="CÓDIGO"
	XLSheet.Cells(5,7)="DESCRIPCIÓN"
	XLSheet.Cells(5,8)="PRECIO"
	XLSheet.Range("B5:H5").font.bold=.T.
	XLSheet.Range("B5:H5").font.size="10"
	XLSheet.Range("B5:H5").font.name="Courier New"
	XLSheet.Range("B5:H5").HorizontalAlignment=3
   **** FIN ENCABEZADO ***
	with XLSheet.PageSetup
		.Orientation = 1
		.LeftMargin = XLApp.InchesToPoints(0)
		.RightMargin = XLApp.InchesToPoints(0)
	    .TopMargin = XLApp.InchesToPoints(0)
	    .BottomMargin = XLApp.InchesToPoints(0)
	    .HeaderMargin = XLApp.InchesToPoints(0)
	    .FooterMargin = XLApp.InchesToPoints(0)
	    .Zoom=85
	ENDWITH
	xfila=6
	xcolumna=2
	SELECT cur_artxls
	LOCATE
	store 0 to xrubroc
	xfilpag=6
	SCAN
		xrubroc=cur_artxls.rub_codi
		if xfilpag=65
			xfila=xfila+3
			xhoja=xhoja+1
			XLSheet.cells(xfila,8).HorizontalAlignment=4
			Xlsheet.cells(xfila,8)=empresa
			XLSheet.Cells(xfila,8).font.bold=.T.
			XLSheet.Cells(xfila,8).font.size="10"
			XLSheet.Cells(xfila,8).font.name="Courier New"
			xfila=xfila+2
			XLSheet.cells(xfila,5).HorizontalAlignment=3
			Xlsheet.cells(xfila,5)="LISTADO DE PRECIOS EN DOLARES AL "+allt(dtoc(date()))+" (s/iva)"
			XLSheet.Cells(xfila,5).font.bold=.T.
			XLSheet.Cells(xfila,5).font.underline=.T.
			XLSheet.Cells(xfila,5).font.size="12"
			XLSheet.Cells(xfila,5).font.name="Courier New"
			Xlsheet.cells(xfila,8)="HOJA: "+ALLTRIM(STR(xhoja))
			Xlsheet.cells(xfila,8).font.size="9"
			XLSheet.Cells(xfila,8).font.bold=.T.
			XLSheet.Cells(xfila,8).font.name="Arial Black"
			XLSheet.Range(XLSheet.Cells(xfila,8),XLSheet.Cells(xfila,8)).HorizontalAlignment=3
			xfila=xfila+2
			XLSheet.Rows(xfila-1).RowHeight = 7.5
			XLSheet.Range(XLSheet.Cells(xfila,2),XLSheet.Cells(xfila,8)).BORDERS(3).LineStyle=9
			XLSheet.Range(XLSheet.Cells(xfila,2),XLSheet.Cells(xfila,8)).BORDERS(4).LineStyle=9
			XLSheet.Cells(xfila,2)="CÓDIGO"
			XLSheet.Cells(xfila,3)="DESCRIPCIÓN"
			XLSheet.Cells(xfila,4)="PRECIO"
			XLSheet.Cells(xfila,6)="CÓDIGO"
			XLSheet.Cells(xfila,7)="DESCRIPCIÓN"
			XLSheet.Cells(xfila,8)="PRECIO"
			XLSheet.Range(XLSheet.Cells(xfila,2),XLSheet.Cells(xfila,8)).font.bold=.T.
			XLSheet.Range(XLSheet.Cells(xfila,2),XLSheet.Cells(xfila,8)).font.size="10"
			XLSheet.Range(XLSheet.Cells(xfila,2),XLSheet.Cells(xfila,8)).font.name="Courier New"
			XLSheet.Range(XLSheet.Cells(xfila,2),XLSheet.Cells(xfila,8)).HorizontalAlignment=3
			xfilpag=6
			xfila=xfila+1 
		endif
		XlSheet.cells(xfila,xcolumna)=repl("0",8-len(allt(str(cur_artxls.rub_codi))))+allt(str(cur_artxls.rub_codi))
		xcolumna=xcolumna+1
		XlSheet.cells(xfila,xcolumna)=substr(allt(cur_artxls.rub_desc),1,36)
		xcolumna=xcolumna-1
		XLSheet.Range(XLSheet.Cells(xfila,xcolumna),XLSheet.Cells(xfila,xcolumna+1)).font.bold=.T.
		XLSheet.Range(XLSheet.Cells(xfila,xcolumna),XLSheet.Cells(xfila,xcolumna+1)).font.size="9"
		XLSheet.Range(XLSheet.Cells(xfila,xcolumna),XLSheet.Cells(xfila,xcolumna+1)).font.name="Courier New"
		xfila=xfila+1
		xfilpag=xfilpag+1
		do while cur_artxls.rub_codi=xrubroc
			xcolumna=2
			if xfilpag=65
				xfila=xfila+3
				xhoja=xhoja+1
				XLSheet.cells(xfila,8).HorizontalAlignment=4
				Xlsheet.cells(xfila,8)=empresa
				XLSheet.Cells(xfila,8).font.bold=.T.
				XLSheet.Cells(xfila,8).font.size="10"
				XLSheet.Cells(xfila,8).font.name="Courier New"
				xfila=xfila+2
				XLSheet.cells(xfila,5).HorizontalAlignment=3
				Xlsheet.cells(xfila,5)="LISTADO DE PRECIOS EN DOLARES AL "+allt(dtoc(date()))+" (s/iva)"
				XLSheet.Cells(xfila,5).font.bold=.T.
				XLSheet.Cells(xfila,5 ).font.underline=.T.
				XLSheet.Cells(xfila,5).font.size="12"
				XLSheet.Cells(xfila,5).font.name="Courier New"
				Xlsheet.cells(xfila,8)="HOJA: "+ALLTRIM(STR(xhoja))
				Xlsheet.cells(xfila,8).font.size="9"
				XLSheet.Cells(xfila,8).font.bold=.T.
				XLSheet.Cells(xfila,8).font.name="Arial Black"
				XLSheet.Range(XLSheet.Cells(xfila,8),XLSheet.Cells(xfila,8)).HorizontalAlignment=3
				xfila=xfila+2 
				XLSheet.Rows(xfila-1).RowHeight = 7.5
				XLSheet.Range(XLSheet.Cells(xfila,2),XLSheet.Cells(xfila,8)).BORDERS(3).LineStyle=9
				XLSheet.Range(XLSheet.Cells(xfila,2),XLSheet.Cells(xfila,8)).BORDERS(4).LineStyle=9
				XLSheet.Cells(xfila,2)="CÓDIGO"
				XLSheet.Cells(xfila,3)="DESCRIPCIÓN"
				XLSheet.Cells(xfila,4)="PRECIO"
				XLSheet.Cells(xfila,6)="CÓDIGO"
				XLSheet.Cells(xfila,7)="DESCRIPCIÓN"
				XLSheet.Cells(xfila,8)="PRECIO"
				XLSheet.Range(XLSheet.Cells(xfila,2),XLSheet.Cells(xfila,8)).font.bold=.T.
				XLSheet.Range(XLSheet.Cells(xfila,2),XLSheet.Cells(xfila,8)).font.size="10"
				XLSheet.Range(XLSheet.Cells(xfila,2),XLSheet.Cells(xfila,8)).font.name="Courier New"
				XLSheet.Range(XLSheet.Cells(xfila,2),XLSheet.Cells(xfila,8)).HorizontalAlignment=3
				xfilpag=6 
				xfila=xfila+1
			endif
			XlSheet.cells(xfila,xcolumna)=repl("0",8-len(allt(str(cur_artxls.art_codi))))+allt(str(cur_artxls.art_codi))
			XlSheet.cells(xfila,xcolumna+1)=substr(allt(cur_artxls.art_desc),1,40)
			XlSheet.cells(xfila,xcolumna+2)=cur_artxls.art_precio
			XLSheet.Cells(xfila,xcolumna+2).NUMBERFORMAT="#,###0.000"
			SKIP 
			if xrubroc=cur_artxls.rub_codi
				xcolumna=6
				XlSheet.cells(xfila,xcolumna)=repl("0",8-len(allt(str(cur_artxls.art_codi))))+allt(str(cur_artxls.art_codi))
				XlSheet.cells(xfila,xcolumna+1)=substr(allt(cur_artxls.art_desc),1,40)
				XlSheet.cells(xfila,xcolumna+2)=cur_artxls.art_precio
				XLSheet.Cells(xfila,xcolumna+2).NUMBERFORMAT="#,###0.000"
				skip
	 		ENDIF
			xcolumna=2
			XLSheet.Range(XLSheet.Cells(xfila,xcolumna),XLSheet.Cells(xfila,xcolumna+8)).font.size="9"
			XLSheet.Range(XLSheet.Cells(xfila,xcolumna),XLSheet.Cells(xfila,xcolumna+8)).font.name="Courier New"
			if xrubroc<>cur_artxls.rub_codi
				xfila=xfila+2
				xfilpag=xfilpag+2
				IF xfilpag>65
					xfila=xfila-1 
					xfilpag=65
				ENDIF 
			else
				xfila=xfila+1
				xfilpag=xfilpag+1
				IF xfilpag>65
					xfilpag=65
				ENDIF
			ENDIF
		enddo
	ENDSCAN
	XLSheet.Columns("B").HorizontalAlignment=3
	XLSheet.Columns("F").HorizontalAlignment=3	
	XLApp.visible=.T.
    DECLARE LONG BringWindowToTop IN "user32" LONG HWND
    BringWindowToTop(XLApp.HWND)
	KEYBOARD '{SPACEBAR}'
	 _screen.mousepointer=0
ENDIF