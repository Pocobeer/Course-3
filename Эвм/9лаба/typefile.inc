includelib import32.lib

; Импортируем функции из kernel32.dll
extrn ExitProcess:near
extrn GetStdHandle:near
extrn WriteConsoleA:near
extrn Sleep:near

; Импортируем функции из user32.dll
extrn GetAsyncKeyState:near


; Импортируем функции для воспроизведения звуков
extrn PlaySoundA:near

; Определения констант
STD_OUTPUT_HANDLE equ -11
VK_NUMLOCK equ 90h
VK_CAPITAL equ 14h
VK_SCROLL equ 91h
VK_ESCAPE equ 1Bh    ; Код виртуальной клавиши для ESC