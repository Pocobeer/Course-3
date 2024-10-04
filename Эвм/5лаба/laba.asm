_STACK  segment para stack
        db      1024 dup(?)
_STACK  ends

data    segment
        array       dw 10, 20, 30, 40, 50, 60, 70, 80 ; Исходный массив
        count       dw 8                              ; Количество элементов
        bounds      dw 2, 6                           ; Таблица границ: min = 0, max = 7
data    ends

code    segment byte public
        assume  cs:code, ds:data, ss:_STACK

main:

        ; Инициализация сегментного регистра данных
        mov     ax, data
        mov     ds, ax
        mov ax,0
        mov es,ax
        mov bx,20
        mov word ptr es:[bx], offset my_int5
        mov es:[bx+2], cs
        ; Инициализация индекса
       mov cx,count                            ; Обнуляем cx для использования как счетчика
       .386
       mov ebx,0
        lea     bx, array                          ; Адрес исходного массива
        mov esi,0
next_element:
        mov word ptr [ebx+esi*2],"1"
        ; Проверяем, находится ли текущий индекс в пределах массива с помощью BOUND
        bound  si, dword ptr bounds                        ; Проверка границ индекса

increment_index:
        inc esi
        loop   next_element                       ; Переходим к следующему элементу

end_processing:
        ; Вывод результата
        mov     cx, count                          ; Количество элементов для вывода
        mov si, offset array
print_result:
        mov     ah, 02h                           ; Функция вывода символа
        mov     dl, [si]                           ; Загружаем байт из результирующего массива
        int     21h                                ; Вызов DOS
        add si,2                              ; Переход к следующему байту
        loop    print_result                       ; Повторяем, пока не выведем все элементы

        ; Завершение программы
        mov     ax, 4C00h                         ; Завершение программы
        int     21h                                ; Вызов DOS
        my_int5 proc
        mov word ptr [ebx+esi*2],"0"
        pop ax
        add ax, 4
        push ax ;корректирование адреса возвврата
        iret
        my_int5 endp
code    ends
end main
