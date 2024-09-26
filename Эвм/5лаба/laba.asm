code    segment byte public
        assume  cs:code, ds:data

; Объявляем TransformArray как внешнюю подпрограмму
extrn   TransformArray:far

start:  
        ; Определение данных
        data    segment
array   dw  10, 20, 30, 40, 50, 60, 70, 80 ; Исходный массив
lowVal  dw  20                                ; Низкая граница
highVal dw  60                                ; Высокая граница
count   dw  8                                 ; Количество элементов
        data    ends

        ; Установка сегмента данных
        mov     ax, data
        mov     ds, ax

        ; Вызов подпрограммы
        push    count                        ; количество элементов
        push    highVal                     ; высокая граница
        push    lowVal                      ; низкая граница
        push    offset array                ; адрес массива
        call    TransformArray              ; вызов подпрограммы
        add     sp, 8                       ; очистка стека

        ; Завершение программы
        mov     ax, 4C00h                   ; завершение программы
        int     21h

code    ends
        end start
