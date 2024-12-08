include typefile.inc      
.386                      
.model FLAT, STDCALL      
.data                     
nameout db 'CONOUT$', 0   ; Имя устройства для вывода (консоль)
folderName db 100 dup(0)  ; Буфер для имени создаваемой папки
msgSuccess db 'Folder created successfully!', 0Dh, 0Ah, 0
msgError db 'Error creating folder.', 0Dh, 0Ah, 0
msgEnd db 'Exiting program.', 0Dh, 0Ah, 0
bytesWritten dd 0         ; Количество записанных байт

.code                     
_start:                  
    call GetCommandLine   ; Получаем указатель на командную строку
    mov esi, eax          ; Сохраняем указатель на строку команд в регистре ESI
    xor ecx, ecx          ; Обнуляем счетчик параметров (ECX)
    mov edx, 1            ; Устанавливаем признак наличия параметра (EDX)
    
n1:                     
    cmp byte ptr [esi], 0 ; Проверяем конец строки
    je end_               ; Если конец строки, переходим к завершению
    cmp byte ptr [esi], 32 ; Сравниваем текущий символ с пробелом
    je n3                 ; Если пробел, переходим к обработке пробела
    add ecx, edx          ; Увеличиваем счетчик параметров (ECX)
    cmp ecx, 2            ; Проверяем, является ли это вторым параметром
    je n4                 ; Если да, переходим к копированию имени папки
    xor edx, edx          ; Обнуляем признак наличия параметра
    jmp n2                ; Переходим к следующему символу

n3:                     
    or edx, 1             ; Устанавливаем признак наличия параметра
n2:                     
    inc esi               ; Переходим к следующему символу в строке
    jmp n1                ; Возвращаемся к началу цикла

n4:                     
    ; Копируем имя папки в буфер folderName
    mov edi, offset folderName ; Устанавливаем указатель на буфер для имени папки
    mov ecx, 100           ; Устанавливаем максимальную длину копируемой строки

copy_loop:              
    cmp byte ptr [esi], 0  ; Проверяем конец строки
    je create_directory    ; Если конец строки, переходим к созданию директории
    mov al, [esi]          ; Копируем текущий символ в AL
    stosb                  ; Сохраняем символ в буфер folderName
    inc esi                ; Переходим к следующему символу в строке
    jmp copy_loop          ; Возвращаемся к началу цикла копирования

create_directory:       
    push NULL
    push offset folderName
    call CreateDirectory   ; Вызов CreateDirectory
    cmp eax, 0             ; Проверяем результат выполнения функции
    jne write_success      ; Если результат не равен нулю, значит создание успешно

    call write_message, offset msgError   ; Выводим сообщение об ошибке
    jmp write_end

write_success:          
    call write_message, offset msgSuccess ; Выводим сообщение об успешном создании

write_end:              
    call write_message, offset msgEnd     ; Выводим сообщение о завершении
end_:                  
    push 0
    call ExitProcess       ; Завершаем программу 

; Процедура для вывода сообщения
write_message proc
    push ebp
    mov ebp, esp
    pushad                 ; Сохраняем регистры

    ; Получаем дескриптор консоли
    push STD_OUTPUT_HANDLE
    call GetStdHandle
    mov ebx, eax           ; Сохраняем дескриптор

    ; Вычисляем длину строки
    mov eax, [ebp+8]       ; Адрес сообщения
    mov edx, eax
    xor ecx, ecx
find_length:
    cmp byte ptr [edx], 0  ; Конец строки?
    je write_string        ; Если 0, строка завершена
    inc edx
    inc ecx
    jmp find_length

write_string:
    push NULL              ; lpOverlapped = NULL
    push offset bytesWritten ; Адрес переменной для записанных байт
    push ecx               ; Длина строки
    push eax               ; Указатель на сообщение
    push ebx               ; Дескриптор консоли
    call WriteFile         ; Вызов WriteFile

    popad                  ; Восстанавливаем регистры
    mov esp, ebp
    pop ebp
    ret
write_message endp
end _start
