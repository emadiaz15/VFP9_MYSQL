LOCAL lcImagen, lo
*lcPlanilla
*-- Selecciono imagen y nombre de planilla (xls)
lcImagen = GETPICT()
*lcPlanilla = PUTFILE("Nombre","MiPlanilla","xls")
*-- Creo objeto Excel
lo = CREATEOBJECT("Excel.Application")
*-- Añado un libro nuevo
lo.Workbooks.Add
*-- Selecciono la celda donde estará la posición de la imagen
lo.Cells(7,7).Select
lo.ActiveSheet.Pictures.Insert(lcImagen).Select
lo.Selection.ShapeRange.LockAspectRatio = 0
lo.Selection.ShapeRange.Height = 320 && pixeles
lo.Selection.ShapeRange.Width = 240 && pixeles
lo.Visible = .T.