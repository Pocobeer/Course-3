includelib import32.lib

; ����������� ������� �� kernel32.dll
extrn ExitProcess:near
extrn GetStdHandle:near
extrn WriteConsoleA:near
extrn Sleep:near
extrn SetConsoleCursorPosition:near
extrn Beep:near
extrn GetKeyState:near
; ����������� ������� �� user32.dll
extrn GetAsyncKeyState:near

; ����������� ��������
STD_OUTPUT_HANDLE equ -11
VK_NUMLOCK equ 90h
VK_CAPITAL equ 14h
VK_SCROLL equ 91h
VK_ESCAPE equ 1Bh    ; ��� ����������� ������� ��� ESC