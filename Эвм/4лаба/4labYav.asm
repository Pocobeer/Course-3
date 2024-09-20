include include.inc
.386
.model flat, stdcall

.const
    title_S_before db 'Before yav add:', 0
    title_S_after db 'After add:', 0
    libr db '4_kab_d.dll',0
	nameproc db 'PadCh',0

.data
    S db 5, 'qwert', 0       ; �������� ������ � ������
    Res db 255 dup(0)        ; ����� ��� ����������, ������������������ ������
    Ch1 db 'A'               ; ������ ��� ����������
    Len1 db 10                 ; ����� ������ (������ ��������������� ����������� �����)
    hlib dd ?
	PadCh dd ?

.code
start:

    call LoadLibrary,offset libr ;�������� ����������
    mov hlib,eax
    call GetProcAddress,hlib,offset nameproc ;��������� ������ �������
    mov PadCh,eax
    ; ����� ��������� ����� �����������
    call MessageBox, 0, offset S+1, offset title_S_before, MB_OK

    ; ����� ����� ������������ PadCh
    push    offset Res        ; ����� ����������
    push    offset S         ; ����� ������ S
    mov     al, [Ch1]        ; ������ ��� ����������
    push    eax              ; ������
    mov     al, [Len1]       ; ����� ������
    push    eax              ; �����
    call PadCh             ; ����� ����� ������������

    ; ����� ��������� ����� ����������
    call MessageBox, 0, offset Res+1, offset title_S_after, MB_OK

    ; ���������� ���������
    push    0                ; ��� ����������
    call ExitProcess         ; ���������� ���������

ends
end start