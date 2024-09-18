tasm32 /ml /l 4_kab_d.asm
pause
tlink32 /Tpd /c 4_kab_d.obj,,,, 4_kab_d.def
pause
implib 4_kab_d.lib 4_kab_d.dll
pause
tasm32 /ml /l 4labYav.asm
pause
tlink32 /Tpe /aa /x /c 4labYav.obj 
pause
td32.exe 4labYav.exe
