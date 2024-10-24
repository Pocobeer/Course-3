tasm32 /ml /l 4lab.asm
pause
tlink32 /Tpe /aa /x /c 4lab.obj 
pause
td32.exe 4lab.exe
