_STACK  segment para stack
        db      1024 dup(?)
_STACK  ends

data    segment
        ;array       db "Hello!g" , "$"; �������� ������
        array       dw 10, 20, 30, 40, 50, 60, 70, 80 ; �������� ������
        lowIndex    dw 3                              ; ������ �������
        highIndex   dw 6                                ; ������� �������
        count       dw 8                                ; ���������� ���������
        result      db 8 dup(?)                         ; ������ ����������
data    ends

code    segment byte public
        assume  cs:code, ds:data, ss:_STACK

main:
        ; ������������� ����������� �������� ������
        mov     ax, data
        mov     ds, ax

        ; ������������� �������
        mov     cx, count          ; ���������� ��������� � �������
        lea     si, array          ; ����� ��������� �������
        lea     di, result         ; ����� ��������������� �������
        mov     bx, lowIndex       ; ������ ������
        mov     dx, highIndex      ; ������� ������

        xor     cx, cx             ; �������� cx ��� ������������� ��� ��������
next_element:
        cmp     cx, bx             ; ���������� ������� ������ � ������ ��������
        jb      not_in_bounds       ; ���� ������� ������ ������, ��������� � not_in_bounds
        cmp     cx, dx             ; ���������� ������� ������ � ������� ��������
        ja      not_in_bounds      ; ���� ������� ������ ������, ��������� � not_in_bounds

        ; ���� ������ � �������� ������
        mov     byte ptr [di], "1"   ; ���������� 1 � �������������� ������
        jmp     increment_index     ; ��������� � ���������� �������

not_in_bounds:
        mov     byte ptr [di], "0"   ; ���������� 0 � �������������� ������

increment_index:
        inc     cx                  ; ����������� ������� ������
        add     di, 1               ; ������� � ���������� �������� ��������������� �������
        cmp     cx, count           ; ���������, �������� �� ����� �������
        jl      next_element        ; ���� ���, ���������� ����

; ����� ����������
lea     si, result              ; ����� ��������������� �������
mov     cx, count               ; ���������� ��������� ��� ������

;print_result:
;    mov     al, [si]            ; ��������� ���� �� ��������������� �������
;    add     al, '0'             ; ����������� 0/1 � ������ '0'/'1'
;    mov     ah, 02h             ; ������� ������ �������
;    int     21h                 ; ����� DOS
;    inc     si                   ; ������� � ���������� �����
;    loop    print_result         ; ���������, ���� �� ������� ��� 
    
print_result:
        
        mov dx, offset si
        mov ah, 09h
        int 21h

        mov ax, "$"
        mov dx, ax
        mov ah, 09h
        int 21h

; ; ������� ������
; mov     ah, 02h                 ; ������� ������ �������
; mov     dl, 0Dh                 ; ������ �������� �������
; int     21h                     ; ����� DOS
; mov     dl, 0Ah                 ; ������ ����� ������
; int     21h                     ; ����� DOS

        ; ���������� ���������
        mov     ax, 4C00h        ; ���������� ���������
        int     21h              ; ����� DOS
code    ends
end main