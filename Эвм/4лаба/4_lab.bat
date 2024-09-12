tasm32 /ml /l 4_kab_d.asm
tlink32 /Tpd /c 4_kab_d.obj, 4_kab_d.def
tasm32 /ml /l 4lab.asm
imlib 4_kab_d.lib 4_kab_d.dll
tlink32 /Tpe /aa /x /c 4lab.obj 
pause
td32.exe 4lab.exe
