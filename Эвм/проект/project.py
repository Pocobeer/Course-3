import tkinter as tk
import ctypes
import os
import subprocess
from ctypes import wintypes

# Определяем константы для работы с Windows API (для высокого контраста и цветных фильтров)
SPI_SETHIGHCONTRAST = 0x0043
SPI_GETHIGHCONTRAST = 0x0042
SPIF_SENDCHANGE = 0x0002

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
def toggle_high_contrast(enable):
    hc = HIGHCONTRAST()
    hc.cbSize = ctypes.sizeof(HIGHCONTRAST)
    
    # Получаем текущие параметры
    ctypes.windll.user32.SystemParametersInfoW(SPI_GETHIGHCONTRAST, hc.cbSize, ctypes.byref(hc), 0)
    
    if enable:
        # Устанавливаем флаг HCF_HIGHCONTRASTON для включения высокого контраста
        hc.dwFlags |= 0x00000001
    else:
        # Снимаем флаг HCF_HIGHCONTRASTON для отключения высокого контраста
        hc.dwFlags &= ~0x00000001

    # Применяем изменения
    ctypes.windll.user32.SystemParametersInfoW(SPI_SETHIGHCONTRAST, hc.cbSize, ctypes.byref(hc), SPIF_SENDCHANGE)


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

    # Кнопка для включения высокого контраста
    enable_button = tk.Button(root, text="Включить высокий контраст", command=lambda: toggle_high_contrast(True))
    enable_button.pack(pady=10)

    # Кнопка для отключения высокого контраста
    disable_button = tk.Button(root, text="Отключить высокий контраст", command=lambda: toggle_high_contrast(False))
    disable_button.pack(pady=10)

    # Кнопка для перезагрузки компьютера
    restart_button = tk.Button(root, text="Перезагрузить компьютер", command=restart_computer)
    restart_button.pack(padx=10, pady=10)

    # Запуск главного цикла приложения
    root.mainloop()
