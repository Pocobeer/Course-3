; Консольное приложение, выводящее на консоль
; файл
include typefolder.inc
.386
.model FLAT,STDCALL
.data
hcons dd ?
hfile dd ?
buf db 100 dup(0)
bufer db 300 dup(0)
numb dd ?
numw dd ?
nameout db 'CONOUT$'
.code
_start: call CreateFile,offset nameout,\
GENERIC_READ+GENERIC_WRITE,0,0,OPEN_EXISTING,\
0,0
 mov hcons,eax; получение ссылки на консоль
; как на файл
 call GetCommandLine; в EAX указатель на
; командную строку
 mov esi,eax
 xor ecx,ecx ;счетчик
 mov edx,1 ;признак
n1: cmp byte ptr [esi],0;конец строки
 je end_ ;нет параметра
 cmp byte ptr [esi],32;пробел
 je n3
 add ecx,edx
 cmp ecx,2;Первый параметр – имя программы.
; Второй – имя файла.
 je n4
 xor edx,edx
 jmp n2
n3: or edx,1
n2: inc esi
 jmp n1
n4: call CreateFile, esi,\
GENERIC_READ+GENERIC_WRITE,\
 0,0,OPEN_EXISTING,0,0
 mov hfile,eax;открытие файла, имя которого
; указано в командной строке
l0: call ReadFile, hfile,offset bufer,300,\
 offset numb,0 ;чтение в буфер
 call WriteFile,hcons,offset bufer,numb,\
 offset numw,0;вывод на консоль как в файл
 cmp numb,300; numb<300 - файл закончился
 je l0
end_: call ExitProcess,0
end _start
