import ctypes
from ctypes import wintypes
import tkinter as tk

# Определение констант для работы с Windows API (для высокого контраста)
SPI_SETHIGHCONTRAST = 0x0043
SPI_GETHIGHCONTRAST = 0x0042
SPIF_SENDCHANGE = 0x0002

# Структура HIGHCONTRAST для Windows API
class HIGHCONTRAST(ctypes.Structure):
    _fields_ = [
        ("cbSize", wintypes.UINT),
        ("dwFlags", wintypes.DWORD),
        ("lpszDefaultScheme", wintypes.LPWSTR)  # Используем LPWSTR для указателя на строку
    ]

# Функция для переключения темы контраста
def change_high_contrast_theme(theme_name):
    hc = HIGHCONTRAST()
    hc.cbSize = ctypes.sizeof(HIGHCONTRAST)
    
    # Получаем текущие параметры
    ctypes.windll.user32.SystemParametersInfoW(SPI_GETHIGHCONTRAST, hc.cbSize, ctypes.byref(hc), 0)
    
    # Преобразуем строку в указатель на строку типа LPWSTR
    hc.lpszDefaultScheme = ctypes.cast(ctypes.create_unicode_buffer(theme_name), wintypes.LPWSTR)

    # Включаем или выключаем режим высокого контраста
    hc.dwFlags |= 0x00000001  # Включаем высокий контраст

    # Применяем изменения
    ctypes.windll.user32.SystemParametersInfoW(SPI_SETHIGHCONTRAST, hc.cbSize, ctypes.byref(hc), SPIF_SENDCHANGE)

# Интерфейс с кнопками для изменения темы контраста
root = tk.Tk()
root.title("Переключение темы высокого контраста")

# Функция для установки темы контраста по нажатию кнопки
def set_high_contrast_theme(theme_name):
    change_high_contrast_theme(theme_name)
    print(f"Сменена тема контраста на {theme_name}")

# Кнопки для изменения темы контраста
theme1_button = tk.Button(root, text="Тема 1", command=lambda: set_high_contrast_theme("HighContrast1"))
theme1_button.pack(pady=10)

theme2_button = tk.Button(root, text="Тема 2", command=lambda: set_high_contrast_theme("HighContrast2"))
theme2_button.pack(pady=10)

theme3_button = tk.Button(root, text="Тема 3", command=lambda: set_high_contrast_theme("HighContrast3"))
theme3_button.pack(pady=10)

theme4_button = tk.Button(root, text="Тема 4", command=lambda: set_high_contrast_theme("HighContrast4"))
theme4_button.pack(pady=10)

# Запуск главного цикла приложения
root.mainloop()
