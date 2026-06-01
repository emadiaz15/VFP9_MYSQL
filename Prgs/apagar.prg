FUNCTION ApagarEquipo(tnEquipo)
	Declare Integer ExitWindowsEx in "user32.dll" Integer uFlags, Integer dwReserved 
	ExitWindowsEx(tnEquipo, 0)
ENDFUNC