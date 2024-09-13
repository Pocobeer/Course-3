tasm32 /ml /l 4_kab_d.asm
pause
tlink32 /Tpd /c 4_kab_d.obj,,,, 4_kab_d.def
pause
implib 4_kab_d.lib 4_kab_d.dll
pause
tasm32 /ml /l 4lab.asm
pause
tlink32 /Tpe /aa /x /c 4lab.obj 
pause
td32.exe 4lab.exe
