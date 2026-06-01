if presupuestos_articulos.artpres_cant>articulos.art_stock-articulos.pedidos
	do case
		case articulos.art_med="UN"
			cadena="artículos"
		case articulos.art_med="MT"
			cadena="metros"
		case articulos.art_med="KG"
			cadena="kilogramos"
		endcase
 		stins=articulos.art_stock-articulos.pedidos
		pendiente=messagebox("No hay stock suficiente de "+allt(articulos.art_desc)+" ¿Genera Pedido Pendiente"+ ;
		    		         " por "+allt(str(presupuestos_articulos.artpres_cant-stins,10,2))+" "+cadena+"?",4+32+256,"Stock Insuficiente!!!")
		if pendiente=6
			if si=1
				sele pedidospendientes
				set order to pend_codi
				go bott
				pend=pend_codi+1
				appe blank
				repla pend_codi with pend
				repla pend_fecha with date()
				repla cli_codi with codicli
				repla ped_codi with this.text7.value
				si=0
			endif
			sele pedidospendientes_articulos
			appe blank
			repla pend_codi with pend
			repla art_codi with articulos.art_codi
			repla artpend_cant with presupuestos_articulos.artpres_cant-stins
		endif
	endif	
endif