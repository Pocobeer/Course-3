includelib import32.lib
extrn GetCommandLineA:near
extrn CreateDirectoryA:near
extrn ExitProcess:near
extrn WriteFile:near
extrn lstrlenA:near
extrn GetStdHandle:near

GetCommandLine equ GetCommandLineA
CreateDirectory equ CreateDirectoryA
lstrlen equ lstrlenA
STD_OUTPUT_HANDLE equ -11
