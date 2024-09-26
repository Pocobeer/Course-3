code    segment byte public
        assume  cs:code, ds:nothing
        public  TransformArray

; Подпрограмма TransformArray
; Преобразует массив слов в соответствии с заданными границами
; Массив: array - адрес массива слов
; Низкая граница: lowVal - низкая граница
; Высокая граница: highVal - высокая граница
; Количество элементов: count - количество элементов
TransformArray proc far
; адреса параметров в стеке:
array   equ     dword ptr [bp+10]       ; адрес массива
lowVal  equ     word  ptr [bp+8]        ; низкая граница
highVal equ     word  ptr [bp+6]        ; высокая граница
count   equ     word  ptr [bp+4]        ; количество элементов

        push    bp                      ; сохранение bp
        mov     bp,     sp              ; настройка bp на вершину стека
        push    ds                      ; сохранение ds

        les     di, [array]            ; es:di = адрес массива
        mov     cx, [count]            ; количество элементов в массиве

TransformLoop:
        cmp     cx, 0                   ; проверка на конец массива
        je      Exit                    ; если 0, выходим

        mov     ax, [es:di]             ; загружаем элемент массива в ax
        cmp     ax, [lowVal]            ; сравниваем с низкой границей
        jb      NotInBounds             ; если меньше, переходим к NotInBounds
        cmp     ax, [highVal]           ; сравниваем с высокой границей
        ja      NotInBounds             ; если больше, переходим к NotInBounds

        mov     [es:di], 1               ; если в границах, записываем 1
        jmp     NextElement

NotInBounds:
        mov     [es:di], 0               ; если не в границах, записываем 0

NextElement:
        add     di, 2                    ; переходим к следующему элементу (слово)
        dec     cx                        ; уменьшаем счетчик
        jmp     TransformLoop            ; повторяем цикл

Exit:
        pop     ds                      ; восстановление ds
        pop     bp                      ; восстановление bp
        ret     6                       ; выход с удалением параметров (low, high, count)
TransformArray endp

code    ends
        end
