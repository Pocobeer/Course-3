;includelib kernel32.lib
includelib user32.lib
includelib winmm.lib ; Библиотека для воспроизведения звуков

; Импортируем функции из kernel32.dll
extrn ExitProcess:near

; Импортируем функции из user32.dll
extrn GetAsyncKeyState:near
extrn MessageBoxA:near

; Импортируем функции для воспроизведения звуков
extrn PlaySoundA:near

; Определения констант
MB_OK equ 0