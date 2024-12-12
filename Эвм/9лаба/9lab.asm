.386
.model flat, stdcall
option casemap:none

include typefile.inc

.data
    msgStart db "Program started.", 0
    msgNumLock db "NumLock is pressed.", 0
    msgCapsLock db "CapsLock is pressed.", 0
    msgScrollLock db "ScrollLock is pressed.", 0
    msgEscPressed db "ESC pressed. Exiting...", 0
    buffer db 256 dup(0)

.code
start:
    ; Получаем стандартный вывод
    push STD_OUTPUT_HANDLE
    call GetStdHandle
    mov esi, eax

    ; Отправляем сообщение о запуске программы
    push 0
    push 17                 ; Длина строки msgStart
    push offset msgStart
    push esi
    call WriteConsoleA

main_loop:
    ; Проверяем состояние клавиш
    push VK_NUMLOCK
    call GetAsyncKeyState
    test eax, 8000h
    jz check_capslock
    push 0
    push 20                 ; Длина строки msgNumLock
    push offset msgNumLock
    push esi
    call WriteConsoleA

check_capslock:
    push VK_CAPITAL
    call GetAsyncKeyState
    test eax, 8000h
    jz check_scrolllock
    push 0
    push 21                 ; Длина строки msgCapsLock
    push offset msgCapsLock
    push esi
    call WriteConsoleA

check_scrolllock:
    push VK_SCROLL
    call GetAsyncKeyState
    test eax, 8000h
    jz check_esc
    push 0
    push 22                 ; Длина строки msgScrollLock
    push offset msgScrollLock
    push esi
    call WriteConsoleA

check_esc:
    push VK_ESCAPE
    call GetAsyncKeyState
    test eax, 8000h
    jnz exit_program

    ; Небольшая задержка для снижения нагрузки на процессор
    push 100
    call Sleep
    jmp main_loop

exit_program:
    push 0
    push 27                 ; Длина строки msgEscPressed
    push offset msgEscPressed
    push esi
    call WriteConsoleA
    push 0
    call ExitProcess

end start
