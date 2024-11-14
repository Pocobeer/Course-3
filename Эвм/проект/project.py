import tkinter as tk #GUI
import ctypes #Для работы с Windows API
import os #Для работы с операционной системой
import subprocess #Для работы с оболочками
from ctypes import wintypes #содержит определения типов данных Windows
from tkinter import font  # Импортируем модуль для работы со шрифтами

# Определяем константы для работы с Windows API (для высокого контраста)
SPI_SETHIGHCONTRAST = 0x0043
SPI_GETHIGHCONTRAST = 0x0042
SPIF_SENDCHANGE = 0x0002 # Отправить изменения на устройство

# Структура HIGHCONTRAST для Windows API
class HIGHCONTRAST(ctypes.Structure):
    _fields_ = [
        ("cbSize", wintypes.UINT),
        ("dwFlags", wintypes.DWORD),
        ("lpszDefaultScheme", wintypes.LPWSTR)
    ]

def start_narrator():
    narrator_path = r"C:\Windows\System32\Narrator.exe"
    ctypes.windll.shell32.ShellExecuteW(None, "open", narrator_path, None, None, 1)

def start_magnifier():
    magnifier_path = r"C:\Windows\System32\Magnify.exe"
    ctypes.windll.shell32.ShellExecuteW(None, "open", magnifier_path, None, None, 1)

def start_on_screen_keyboard():
    osk_path = r"C:\Windows\System32\osk.exe"
    ctypes.windll.shell32.ShellExecuteW(None, "open", osk_path, None, None, 1)

# Функция для включения/выключения высокого контраста
def toggle_high_contrast():
    hc = HIGHCONTRAST()
    hc.cbSize = ctypes.sizeof(HIGHCONTRAST)
    
    # Получаем текущие параметры
    ctypes.windll.user32.SystemParametersInfoW(SPI_GETHIGHCONTRAST, hc.cbSize, ctypes.byref(hc), 0)
    
    # Проверяем текущее состояние и переключаем
    if hc.dwFlags & 0x00000001:  # Если высокий контраст включен
        hc.dwFlags &= ~0x00000001  # Отключаем высокий контраст
        high_contrast_button.config(text="Включить высокий контраст")
    else:  # Если высокий контраст отключен
        hc.dwFlags |= 0x00000001  # Включаем высокий контраст
        high_contrast_button.config(text="Отключить высокий контраст")

    # Применяем изменения
    ctypes.windll.user32.SystemParametersInfoW(SPI_SETHIGHCONTRAST, hc.cbSize, ctypes.byref(hc), SPIF_SENDCHANGE)

# Функция для переключения цветного фильтра
def toggle_color_filter():
    # Отправка сообщения о нажатии клавиш Win + Ctrl + C
    ctypes.windll.user32.keybd_event(0x5B, 0, 0, 0)  # Нажатие Win
    ctypes.windll.user32.keybd_event(0x11, 0, 0, 0)  # Нажатие Ctrl
    ctypes.windll.user32.keybd_event(0x43, 0, 0, 0)  # Нажатие C
    ctypes.windll.user32.keybd_event(0x43, 0, 2, 0)  # Отпускание C
    ctypes.windll.user32.keybd_event(0x11, 0, 2, 0)  # Отпускание Ctrl
    ctypes.windll.user32.keybd_event(0x5B, 0, 2, 0)  # Отпускание Win

    # Изменение текста кнопки в зависимости от состояния
    if color_filter_button['text'] == "Включить цветной фильтр":
        color_filter_button.config(text="Отключить цветной фильтр")
    else:
        color_filter_button.config(text="Включить цветной фильтр")

def restart_computer():
    # Перезагрузка компьютера
    subprocess.run(["shutdown", "/r", "/t", "0"])

if __name__ == "__main__":
    root = tk.Tk()
    root.title("Специальные возможности Windows")
    
    # Получаем разрешение экрана
    screen_width = root.winfo_screenwidth()
    screen_height = root.winfo_screenheight()

    # Устанавливаем размеры окна
    window_width = int(screen_width * 0.4)
    window_height = int(screen_height * 0.4)
    root.geometry(f"{window_width}x{window_height}")

    # Создаем кнопки и размещаем их в сетке
    button_width = int(window_width * 0.8) 

 # Настройка строк и столбцов для растяжения
    for i in range(6):
        root.grid_rowconfigure(i, weight=1)  # Увеличиваем вес каждой строки
    root.grid_columnconfigure(0, weight=1)  # Увеличиваем вес первого столбца

    # Устанавливаем шрифт для кнопок
    button_font = font.Font(size=14)  # Устанавливаем размер шрифта на 12

    # Создаем кнопки и размещаем их в сетке
    narrator_button = tk.Button(root, text="Включить экранный диктор", font=button_font, command=start_narrator)
    narrator_button.grid(row=0, column=0, sticky="nsew", padx=10, pady=10)

    magnifier_button = tk.Button(root, text="Включить увеличительное стекло", font=button_font, command=start_magnifier)
    magnifier_button.grid(row=1, column=0, sticky="nsew", padx=10, pady=10)

    osk_button = tk.Button(root, text="Включить экранную клавиатуру", font=button_font, command=start_on_screen_keyboard)
    osk_button.grid(row=2, column=0, sticky="nsew", padx=10, pady=10)

    high_contrast_button = tk.Button(root, text="Включить высокий контраст", font=button_font, command=toggle_high_contrast)
    high_contrast_button.grid(row=3, column=0, sticky="nsew", padx=10, pady=10)

    color_filter_button = tk.Button(root, text="Включить цветной фильтр", font=button_font, command=toggle_color_filter)
    color_filter_button.grid(row=4, column=0, sticky="nsew", padx=10, pady=10)

    restart_button = tk.Button(root, text="Перезагрузить компьютер", font=button_font, command=restart_computer)
    restart_button.grid(row=5, column=0, sticky="nsew", padx=10, pady=10)

    # Запуск основного цикла приложения
    root.mainloop()