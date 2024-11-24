; Определяем адреса SPP порта
PORT_BASE EQU 0x378      ; Базовый адрес порта LPT1 (SPP)
DATA_PORT EQU PORT_BASE   ; Порт для передачи данных
STATUS_PORT EQU PORT_BASE + 1 ; Порт статуса
CONTROL_PORT EQU PORT_BASE + 2 ; Порт управления

; Подпрограмма для инициализации параллельного порта
InitParallelPort proc
    ; Устанавливаем все линии данных в 0
    mov al, 0x00          ; Обнуляем данные
    out DATA_PORT, al     ; Отправляем 0 на порт данных

    ; Инициализация завершена
    ret
InitParallelPort endp

; Подпрограмма для вывода одного байта на принтер
PrintByte proc
    push ax                ; Сохраняем регистр AX
    push dx                ; Сохраняем регистр DX

    ; Ожидание, пока принтер будет готов
    Met: 
        in al, STATUS_PORT ; Читаем статус порта
        test al, 0x80      ; Проверяем бит "Принтер готов"
        jz Met             ; Если не готов, ждем

    ; Загружаем байт для печати
    mov al, [data]        ; Загружаем байт из памяти
    out DATA_PORT, al     ; Отправляем байт на порт

    ; Стробирование (уведомление принтера)
    mov al, 0x01          ; Устанавливаем сигнал строба
    out CONTROL_PORT, al   ; Отправляем на порт управления
    call Delay            ; Вызов задержки
    mov al, 0x00          ; Сбрасываем сигнал строба
    out CONTROL_PORT, al   ; Сбрасываем на порт управления

    pop dx                 ; Восстанавливаем регистр DX
    pop ax                 ; Восстанавливаем регистр AX
    ret
PrintByte endp

; Подпрограмма задержки (пример)
Delay proc
    ; Простой цикл задержки
    mov cx, 0FFFFh        ; Устанавливаем счетчик
DelayLoop:
    loop DelayLoop         ; Цикл до нуля
    ret
Delay endp

data db 0x55              ; Данные для печати (например, 0x55)
