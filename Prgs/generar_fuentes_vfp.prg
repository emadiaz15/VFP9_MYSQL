*=========================================================
* generar_fuentes_vfp.prg
* - Genera fuentes textuales del proyecto VFP9 usando FoxBin2Prg
*
* Convierte:
*   Formularios: SCX/SCT -> SC2
*   Clases:      VCX/VCT -> VC2
*   Reportes:    FRX/FRT -> FR2
*   Menús:       MNX/MNT -> MN2
*   Proyectos:   PJX/PJT -> PJ2
*   Labels:      LBX/LBT -> LB2
*
* No convierte:
*   DBF/FPT/CDX operativos
*   INI reales
*   EXE/DLL/APP
*
* Ruta recomendada:
*   C:\VFP9_MYSQL\Prgs\generar_fuentes_vfp.prg
*=========================================================

CLEAR

LOCAL lcBase
LOCAL lcFoxBin
LOCAL lcFoxBinDir
LOCAL lcLogDir
LOCAL lcLogFile
LOCAL lcFechaHora
LOCAL lcOldDir
LOCAL lnErrores

lcBase      = "C:\VFP9_MYSQL"
lcFoxBinDir = lcBase + "\tools\foxbin2prg-master"
lcFoxBin    = lcFoxBinDir + "\foxbin2prg.prg"
lcLogDir    = lcBase + "\logs"
lcLogFile   = lcLogDir + "\generar_fuentes_vfp.log"

lnErrores = 0

lcFechaHora = DTOC(DATE()) + " " + TIME()
lcOldDir    = SYS(5) + CURDIR()

SET SAFETY OFF
SET TALK OFF
SET DELETED ON
SET EXCLUSIVE OFF
SET EXACT OFF
SET CONSOLE OFF

*=========================================================
* VALIDACIONES INICIALES
*=========================================================

IF !DIRECTORY(lcBase)
	MESSAGEBOX( ;
		"No existe la carpeta base:" + CHR(13) + ;
		lcBase, ;
		16, ;
		"Generar fuentes VFP" ;
	)
	RETURN .F.
ENDIF

IF !DIRECTORY(lcFoxBinDir)
	MESSAGEBOX( ;
		"No existe la carpeta de FoxBin2Prg:" + CHR(13) + ;
		lcFoxBinDir, ;
		16, ;
		"Generar fuentes VFP" ;
	)
	RETURN .F.
ENDIF

IF !FILE(lcFoxBin)
	MESSAGEBOX( ;
		"No existe FoxBin2Prg:" + CHR(13) + ;
		lcFoxBin, ;
		16, ;
		"Generar fuentes VFP" ;
	)
	RETURN .F.
ENDIF

IF !DIRECTORY(lcLogDir)
	MKDIR (lcLogDir)
ENDIF

*=========================================================
* INICIAR LOG
*=========================================================

STRTOFILE( ;
	"=========================================================" + CHR(13) + ;
	"GENERAR FUENTES VFP9 CON FOXBIN2PRG" + CHR(13) + ;
	"Fecha/Hora: " + lcFechaHora + CHR(13) + ;
	"Base: " + lcBase + CHR(13) + ;
	"FoxBin2Prg: " + lcFoxBin + CHR(13) + ;
	"=========================================================" + CHR(13), ;
	lcLogFile, ;
	0 ;
)

*=========================================================
* CAMBIAR A CARPETA FOXBIN2PRG
*=========================================================

CD (lcFoxBinDir)

*=========================================================
* FORMULARIOS
*=========================================================

STRTOFILE("Procesando Formularios..." + CHR(13), lcLogFile, 1)
WAIT WINDOW "Generando fuentes: Formularios..." NOWAIT

IF DIRECTORY(lcBase + "\Formularios")
	DO (lcFoxBin) WITH lcBase + "\Formularios", "BIN2PRG"
	STRTOFILE("OK Formularios" + CHR(13), lcLogFile, 1)
ELSE
	lnErrores = lnErrores + 1
	STRTOFILE("ERROR: No existe carpeta Formularios" + CHR(13), lcLogFile, 1)
ENDIF

*=========================================================
* CLASES
*=========================================================

STRTOFILE("Procesando Clases..." + CHR(13), lcLogFile, 1)
WAIT WINDOW "Generando fuentes: Clases..." NOWAIT

IF DIRECTORY(lcBase + "\Clases")
	DO (lcFoxBin) WITH lcBase + "\Clases", "BIN2PRG"
	STRTOFILE("OK Clases" + CHR(13), lcLogFile, 1)
ELSE
	lnErrores = lnErrores + 1
	STRTOFILE("ERROR: No existe carpeta Clases" + CHR(13), lcLogFile, 1)
ENDIF

*=========================================================
* REPORTES
*=========================================================

STRTOFILE("Procesando Reportes..." + CHR(13), lcLogFile, 1)
WAIT WINDOW "Generando fuentes: Reportes..." NOWAIT

IF DIRECTORY(lcBase + "\Reportes")
	DO (lcFoxBin) WITH lcBase + "\Reportes", "BIN2PRG"
	STRTOFILE("OK Reportes" + CHR(13), lcLogFile, 1)
ELSE
	lnErrores = lnErrores + 1
	STRTOFILE("ERROR: No existe carpeta Reportes" + CHR(13), lcLogFile, 1)
ENDIF

*=========================================================
* RAÍZ DEL PROYECTO
* - Menús MNX/MNT -> MN2
* - Proyectos PJX/PJT -> PJ2
* - Labels LBX/LBT -> LB2 si hay en raíz
*=========================================================

STRTOFILE("Procesando raíz del proyecto para Menús / Proyectos / Labels..." + CHR(13), lcLogFile, 1)
WAIT WINDOW "Generando fuentes: Menús / Proyectos / Labels..." NOWAIT

DO (lcFoxBin) WITH lcBase, "BIN2PRG"
STRTOFILE("OK raíz del proyecto" + CHR(13), lcLogFile, 1)

*=========================================================
* FACTELEC
* - Subproyecto adicional si existe
*=========================================================

IF DIRECTORY(lcBase + "\Factelec")
	STRTOFILE("Procesando Factelec..." + CHR(13), lcLogFile, 1)
	WAIT WINDOW "Generando fuentes: Factelec..." NOWAIT

	DO (lcFoxBin) WITH lcBase + "\Factelec", "BIN2PRG"

	STRTOFILE("OK Factelec" + CHR(13), lcLogFile, 1)
ENDIF

*=========================================================
* DOCUMENTAR ARCHIVOS TEXTUALES DIRECTOS
*=========================================================

STRTOFILE( ;
	CHR(13) + ;
	"Archivos textuales que Git versiona directo, sin conversión:" + CHR(13) + ;
	"- PRG" + CHR(13) + ;
	"- MPR" + CHR(13) + ;
	"- H" + CHR(13) + ;
	"- TXT" + CHR(13) + ;
	"- SQL" + CHR(13) + ;
	"- BAT" + CHR(13) + ;
	"- CFG" + CHR(13) + ;
	"- FPW" + CHR(13), ;
	lcLogFile, ;
	1 ;
)

*=========================================================
* FINALIZAR LOG
*=========================================================

STRTOFILE( ;
	CHR(13) + ;
	"Finalizado: " + DTOC(DATE()) + " " + TIME() + CHR(13) + ;
	"Errores internos del PRG: " + TRANSFORM(lnErrores) + CHR(13) + ;
	"=========================================================" + CHR(13), ;
	lcLogFile, ;
	1 ;
)

WAIT CLEAR

*=========================================================
* VOLVER A CARPETA ORIGINAL
*=========================================================

IF DIRECTORY(lcOldDir)
	CD (lcOldDir)
ELSE
	CD (lcBase)
ENDIF

*=========================================================
* RESULTADO FINAL
*=========================================================

IF lnErrores > 0
	MESSAGEBOX( ;
		"Generación finalizada con advertencias." + CHR(13) + CHR(13) + ;
		"Log:" + CHR(13) + ;
		lcLogFile, ;
		48, ;
		"Generar fuentes VFP" ;
	)
	RETURN .F.
ELSE
	MESSAGEBOX( ;
		"Generación de fuentes VFP finalizada correctamente." + CHR(13) + CHR(13) + ;
		"Generados esperados:" + CHR(13) + ;
		"- Formularios: *.sc2" + CHR(13) + ;
		"- Clases: *.vc2" + CHR(13) + ;
		"- Reportes: *.fr2" + CHR(13) + ;
		"- Menús: *.mn2" + CHR(13) + ;
		"- Proyectos: *.pj2" + CHR(13) + ;
		"- Labels: *.lb2" + CHR(13) + CHR(13) + ;
		"Log:" + CHR(13) + ;
		lcLogFile, ;
		64, ;
		"Generar fuentes VFP" ;
	)
	RETURN .T.
ENDIF