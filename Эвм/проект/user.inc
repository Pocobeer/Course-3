include windows.inc

; �������������� �������
extrn MessageBoxA:proc

; ���������� ��� �������
MessageBox equ MessageBoxA

; ��������� ��� MessageBox
MB_OK equ 0
MB_ICONINFORMATION equ 1