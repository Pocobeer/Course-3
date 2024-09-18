include include.inc
.386
.model flat, stdcall

.const
    title_S_before db 'Before yav add:', 0
    title_S_after db 'After add:', 0
    libr db '4_kab_d.dll',0
	nameproc db 'PadCh',0

.data
    S db 5, 'qwert', 0       ; Исходная строка с длиной
    Res db 255 dup(0)        ; Буфер для результата, инициализированный нулями
    Ch1 db 'A'               ; Символ для добавления
    Len1 db 5                 ; Длина строки (должна соответствовать фактической длине)
    hlib dd ?
	PadCh dd ?

.code
start:

    call LoadLibrary,offset libr ;загрузка библиотеки
    mov hlib,eax
    call GetProcAddress,hlib,offset nameproc ;получение адреса функции
    mov PadCh,eax
    ; Вывод сообщения перед добавлением
    call MessageBox, 0, offset S, offset title_S_before, MB_OK

    ; Вызов вашей подпрограммы PadCh
    push    offset Res        ; адрес результата
    push    offset S         ; адрес строки S
    mov     al, [Ch1]        ; символ для добавления
    push    eax              ; символ
    mov     al, [Len1]       ; длина строки
    push    eax              ; длина
    call PadCh             ; вызов вашей подпрограммы

    ; Вывод сообщения после добавления
    call MessageBox, 0, offset Res, offset title_S_after, MB_OK

    ; Завершение программы
    push    0                ; код завершения
    call ExitProcess         ; завершение программы

ends
end start