; Программа для проверки нажатия клавиш
.386
.model flat, stdcall
option casemap:none

include typefile.inc

.data
    msgStart db "Start.", 0
    msgStartLen equ $ - msgStart
    msgPressed db "Button pressed: ", 0
    msgEscPressed db "ESC pressed. Exiting...", 0
    msgNoKeyPressed db "No key pressed.", 0
    buffer db 256 dup(0)

.code
start:
    ; Получаем стандартный вывод
    push STD_OUTPUT_HANDLE
    call GetStdHandle

    ; Отправляем сообщение о запуске программы
    push msgStartLen
    push offset msgStart
    push eax
    call WriteConsoleA

    ; Основной цикл программы
main_loop:
    ; Проверяем состояние клавиш от 0 до 255
    mov ecx, 256      ; Устанавливаем счетчик на 256
    xor ebx, ebx      ; Счетчик клавиш

check_keys:
    push ebx          ; Сохраняем индекс клавиши
    call GetAsyncKeyState ; Получаем состояние клавиши
    test eax, 8000h   ; Проверяем, нажата ли клавиша
    jz next_key       ; Если не нажата, переходим к следующей клавише

    ; Если клавиша нажата, выводим сообщение
    push ebx          ; Копируем индекс клавиши для вывода
    call KeyToString  ; Преобразуем код клавиши в строку
    push eax          ; Строка с кодом клавиши в стеке
    push offset msgPressed
    call WriteConsoleA

    ; Проверяем, нажата ли клавиша ESC (код 27)
    cmp ebx, 1Bh      ; Код клавиши ESC
    je exit_program    ; Если нажата ESC, выходим

next_key:
    pop ebx           ; Восстанавливаем индекс клавиши
    inc ebx           ; Переходим к следующей клавише
    loop check_keys   ; Цикл по всем клавишам

    ; Если ни одна клавиша не нажата, выводим сообщение
    push offset msgNoKeyPressed
    call WriteConsoleA

    ; Задержка перед следующей проверкой
    push 100          ; Задержка 100 миллисекунд
    call Sleep

    ; Возвращаемся к началу цикла
    jmp main_loop

exit_program:
    push offset msgEscPressed
    call WriteConsoleA  ; Выводим сообщение о выходе
    push 0            ; Код выхода
    call ExitProcess   ; Завершение программы

KeyToString:
    ; Преобразование кода клавиши в строку
    ; Для простоты просто возвращаем код в строковом формате
    mov eax, ebx      ; Копируем индекс клавиши в eax
    call itoa         ; Преобразуем число в строку
    ret

itoa:
    ; Преобразование числа в строку
    ; Реализуйте свою логику преобразования
    lea eax, buffer   ; Возвращаем адрес буфера
    ret

end start
