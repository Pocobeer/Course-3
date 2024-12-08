; Импортируем необходимые библиотеки
includelib import32.lib

; Имена используемых функций из kernel32.dll
extrn ExitProcess:near
extrn GetCommandLineA:near
extrn CreateDirectoryA:near
extrn GetLastError:near
extrn GetStdHandle:near
extrn WriteFile:near

; Присваивания для облегчения читаемости кода
GetCommandLine equ GetCommandLineA
CreateDirectory equ CreateDirectoryA

; Определение констант
STD_OUTPUT_HANDLE equ -11
NULL EQU 0                      ; Константа для NULL