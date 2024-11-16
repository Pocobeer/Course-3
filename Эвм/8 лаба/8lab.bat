tasm32 /ml /l 8lab.asm
pause
tlink32 /Tpe /ap /x /c 8lab.obj 
pause
td32 8lab.exe