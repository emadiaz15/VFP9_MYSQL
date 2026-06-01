use in clientes
use in saldosiniciales
sele 0
use clientes
set order to cli_codi
sele 0
use saldosiniciales
set rela to cli_codi into clientes addi
go top
scan
	if cli_codi=1491
		skip
		loop
	endif
	repla clientes.cli_saldo with clientes.cli_saldo+(cli_sal-sini_pag)
endscan