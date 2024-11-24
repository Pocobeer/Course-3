; ���������� ������ SPP �����
PORT_BASE EQU 0x378      ; ������� ����� ����� LPT1 (SPP)
DATA_PORT EQU PORT_BASE   ; ���� ��� �������� ������
STATUS_PORT EQU PORT_BASE + 1 ; ���� �������
CONTROL_PORT EQU PORT_BASE + 2 ; ���� ����������

; ������������ ��� ������������� ������������� �����
InitParallelPort proc
    ; ������������� ��� ����� ������ � 0
    mov al, 0x00          ; �������� ������
    out DATA_PORT, al     ; ���������� 0 �� ���� ������

    ; ������������� ���������
    ret
InitParallelPort endp

; ������������ ��� ������ ������ ����� �� �������
PrintByte proc
    push ax                ; ��������� ������� AX
    push dx                ; ��������� ������� DX

    ; ��������, ���� ������� ����� �����
    Met: 
        in al, STATUS_PORT ; ������ ������ �����
        test al, 0x80      ; ��������� ��� "������� �����"
        jz Met             ; ���� �� �����, ����

    ; ��������� ���� ��� ������
    mov al, [data]        ; ��������� ���� �� ������
    out DATA_PORT, al     ; ���������� ���� �� ����

    ; ������������� (����������� ��������)
    mov al, 0x01          ; ������������� ������ ������
    out CONTROL_PORT, al   ; ���������� �� ���� ����������
    call Delay            ; ����� ��������
    mov al, 0x00          ; ���������� ������ ������
    out CONTROL_PORT, al   ; ���������� �� ���� ����������

    pop dx                 ; ��������������� ������� DX
    pop ax                 ; ��������������� ������� AX
    ret
PrintByte endp

; ������������ �������� (������)
Delay proc
    ; ������� ���� ��������
    mov cx, 0FFFFh        ; ������������� �������
DelayLoop:
    loop DelayLoop         ; ���� �� ����
    ret
Delay endp

data db 0x55              ; ������ ��� ������ (��������, 0x55)
