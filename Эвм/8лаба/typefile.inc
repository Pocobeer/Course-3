includelib import32.lib
; имена используемых функций из kernel32.dll
extrn ExitProcess:near
extrn GetCommandLineA:near
extrn CreateDirectoryA:near
extrn GetLastError:near
; присваивания для облегчения читаемости кода
GetCommandLine equ GetCommandLineA
CreateDirectory equ CreateDirectoryA
