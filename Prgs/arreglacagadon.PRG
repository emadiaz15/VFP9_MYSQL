clos all
set dele off
sele 0
use pedidos
set order to ped_codi
sele 0
use "\\terminal-9\c$\pedauxi"
set order to ped_codi
set rela to ped_codi into pedidos addi

sele pedauxi
go top
scan for ped_codi<=23235
	repla pedidos.cli_codi with cli_codi
endscan