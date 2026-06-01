cn= conectar_db(_screen.cn)
	SQLEXEC(cn,"select a.* from pedidos a inner join clientes b on a.cli_codi=b.cli_codi where b.zona_codi<>10 order by a.ped_codi desc;","cur_ped")
	INDEX on ped_codi to xcp
	INDEX on cli_codi TO xpcc
	SQLEXEC(cn,"select * from clientes order by cli_codi;","cur_clie")
	INDEX on cli_codi to xcc
	SQLEXEC(cn,"select a.* from facturas a inner join clientes b on a.cli_codi=b.cli_codi where a.fac_codi>=48074 and b.zona_codi<>10 order by a.fac_codi;","cur_fac")
	INDEX on fac_codi to xfc
	SQLEXEC(cn,"select * from facturas_articulos where fac_codi>=48074 order by fac_codi;","cur_facar")
	INDEX on fac_codi to xfac
	SQLEXEC(cn,"select * from pedidos_articulos order by ped_codi;","cur_pedar")
	INDEX on ped_codi to xcpa
	SQLEXEC(cn,"select * from articulos order by art_codi;","cur_art1")
	INDEX on art_codi to xar1
	SQLEXEC(cn,"select * from articulos order by art_codi;","cur_art2")
	INDEX on art_codi to xar2
desconectar_db(cn)

SELECT cur_ped
SET RELATION TO ped_codi INTO cur_pedar addi
SET RELATION TO cli_codi INTO cur_clie  addi

SELECT cur_pedar
SET RELATION TO art_codi INTO cur_art2 addi

SELECT cur_fac
SET RELATION TO fac_codi INTO cur_facar addi
*!*	SET RELATION TO cli_codi INTO cur_clie  addi
SET RELATION TO cli_codi INTO cur_ped   addi

SELECT cur_facar
SET RELATION TO art_codi INTO cur_art1 addi

SELECT cur_fac
BROWSE nowait
SELECT cur_facar
BROWSE nowait
SELECT cur_ped
BROWSE nowait
SELECT cur_pedar
BROWSE nowait
SELECT cur_clie
BROWSE nowait
SELECT cur_art1
BROWSE nowait
SELECT cur_art2
BROWSE nowait
