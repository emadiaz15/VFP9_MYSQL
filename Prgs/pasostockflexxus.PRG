close all
sele 0
use articulos
set order to art_codi
sele 0
use c:\users\administrador\desktop\saldosflexx\stockflexxus.dbf
set rela to art_codi into articulos addi
go top
brow
*!*	scan
*!*		repla articulos.art_stock with art_stock
*!*	endscan