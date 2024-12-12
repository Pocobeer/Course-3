.386
.model flat, stdcall
option casemap:none

include typefile.inc

.data
    msgEscPressed db "ESC pressed. Exiting...", 0
    buffer db 256 dup(0)

    ; Строки для вывода
    line1 db "CapsLock       NumPad       ScrollLock", 0
    line2 db "                                      ", 0   ; Для вывода состояния клавиш (с * или без)

    ; Координаты курсора
    cursorPositionX dw 0
    cursorPositionY dw 21

    ; Частоты для Beep
    beepFrequency dw 500    ; Частота для Beep (500 Hz)
    beepDuration dw 100     ; Длительность для Beep

.code
start:
    ; Получаем стандартный вывод
    push STD_OUTPUT_HANDLE
    call GetStdHandle
    mov esi, eax            ; Дескриптор консоли сохраняем в esi

    ; Отправляем первую строку (индикаторы)
    push 0
    push 38                ; Длина строки "CapsLock       NumPad       ScrollLock"
    push offset line1
    push esi
    call WriteConsoleA

    ; Устанавливаем курсор в начало второй строки
    mov ax, cursorPositionX
    mov bx, cursorPositionY
    push bx
    push ax
    push esi
    call SetConsoleCursorPosition

main_loop:
    ; Очищаем строку line2, устанавливая пробелы для каждого индикатора
    mov byte ptr [line2+4], 20h  ; space для CapsLock
    mov byte ptr [line2+17], 20h  ; space для NumLock
    mov byte ptr [line2+33], 20h  ; space для ScrollLock

    ; Проверка CapsLock
    push VK_CAPITAL
    call GetKeyState
    test eax, 1
    jz skip_capslock
    mov byte ptr [line2+4], '*'  ; Добавляем * если CapsLock включен
skip_capslock:

    ; Проверка NumLock
    push VK_NUMLOCK
    call GetKeyState
    test eax, 1
    jz skip_numlock
    mov byte ptr [line2+17], '*'  ; Добавляем * если NumLock включен
skip_numlock:

    ; Проверка ScrollLock
    push VK_SCROLL
    call GetKeyState
    test eax, 1
    jz skip_scrolllock
    mov byte ptr [line2+33], '*'  ; Добавляем * если ScrollLock включен
skip_scrolllock:

    ; Отправляем обновленную строку
    push 0
    push 38                ; Длина строки для line2 (50 символов)
    push offset line2
    push esi
    call WriteConsoleA

    ; Снова устанавливаем курсор в начало второй строки
    mov ax, cursorPositionX
    mov bx, cursorPositionY
    push bx
    push ax
    push esi
    call SetConsoleCursorPosition

    ; Проверяем, была ли нажата любая клавиша
    ; Проверяем CapsLock
    push VK_CAPITAL
    call GetAsyncKeyState
    test eax, 8000h
    jz skip_beep_capslock
    ; Проигрываем звук при нажатии CapsLock
    push 500       ; Частота для Beep
    push 100       ; Длительность для Beep
    call Beep
skip_beep_capslock:

    ; Проверяем NumLock
    push VK_NUMLOCK
    call GetAsyncKeyState
    test eax, 8000h
    jz skip_beep_numlock
    ; Проигрываем звук при нажатии NumLock
    push 600       ; Частота для Beep
    push 100       ; Длительность для Beep
    call Beep
skip_beep_numlock:

    ; Проверяем ScrollLock
    push VK_SCROLL
    call GetAsyncKeyState
    test eax, 8000h
    jz skip_beep_scrolllock
    ; Проигрываем звук при нажатии ScrollLock
    push 700       ; Частота для Beep
    push 100       ; Длительность для Beep
    call Beep
skip_beep_scrolllock:

    ; Проверяем ESC для выхода
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
