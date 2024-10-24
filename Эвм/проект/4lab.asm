.386
.model flat, stdcall
option casemap:none

; Определение базовых типов
HANDLE equ DWORD
DWORD_PTR equ DWORD
ULONG_PTR equ DWORD

; Определение констант
NULL equ 0
TRUE equ 1
FALSE equ 0

include windows.inc
include user.inc
include kernel.inc

includelib user32.lib
includelib kernel32.lib

.data
    szMessage db "Hello, World!", 0
    szTitle db "My Message Box", 0

.code
start:
    ; Пример вызова MessageBox
    invoke MessageBox, NULL, offset szMessage, offset szTitle, MB_OK
    invoke ExitProcess, 0

end start