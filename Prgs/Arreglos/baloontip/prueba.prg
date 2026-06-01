TEXT TO pcTextoBalloon NOSHOW
  Tu texto puede tener un máximo de 120 caracteres y ocupar
  como máximo 4 líneas. Si es más largo, el resto no será
  mostrado.
ENDTEXT
 
loSysTray = CreateObject("WALTER_SYSTRAY")
 
IF Vartype(loSysTray) == "O" THEN     && Si se pudo crear el objeto
  #DEFINE ICONO_NADA  0
  #DEFINE ICONO_INFO  1
  #DEFINE ICONO_AVISO 2
  #DEFINE ICONO_ERROR 3
  loSysTray.ShowBalloonTip(pcTextoBalloon, "Ejemplo de un balloon", ICONO_INFO, 0)
  READ EVENTS     && Procesa los eventos, o sea que le permite al usuario elegir opciones del menú
ENDIF