_STACK  segment para stack
        db      1024 dup(?)
_STACK  ends
 

 
data    segment
 
        S db 5, 'qwert'
        Res   db      0, 255 dup('$')
 
        Ch1     db      'A'
        Len1    db      10
 
data    ends
 
code    segment byte public
        assume  cs:code, ds:data, ss:_STACK
 
        extrn   PadCh:far

main:
        ;инициализация сегментного регистра данных
        mov     ax,     data
        mov     ds,     ax
 
        push ds
        mov ax, offset Res
        push ax
        push ds
        mov ax, offset S
        push ax
        mov al, Ch1
        push ax
        mov al, [Len1]
        push ax
        call PadCh
        mov dx, offset Res+1
        mov ah, 9
        int 21h
 
        ;завершение программы
        mov     ax,     4C00h
        int     21h
 
code    ends
 
        end     main