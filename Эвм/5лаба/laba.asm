_STACK  segment para stack
        db      1024 dup(?)
_STACK  ends
 

 
data    segment
 
        array   dw  10, 20, 30, 40, 50, 60, 70, 80 ; Исходный массив
        lowIndex  dw  2                                ; Низкая граница
        highIndex dw  6                                ; Высокая граница
        count   dw  8                      ;колво элементов
        result  db 8 dup(?)                 ;массив результата
data    ends
 
code    segment byte public
        assume  cs:code, ds:data, ss:_STACK
 

main:
        ;инициализация сегментного регистра данных
        mov     ax,     data
        mov     ds,     ax

        ;инициализация индекса
        mov     cx, count          ; Количество элементов в массиве
        lea     si, array          ; Адрес исходного массива
        lea     di, result         ; Адрес результирующего массива
        mov     bx, lowIndex       ; Низкий индекс
        mov     dx, highIndex      ; Высокий индекс

        xor     cx, cx             ; Обнуляем cx для использования как счетчика
next_element:
        cmp     cx, bx             ; Сравниваем текущий индекс с низким индексом
        jb      not_in_bounds       ; Если текущий индекс меньше, переходим к not_in_bounds
        cmp     cx, dx             ; Сравниваем текущий индекс с высоким индексом
        ja      not_in_bounds      ; Если текущий индекс больше, переходим к not_in_bounds

        ; Если индекс в пределах границ
        mov     byte ptr [di], 1   ; Записываем 1 в результирующий массив
        jmp     increment_index     ; Переходим к увеличению индекса

not_in_bounds:
        mov     byte ptr [di], 0   ; Записываем 0 в результирующий массив

increment_index:
        inc     cx                  ; Увеличиваем текущий индекс
        add     di, 1               ; Переход к следующему элементу результирующего массива
        cmp     cx, count           ; Проверяем, достигли ли конца массива
        jl      next_element        ; Если нет, продолжаем цикл

    ; Вывод результата
        lea     si, result          ; Адрес результирующего массива
        mov     cx, count           ; Количество элементов для вывода

 print_result:
        mov     al, [si]           ; Загружаем байт из результирующего массива
        add     al, '0'             ; Преобразуем 0/1 в символ '0'/'1'
        mov     ah, 02h            ; Функция вывода символа
        int     21h                ; Вызов DOS
        inc     si                  ; Переход к следующему байту
        loop    print_result        ; Повторяем, пока не выведем все элементы

        ; Завершение программы
        mov     ax, 4C00h
        int     21h

code    ends
        end     main