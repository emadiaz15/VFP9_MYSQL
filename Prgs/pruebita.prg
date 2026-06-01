close all
sele 0
use histocosto
set order to histo_codi
can=reccount()
=messagebox(str(can))
go top
i=1
do while i<=can
	repla histo_codi with i
	i=i+1
	if !eof()
		skip
	endif
enddo	
