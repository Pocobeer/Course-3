; Консольное приложение, создающее папку
include typefile.inc
.386
.model FLAT,STDCALL
.data
hfile dd ?
buf db 100 dup(0)
nameout db 'CONOUT$'
folderName db 100 dup(0) ; буфер для имени папки
.code
_start: 
    call GetCommandLine ; получить указатель на командную строку
    mov esi, eax        ; сохранить указатель на строку
    xor ecx, ecx       ; счетчик
    mov edx, 1         ; признак
    
n1: 
    cmp byte ptr [esi], 0 ; конец строки
    je end_                ; нет параметра
    cmp byte ptr [esi], 32 ; пробел
    je n3
    add ecx, edx
    cmp ecx, 2             ; Первый параметр – имя программы.
    je n4
    xor edx, edx
    jmp n2
n3: 
    or edx, 1
n2: 
    inc esi
    jmp n1

n4: 
    ; Копируем имя папки в буфер folderName
    mov edi, offset folderName
    mov ecx, 100           ; максимальная длина
copy_loop:
    cmp byte ptr [esi], 0  ; конец строки
    je create_directory
    mov al, [esi]          ; копируем символ
    stosb                  ; сохраняем в folderName
    inc esi
    jmp copy_loop

create_directory:
    ; Создаем директорию
    call CreateDirectory, offset folderName, 0
    cmp eax, 0            ; проверка на успех
    jne success

    ; Если создание директории не удалось, получаем ошибку
    call GetLastError
    ; Здесь можно добавить обработку ошибки, например, вывести код ошибки на консоль
    jmp end_

success:
    ; Успешно создана папка (можно добавить сообщение об успехе)

end_: 
    call ExitProcess, 0
end _start
