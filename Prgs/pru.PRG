close all
sele 0
use clientes
set order to cli_codi
*sele 0
*use iva
*set order to iva_codi
sele 0
use recibos
set order to rec_codi
set rela to cli_codi into clientes addi
*set rela to iva_codi into iva addi
go top
scan
*	=messagebox(allt(str(clientes.cli_codi))+"   "+clientes.cli_nomb+"   "+allt(str(clientes.cli_saldo,10,2)))
*	repla clientes.cli_saldo with clientes.cli_saldo+(fac_tot*iif(altiva_1=0,(iva.iva_1/100)+1,(altiva_1/100)+1))
	repla clientes.cli_saldo with clientes.cli_saldo-rec_impo
endscan