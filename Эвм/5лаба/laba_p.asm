code    segment byte public
        assume  cs:code, ds:nothing
        public  TransformArray

; ������������ TransformArray
; ����������� ������ ���� � ������������ � ��������� ���������
; ������: array - ����� ������� ����
; ������ �������: lowVal - ������ �������
; ������� �������: highVal - ������� �������
; ���������� ���������: count - ���������� ���������
TransformArray proc far
; ������ ���������� � �����:
array   equ     dword ptr [bp+10]       ; ����� �������
lowVal  equ     word  ptr [bp+8]        ; ������ �������
highVal equ     word  ptr [bp+6]        ; ������� �������
count   equ     word  ptr [bp+4]        ; ���������� ���������

        push    bp                      ; ���������� bp
        mov     bp,     sp              ; ��������� bp �� ������� �����
        push    ds                      ; ���������� ds

        les     di, [array]            ; es:di = ����� �������
        mov     cx, [count]            ; ���������� ��������� � �������

TransformLoop:
        cmp     cx, 0                   ; �������� �� ����� �������
        je      Exit                    ; ���� 0, �������

        mov     ax, [es:di]             ; ��������� ������� ������� � ax
        cmp     ax, [lowVal]            ; ���������� � ������ ��������
        jb      NotInBounds             ; ���� ������, ��������� � NotInBounds
        cmp     ax, [highVal]           ; ���������� � ������� ��������
        ja      NotInBounds             ; ���� ������, ��������� � NotInBounds

        mov     [es:di], 1               ; ���� � ��������, ���������� 1
        jmp     NextElement

NotInBounds:
        mov     [es:di], 0               ; ���� �� � ��������, ���������� 0

NextElement:
        add     di, 2                    ; ��������� � ���������� �������� (�����)
        dec     cx                        ; ��������� �������
        jmp     TransformLoop            ; ��������� ����

Exit:
        pop     ds                      ; �������������� ds
        pop     bp                      ; �������������� bp
        ret     6                       ; ����� � ��������� ���������� (low, high, count)
TransformArray endp

code    ends
        end
