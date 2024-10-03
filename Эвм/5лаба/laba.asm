_STACK  segment para stack
        db      1024 dup(?)
_STACK  ends

data    segment
        array       dw 10, 20, 30, 40, 50, 60, 70, 80 ; Исходный массив
        count       dw 8                              ; Количество элементов
        result      db 8 dup(?)                       ; Массив результата
        bounds      dw 0, 7                           ; Таблица границ: min = 0, max = 7
data    ends

code    segment byte public
        assume  cs:code, ds:data, ss:_STACK

main:
        ; Инициализация сегментного регистра данных
        mov     ax, data
        mov     ds, ax

        ; Инициализация индекса
        xor     cx, cx                             ; Обнуляем cx для использования как счетчика
        lea     si, array                          ; Адрес исходного массива
        lea     di, result                         ; Адрес результирующего массива

next_element:
        cmp     cx, count                         ; Проверяем, достигли ли конца массива
        jge     end_processing                     ; Если да, переходим к завершению

        ; Проверяем, находится ли текущий индекс в пределах массива с помощью BOUND
        mov     bx, cx                            ; Загружаем текущий индекс в bx
        bound   bx, bounds                        ; Проверка границ индекса

        ; Если индекс в пределах границ
        mov     byte ptr [di], '1'                ; Записываем '1' в результирующий массив
        jmp     increment_index                   ; Переходим к увеличению индекса

not_in_bounds:
        mov     byte ptr [di], '0'                ; Записываем '0' в результирующий массив

increment_index:
        inc     cx                                 ; Увеличиваем текущий индекс
        add     si, 2                              ; Переход к следующему элементу (2 байта для слова)
        inc     di                                 ; Переход к следующему элементу результирующего массива
        jmp     next_element                       ; Переходим к следующему элементу

end_processing:
        ; Вывод результата
        lea     si, result                         ; Адрес результирующего массива
        mov     cx, count                          ; Количество элементов для вывода

print_result:
        mov     ah, 02h                           ; Функция вывода символа
        mov     dl, [si]                           ; Загружаем байт из результирующего массива
        int     21h                                ; Вызов DOS
        inc     si                                 ; Переход к следующему байту
        loop    print_result                       ; Повторяем, пока не выведем все элементы

        ; Завершение программы
        mov     ax, 4C00h                         ; Завершение программы
        int     21h                                ; Вызов DOS
code    ends
end main
