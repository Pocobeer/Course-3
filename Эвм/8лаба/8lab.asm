.386
.model FLAT, STDCALL
include typefolder.inc

.data
folderName db 260 dup(0)         ; Буфер для имени папки
errorMsg db "Error creating folder.", 0

.code
_start:
    call GetCommandLine          ; Получаем командную строку
    mov esi, eax                 ; Сохраняем указатель на командную строку
    xor ecx, ecx                 ; Счетчик аргументов

parse_args:
    ; Пропускаем имя программы
    cmp byte ptr [esi], 0        ; Конец строки
    je no_folder_name            ; Если конец строки, имени папки нет
    cmp byte ptr [esi], 32       ; Пробел
    je found_arg
    inc esi
    jmp parse_args

found_arg:
    inc esi                       ; Переход к следующему символу
    cmp ecx, 0                    ; Если это первый аргумент (имя программы)
    je skip_first_arg
    inc ecx                       ; Увеличиваем счетчик аргументов
    jmp parse_args

skip_first_arg:
    cmp ecx, 1                    ; Если это второй аргумент (имя папки)
    je save_folder_name
    jmp parse_args

save_folder_name:
    lea edi, folderName           ; Указатель на буфер имени папки
    xor edx, edx                  ; Сбросим индекс для копирования

copy_name:
    cmp byte ptr [esi], 0         ; Конец строки
    je create_folder
    cmp byte ptr [esi], 32        ; Пробел
    je create_folder
    mov al, [esi]                 ; Копируем символ
    mov [edi], al
    inc esi
    inc edi
    jmp copy_name

create_folder:
    mov byte ptr [edi], 0         ; Завершаем строку нулем
    invoke CreateDirectoryA, offset folderName, 0 ; Создаем папку
    test eax, eax
    jz folder_creation_failed      ; Если результат 0, создание папки не удалось
    jmp end_

folder_creation_failed:
    invoke MessageBoxA, 0, offset errorMsg, offset errorMsg, MB_OK
    call ExitProcess, 1           ; Завершаем программу с кодом ошибки

no_folder_name:
    invoke MessageBoxA, 0, offset errorMsg, offset errorMsg, MB_OK
    call ExitProcess, 1           ; Завершаем программу с кодом ошибки

end_:
    call ExitProcess, 0           ; Завершаем программу успешно

end _start
