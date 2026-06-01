LOCAL dolar
dolar=65
frmprevta= conectar_db(_screen.cn)
	SQLEXEC(frmprevta,"select * from articulos;","cur_artis")
	INDEX on art_codi TO SYS(2015)
	SQLEXEC(frmprevta,"select art_codi,if(moneda='D',artpro_ctovta*?dolar,artpro_ctovta) as artpro_ctovta from articulos_proveedores where art_codi>5 and prov_codi<>46 and prov_codi>0 and lista=1 order by art_codi;","tempcosto1")
	SET RELATION TO art_codi INTO cur_artis
desconectar_db(frmprevta)

GO top
x=1
SCAN FOR x<=30
	MESSAGEBOX(ALLTRIM(STR(cur_artis.art_codi))+' '+ALLTRIM(STR(tempcosto1.art_codi))+' '+ALLTRIM(cur_artis.art_desc)+' '+ALLTRIM(STR(cur_artis.art_precio,10,3))+' '+ALLTRIM(STR(tempcosto1.artpro_ctovta,10,3)))
	x=x+1
endscan

