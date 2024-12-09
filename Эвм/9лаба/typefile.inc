includelib import32.lib
; имена используемых функций из kernel32.dll
 extrn ExitProcess:near
 extrn WriteConsoleA:near
 extrn GetStdHandle:near
; присваивания для облегчения читаемости кода
 WriteConsole equ WriteConsoleA
; имена используемых функций из mpr.dll
 extrn WNetGetUserA:near
 extrn WNetOpenEnumA:near
 extrn WNetEnumResourceA:near
 extrn WNetCloseEnum:near
; присваивания для облегчения читаемости кода
 WNetGetUser equ WNetGetUserA
 WNetOpenEnum equ WNetOpenEnumA
 WNetEnumResource equ WNetEnumResourceA
; определения констант и типов
NO_ERROR equ 0
ERROR_NO_MORE_ITEMS equ 259
RESOURCEUSAGE_CONNECTABLE equ 1
RESOURCETYPE_ANY equ 0
RESOURCE_CONNECTED equ 1
STD_OUTPUT_HANDLE equ -11
NTRESOURCE struc
 dwScope dd ?
 dwType dd ?
 dwDisplayType dd ?
 dwUsage dd ?
 lpLocalName dd ?
 lpRemoteName dd ?
 lpComment dd ?
 lpProvider dd ?
NTRESOURCE ends