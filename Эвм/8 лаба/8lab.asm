.386
.model FLAT, STDCALL
include typefolder.inc

.data
folderName db 260 dup(0)         ; Буфер для имени папки

.code
_start:
    call GetStdHandle, STD_OUTPUT_HANDLE
    call GetCommandLine          ; Получаем командную строку
    mov esi, eax                 ; Сохраняем указатель на командную строку
    xor ecx, ecx                 ; Счетчик
    xor edx, edx                 ; Признак

parse_args:
    cmp byte ptr [esi], 0        ; Конец строки
    je no_folder_name            ; Если конец строки, имени папки нет
    cmp byte ptr [esi], 32       ; Пробел
    je found_arg
    add ecx, 1
    cmp ecx, 2                   ; Первый параметр - имя программы, второй - имя папки
    je save_folder_name
    inc esi
    jmp parse_args

found_arg:
    inc esi
    jmp parse_args

save_folder_name:
    lea edi, folderName          ; Указатель на буфер имени папки

copy_name:
    cmp byte ptr [esi], 0        ; Конец строки
    je create_folder
    cmp byte ptr [esi], 32       ; Пробел
    je create_folder
    mov al, [esi]                ; Копируем символ
    mov [edi], al
    inc esi
    inc edi
    jmp copy_name

create_folder:
    call CreateDirectory, offset folderName, 0 ; Создаем папку
    test eax, eax
    jmp end_

no_folder_name:
    call ExitProcess, 1          ; Завершаем программу с кодом ошибки

end_:
    call ExitProcess, 0          ; Завершаем программу успешно

end _start
