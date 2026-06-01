close all
set dele on
set date british
set cent on
sele 0
use articulos
set order to art_codi
sele 0
use proveedores
set order to prov_codi
sele 0
use articulos_proveedores
set order to artpro_cod
set rela to art_codi into articulos addi
set rela to prov_codi into proveedores addi

local costopesos
costopesos=0

create cursor costos ;
	(artpr N(10),codart N(8),nombre C(45),codprov N(8),nomprov C(35),costo N(10,3),precvta N(10,3),moneda C(1))

sele articulos_proveedores
go top
scan
	if moneda="D"
		costopesos=artpro_costo*16.50
*		if art_codi=1012418
*			=messagebox("Articulo: "+allt(str(art_codi))+chr(13)+ ;
*						"Descripcion: "+allt(articulos.art_desc)+chr(13)+ ;
*						"Costo: "+allt(str(artpro_costo,10,3))+chr(13)+ ;
*						"Moneda: "+allt(moneda)+chr(13)+ ;
*						"Costo en Pesos: "+allt(str(costopesos,10,3))+chr(13)+ ;
*						"Precio Venta: "+allt(str(articulos.art_precio,10,3)))
*		endif
	else
		costopesos=artpro_costo
	endif
	if round(articulos.art_precio/1.55,3)=costopesos
		insert into costos ;
			(artpr,codart,nombre,codprov,nomprov,costo,precvta,moneda) ;
		values(articulos_proveedores.artpro_codi,articulos_proveedores.art_codi, ;
		articulos.art_desc,proveedores.prov_codi,proveedores.prov_nomb,articulos_proveedores.artpro_costo, ;
		articulos.art_precio,articulos_proveedores.moneda)
	endif
endscan
sele costos
go top
set safety off
COPY TO c:\users\administrador\desktop\costosact.xls FIELDS artpr,codart,nombre,codprov,nomprov,costo,precvta,moneda TYPE XLS

