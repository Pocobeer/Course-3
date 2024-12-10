; keyboard_service.asm
include typefile.inc
.386
.model FLAT, STDCALL

.data
msg db 'Key Pressed: ', 0
key_code db 0
buffer db 10 dup(0) ; Буфер для хранения кода клавиши
sound_file db 'keypress.wav', 0 ; Путь к звуковому файлу

.code
_start:
    ; Основной цикл
main_loop:
    ; Проверяем каждую клавишу от 0 до 255
    mov ecx, 256
    xor ebx, ebx ; Индекс клавиши

check_key:
    push ebx
    call GetAsyncKeyState
    test eax, 8000h ; Проверяем, нажата ли клавиша
    jz next_key

    ; Если клавиша нажата, выводим сообщение
    mov [key_code], bl
    call display_key

next_key:
    pop ebx
    inc ebx
    loop check_key

    jmp main_loop ; Повторяем цикл

; Процедура для отображения нажатой клавиши
display_key proc
    ; Формируем строку для вывода
    mov al, [key_code] ; Используем al для байта
    add al, '0' ; Преобразуем код клавиши в символ
    mov [buffer], al ; Сохраняем символ в буфер

    ; Выводим сообщение с кодом клавиши
    push MB_OK
    push offset buffer
    push offset msg
    call MessageBoxA

    ; Воспроизводим звук нажатия клавиши
    push 0 ; NULL для PlaySound
    push offset sound_file ; Путь к звуковому файлу
    push 1 ; SND_ASYNC для асинхронного воспроизведения
    call PlaySoundA

    ret
display_key endp

exit_program:
    push 0
    call ExitProcess

end _start
