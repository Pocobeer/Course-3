; ����������� ����������� ����������
includelib import32.lib

; ����� ������������ ������� �� kernel32.dll
extrn ExitProcess:near
extrn GetCommandLineA:near
extrn CreateDirectoryA:near
extrn GetLastError:near
extrn GetStdHandle:near
extrn WriteFile:near

; ������������ ��� ���������� ���������� ����
GetCommandLine equ GetCommandLineA
CreateDirectory equ CreateDirectoryA

; ����������� ��������
STD_OUTPUT_HANDLE equ -11
NULL EQU 0                      ; ��������� ��� NULL