close all
sele 0
use articulos_proveedores
set order to art_codi
set filter to prov_codi=1
sele 0
use compras_articulos
set filter to orden_codi=8767
set order to art_codi
set rela to art_codi into articulos_proveedores addi
sele articulos_proveedores
sele compras_articulos
go top
scan
	repla artord_precio with articulos_proveedores.artpro_costo*0.95/1.14
endscan
go top
brow
