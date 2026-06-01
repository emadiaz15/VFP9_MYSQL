public pantalla
pantalla = createobject("form")
pantalla.addobject("objeto", "olecontrol", "msgraph.chart.8")
pantalla.objeto.top = 0
pantalla.objeto.left = 0
pantalla.objeto.height = pantalla.height
pantalla.objeto.width = pantalla.width
pantalla.visible = .t.
pantalla.objeto.visible = .t.
pantalla.lockscreen = .t.
pantalla.objeto.object.application.chart.charttype = 56 && -4100
pantalla.objeto.object.application.datasheet.range("00").value = " "
pantalla.objeto.object.application.datasheet.range("01").value = "Pedro"
pantalla.objeto.object.application.datasheet.range("02").value = "Luis"
pantalla.objeto.object.application.datasheet.range("03").value = "Carlos"
pantalla.objeto.object.application.datasheet.range("A0").value = "Enero"
pantalla.objeto.object.application.datasheet.range("A1").value = 25
pantalla.objeto.object.application.datasheet.range("A2").value = 40
pantalla.objeto.object.application.datasheet.range("A3").value = 50
pantalla.objeto.object.application.datasheet.range("B0").value = "Febrero"
pantalla.objeto.object.application.datasheet.range("B1").value = 35
pantalla.objeto.object.application.datasheet.range("B2").value = 55
pantalla.objeto.object.application.datasheet.rows("4").delete
pantalla.objeto.object.application.datasheet.rows("5").delete
pantalla.objeto.object.application.datasheet.columns("4").delete
pantalla.objeto.object.application.datasheet.columns("4").delete
pantalla.objeto.object.application.chart.hastitle = .t.
pantalla.objeto.object.application.chart.charttitle.text = "Mi gráfico"
pantalla.lockscreen = .f.

