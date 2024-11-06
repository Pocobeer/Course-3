includelib import32.lib
; имена используемых функций из kernel32.dll
 extrn ExitProcess:near
 extrn GetCommandLineA:near
 extrn CreateFileA:near
 extrn CloseHandle:near
 extrn ReadFile:near
extrn WriteFile:near
; присваивания для облегчения читаемости кода
 GetCommandLine equ GetCommandLineA
 CreateFile equ CreateFileA
; определения констант и типов
STD_OUTPUT_HANDLE equ -11
GENERIC_READ equ 80000000h
GENERIC_WRITE equ 40000000h
OPEN_EXISTING equ 3
