SET LIBRARY TO "C:\VFP9_MYSQL\Prgs\librerias.prg"
nn= crear_estruc_conex_mysql("USER_CONNECT")

cn= conectar_db(nn)

SQLEXEC(cn,"select * from pedidos_articulos;","pedaux")
GO top

desconectar_db(cn)

SELECT 0
USE "f:\dho srl\pedidos_articulos.dbf"
GO top

SCAN
	cade1=ALLTRIM(STR(ped_codi))+ALLTRIM(STR(art_codi))
	cade2=ALLTRIM(STR(pedaux.ped_codi))+ALLTRIM(STR(pedaux.art_codi))
	IF cade1<>cade2
		MESSAGEBOX("PED_CODI: "+ALLTRIM(STR(ped_codi))+CHR(13)+ ;
		           "ART_CODI: "+ALLTRIM(STR(art_codi)))
		exit
	ENDIF
	SKIP IN pedaux
ENDSCAN
