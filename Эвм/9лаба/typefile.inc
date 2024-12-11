includelib import32.lib

; Импортируем функции из kernel32.dll и user32.dll
extrn ExitProcess:near
extrn GetAsyncKeyState:near
extrn MessageBeep:near
extrn Sleep:near  ; Импортируем функцию Sleep
extrn OutputDebugStringA:near  ; Импортируем функцию OutputDebugStringA
extrn WriteConsoleA:near  ; Импортируем функцию WriteConsoleA
extrn GetStdHandle:near

; Определения констант
STD_OUTPUT_HANDLE equ -11
VK_NUMLOCK equ 144
VK_CAPITAL equ 20h
VK_SCROLL equ 91h