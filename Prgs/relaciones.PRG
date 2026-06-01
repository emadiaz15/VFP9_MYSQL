sele 0
use articulos
set order to art_codi
sele 0
use articulos_proveedores
set order to artprov
set rela to art_codi into articulos addi
set filter to prov_codi=1
sele articulos_proveedores
brow nowait
sele articulos
brow nowait
sele 0
use histocosto
set order to artpro_cod
sele articulos_proveedores
set rela to artpro_codi into histocosto addi
sele histocosto
brow nowait
