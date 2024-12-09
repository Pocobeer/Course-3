; Консольное приложение для Win32, перечисляющее сетевые ресурсы
include typefile.inc
.386
.model FLAT, STDCALL

.const
greet_message db 'Example Win32 console program', 0Dh, 0Ah, 0
error1_message db 0Dh, 0Ah, 'Could not get current user name', 0Dh, 0Ah, 0
error2_message db 0Dh, 0Ah, 'Could not enumerate', 0Dh, 0Ah, 0
good_exit_msg db 0Dh, 0Ah, 0Dh, 0Ah, 'Normal termination', 0Dh, 0Ah, 0
enum_msg1 db 0Dh, 0Ah, 'Local ', 0
enum_msg2 db ' remote - ', 0

.data
user_name db 'List of connected resources for user ', 0
user_buff db 64 dup (?); буфер для WNetGetUser
user_buff_l dd 64; размер буфера для WNetGetUser
enum_buf NTRESOURCE 256 dup (?); буфер для WNetEnumResource
enum_buf_l dd 1056; длина enum_buf в байтах
enum_entries dd 1; число ресурсов, которые в нём помещаются

.data?
enum_handle dd ?; идентификатор для WNetEnumResource
message_l dd ?; переменная для WriteConsole

.code
_start:
    ; Получим от системы идентификатор буфера вывода stdout
    push STD_OUTPUT_HANDLE
    call GetStdHandle
    mov ebx, eax ; а мы будем хранить его в EBX

    ; Выведем строку greet_message на экран
    mov esi, offset greet_message
    call output_string

    ; Определим имя пользователя, которому принадлежит наш процесс
    mov esi, offset user_buff
    push offset user_buff_l; адрес переменной с длиной буфера
    push esi; адрес буфера
    push 0; NULL
    call WNetGetUser
    cmp eax, NO_ERROR; если произошла ошибка
    jne error_exit1; выйти

    mov esi, offset user_name; иначе - выведем строку на экран
    call output_string

    ; Начнём перечисление сетевых ресурсов
    push offset enum_handle; идентификатор для WNetEnumResource
    push 0
    push RESOURCEUSAGE_CONNECTABLE; все присоединяемые ресурсы
    push RESOURCETYPE_ANY; ресурсы любого типа
    push RESOURCE_CONNECTED; только присоединённые сейчас
    call WNetOpenEnum; начать перечисление
    cmp eax, NO_ERROR; если произошла ошибка
    jne error_exit2; выйти

enumeration_loop:
    ; Цикл перечисления ресурсов
    push offset enum_buf_l; длина буфера в байтах
    push offset enum_buf; адрес буфера
    push offset enum_entries; число ресурсов
    push dword ptr enum_handle; идентификатор от WNetOpenEnum
    call WNetEnumResource
    cmp eax, ERROR_NO_MORE_ITEMS; если они закончились
    je end_enumeration; завершить перечисление
    cmp eax, NO_ERROR; если произошла ошибка
    jne error_exit2; выйти с сообщением об ошибке

    ; Вывод информации о ресурсе на экран
    mov esi, offset enum_msg1; первая часть строки
    call output_string; на консоль
    mov esi, dword ptr enum_buf.lpLocalName; локальное имя устройства
    call output_string; на консоль
    mov esi, offset enum_msg2; вторая часть строки
    call output_string; на консоль
    mov esi, dword ptr enum_buf.lpRemoteName; удалённое имя устройства
    call output_string; туда же
    jmp short enumeration_loop; продолжим перечисление

end_enumeration:
    push dword ptr enum_handle
    call WNetCloseEnum; конец перечисления
    mov esi, offset good_exit_msg

exit_program:
    call output_string; выведем строку
    push 0; код выхода
    call ExitProcess; конец программы

; Выходы после ошибок
error_exit1:
    mov esi, offset error1_message
    jmp short exit_program

error_exit2:
    mov esi, offset error2_message
    jmp short exit_program

; Процедура output_string выводит на экран строку
; Ввод: esi - адрес строки, ebx – идентификатор stdout или другого консольного буфера
output_string proc near
    cld; определим длину строки
    xor eax, eax
    mov edi, esi
    repne scasb
    dec edi
    sub edi, esi
    push 0; пошлём её на консоль
    push offset message_l; сколько байт выведено на консоль
    push edi; сколько байт надо вывести на консоль
    push esi; адрес строки для вывода на консоль
    push ebx; идентификатор буфера вывода
    call WriteConsole
    ret
output_string endp

end _start
