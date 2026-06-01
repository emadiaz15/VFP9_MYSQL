y = CreateObject('cdonts.newmail')
y.AttachFile('f:\presupuesto.xls')   && Archivo Adjunto
y.Send('hpelectricidad@intericity.net.ar' , 'carlosdho@intercity.net.ar' , 'Subject' , 'Esta es una prueba')
y=null 
