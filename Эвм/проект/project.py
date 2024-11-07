import tkinter as tk #GUI
import ctypes #Для работы с Windows API
import os #Для работы с операционной системой
import subprocess #Для работы с оболочками
from ctypes import wintypes #содержит определения типов данных Windows

# Определяем константы для работы с Windows API (для высокого контраста и цветных фильтров)
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

    # Кнопка для запуска экранного диктора
    narrator_button = tk.Button(root, text="Включить экранный диктор", command=start_narrator)
    narrator_button.pack(padx=10, pady=10)

    # Кнопка для запуска увеличительного стекла
    magnifier_button = tk.Button(root, text="Включить увеличительное стекло", command=start_magnifier)
    magnifier_button.pack(padx=10, pady=10)

    # Кнопка для запуска экранной клавиатуры
    osk_button = tk.Button(root, text="Включить экранную клавиатуру", command=start_on_screen_keyboard)
    osk_button.pack(padx=10, pady=10)

    # Кнопка для переключения высокого контраста
    high_contrast_button = tk.Button(root, text="Включить высокий контраст", command=toggle_high_contrast)
    high_contrast_button.pack(pady=10)

    # Кнопка для переключения цветного фильтра
    color_filter_button = tk.Button(root, text="Включить цветной фильтр", command=toggle_color_filter)
    color_filter_button.pack(pady=10)

    # Кнопка для перезагрузки компьютера
    restart_button = tk.Button(root, text="Перезагрузить компьютер", command=restart_computer)
    restart_button.pack(padx=10, pady=10)

    # Запуск главного цикла приложения
    root.mainloop()
