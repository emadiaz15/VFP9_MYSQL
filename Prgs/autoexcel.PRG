#INCLUDE XLS.H

tmpsheet = GetObject('','excel.sheet')  
XLApp = tmpsheet.application
XLApp.WorkBooks.Add() &&Agrega una Hoja de calculo
XLSheet = XLApp.ActiveSheet
XLSheet.Pictures.Insert("\\192.168.0.2\Dho Srl\HP.JPG").name="Picture 1"
XLSheet.Shapes("Picture 1").Width=115
WITH XLSheet.Range("B17:M17")
	.Borders(3).LineStyle=1
	.Borders(4).LineStyle=9
ENDWITH

XLSheet.Columns("A:A").ColumnWidth=0.2
XLSheet.Columns("B:B").ColumnWidth=4.57
XLSheet.Columns("C:C").ColumnWidth=12
XLSheet.Columns("D:D").ColumnWidth=4.14
XLSheet.Columns("E:E").ColumnWidth=9
XLSheet.Columns("F:F").ColumnWidth=13.29
XLSheet.Columns("G:G").ColumnWidth=10.29
XLSheet.Columns("H:H").ColumnWidth=0.8
XLSheet.Columns("I:I").ColumnWidth=3.14
XLSheet.Columns("J:J").ColumnWidth=6.86
XLSheet.Columns("K:K").ColumnWidth=9
XLSheet.Columns("L:L").ColumnWidth=10.43
XLSheet.Columns("M:M").ColumnWidth=10.43

WITH XLSheet.Range("F6:J6")
	.Merge
    .value='PRESUPUESTO'
    .HorizontalAlignment=xlCenter &&Alinear al centro *
    .VerticalAlignment=xlCenter 
    .Font.Bold=.t.
    .Font.Underline=.t.
    .Font.Size=15             
	.Font.Name='Arial'
ENDWITH
WITH XLSheet.Range("L7")
    .value='Presup. Nº:'
    .VerticalAlignment=xlCenter 
    .Font.Bold=.t.
    .Font.Size=10             
	.Font.Name='Arial'
ENDWITH
WITH XLSheet.Range("L9")
    .value='Fecha:'
    .VerticalAlignment=xlCenter 
    .Font.Bold=.t.
    .Font.Size=10             
	.Font.Name='Arial'
ENDWITH

WITH XLSheet.Range("B17")
	.Value='Item'
	.VerticalAlignment=xlCenter
	.Font.Bold=.t.
	.Font.Size=10
	.Font.Name='Courier New'
ENDWITH
WITH XLSheet.Range("C17")
	.Value='Cant.'
	.VerticalAlignment=xlCenter
	.Font.Bold=.t.
	.Font.Size=10
	.Font.Name='Courier New'
ENDWITH

WITH XLSheet.Range("D17")
	.Value='Med.'
	.VerticalAlignment=xlCenter
	.Font.Bold=.t.
	.Font.Size=10
	.Font.Name='Courier New'
ENDWITH

WITH XLSheet.Range("E17")
	.Value='Código'
	.VerticalAlignment=xlCenter
	.Font.Bold=.t.
	.Font.Size=10
	.Font.Name='Courier New'
ENDWITH

WITH XLSheet.Range("F17:K17")
	.Merge
	.Value='Descripción'
	.VerticalAlignment=xlCenter
	.Font.Bold=.t.
	.Font.Size=10
	.Font.Name='Courier New'
ENDWITH
WITH XLSheet.Range("L17")
	.Value='Pr.Unit.'
	.VerticalAlignment=xlCenter
	.Font.Bold=.t.
	.Font.Size=10
	.Font.Name='Courier New'
ENDWITH
WITH XLSheet.Range("M17")
	.Value='Pr.Total'
	.VerticalAlignment=xlCenter
	.Font.Bold=.t.
	.Font.Size=10
	.Font.Name='Courier New'
ENDWITH

WITH XLSheet.PageSetup
*    .PrintArea = "$A:$Q" &&Area de Impresion
 *   .PrintTitleRows = "$1:$4" &&Filas como titulo
  *  .PrintTitleColumns = ""  
   * .LeftHeader = ""
  *  .CenterHeader = ""
  *  .RightHeader = ""
   * .LeftFooter = "&D &T" &&Pie de pagina fecha y hora
	.CenterFooter = ""
    .RightFooter = "&P" &&Pie de pagina izquierdo Numero pagina
    *Margenes
    .LeftMargin = XLApp.InchesToPoints(0.10)
    *.LeftMargin = XLApp.InchesToPoints(0.393700787401575)
    .RightMargin = XLApp.InchesToPoints(0.10)
    .TopMargin = XLApp.InchesToPoints(0.10)
    .BottomMargin = XLApp.InchesToPoints(0.10)
    .HeaderMargin = XLApp.InchesToPoints(0)
    .FooterMargin = XLApp.InchesToPoints(0)
    .PrintHeadings = .f.
    .PrintGridlines = .f.
    .PrintComments = xlPrintNoComments
    * Centrar area
	.CenterHorizontally = .t.
    .CenterVertically = .f.
    .Orientation = xlPortrait
    .Draft = .f.
    .PaperSize = xlPaperA4
    .FirstPageNumber = xlAutomatic
    .Order = xlDownThenOver
    .BlackAndWhite = .f.
    *Imprimir a un %
*	.Zoom = 80
ENDWITH
	
XLApp.Visible = .t. &&Aplicacion visible