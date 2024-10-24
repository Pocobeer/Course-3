include windows.inc

; Экспортируемые функции
extrn MessageBoxA:proc

; Псевдонимы для функций
MessageBox equ MessageBoxA

; Константы для MessageBox
MB_OK equ 0
MB_ICONINFORMATION equ 1