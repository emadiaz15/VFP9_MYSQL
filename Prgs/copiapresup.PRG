close all
set talk off
set dele on
sele 0
use presupuestos
sele 0
use presupuestos_articulos
create cursor pres(cod N(8),fec D,cc N(8),ref M,ofer M,plent M,lugent M,cond M,dto N(10,2),obser M,iva N(8))
create cursor artpres(cod N(8),art N(8),precio N(10,4),cant N(10,2),dasc M,al C(1),it N(5),regis N(5),aliv N(5,2),dac N(8))
sele presupuestos
set order to presup_cod
seek 2544
if found()
	INSERT INTO pres(cod,fec,cc,ref,ofer,plent,lugent,cond,dto,obser,iva) ;
		values(presupuestos.presup_codi,presupuestos.presup_fech,presupuestos.cli_codi,presupuestos.presup_ref,presupuestos.presup_ofer,presupuestos.presup_plent,presupuestos.presup_lugent,presupuestos.presup_cond,presupuestos.presup_dto,presupuestos.presup_obser,presupuestos.iva_codi)
endif
sele presupuestos_articulos
set order to presup_cod
seek 2544
if found()
	scan for presup_codi=2544
		insert into artpres(cod ,art ,precio ,cant ,dasc ,al ,it ,regis ,aliv ,dac ) ;
		   values(presupuestos_articulos.presup_codi,presupuestos_articulos.art_codi, ;
		          presupuestos_articulos.artpres_precio,presupuestos_articulos.artpres_cant, ;
		          presupuestos_articulos.artpres_dasc,presupuestos_articulos.alternativa, ;
		          presupuestos_articulos.nro_it,presupuestos_articulos.nro_regis, ;
		          presupuestos_articulos.alter_iva,presupuestos_articulos.dac_codi)
	endscan
endif
sele presupuestos
set order to presup_cod
set reprocess to automatic
if flock()
	go bott
	codi=presup_codi+1
	appe blank
	repla presup_codi with codi
	sele pres
	repla presupuestos.presup_fech with fec
	repla presupuestos.cli_codi with cc
	repla presupuestos.presup_ref with ref
	repla presupuestos.presup_ofer with ofer
	repla presupuestos.presup_plent with plent
	repla presupuestos.presup_lugent with lugent
	repla presupuestos.presup_cond with cond
	repla presupuestos.presup_dto with dto
	repla presupuestos.presup_obser with obser
	repla presupuestos.iva_codi with iva
	sele presupuestos_articulos
	set order to presup_cod
	sele artpres
	go top
	scan
		sele presupuestos_articulos
		appe blank
		repla presup_codi with codi
		repla art_codi with artpres.art
		repla artpres_precio with artpres.precio
		repla artpres_cant with artpres.cant
		repla artpres_dasc with artpres.dasc
		repla alternativa with artpres.al
		repla nro_it with artpres.it
		repla nro_regis with artpres.regis
		repla alter_iva with artpres.aliv
		repla dac_codi with artpres.dac
		sele artpres
	endscan
endif
unlock
