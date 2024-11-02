import tkinter as tk
import ctypes
import os
import subprocess

def start_narrator():
    narrator_path = r"C:\Windows\System32\Narrator.exe"
    ctypes.windll.shell32.ShellExecuteW(None, "open", narrator_path, None, None, 1)

def start_magnifier():
    magnifier_path = r"C:\Windows\System32\Magnify.exe"
    ctypes.windll.shell32.ShellExecuteW(None, "open", magnifier_path, None, None, 1)

def start_on_screen_keyboard():
    osk_path = r"C:\Windows\System32\osk.exe"
    ctypes.windll.shell32.ShellExecuteW(None, "open", osk_path, None, None, 1)

def start_color_filter():
    # Включение цветового фильтра с помощью PowerShell
    command = 'Set-ItemProperty -Path "HKCU:\\Software\\Microsoft\\ColorFiltering" -Name "ColorFilterActive" -Value 1'
    subprocess.run(["powershell", "-Command", command])

# Создание основного окна
root = tk.Tk()
root.title("Специальные возможности Windows")

#кнопка для запуска экранного диктора
narrator_button = tk.Button(root, text="Включить экранный диктор", command=start_narrator)
narrator_button.pack(padx=10, pady=10)

# кнопка для запуска увеличительного стекла
magnifier_button = tk.Button(root, text="Включить увеличительное стекло", command=start_magnifier)
magnifier_button.pack( padx=10, pady=10)

# кнопка для запуска экранной клавиатуры
osk_button = tk.Button(root, text="Включить экранную клавиатуру", command=start_on_screen_keyboard)
osk_button.pack( padx=10, pady=10)

# кнопка для запуска цветового фильтра
color_filter_button = tk.Button(root, text="Включить цветовый фильтр", command=start_color_filter)
color_filter_button.pack( padx=10, pady=10)

# Запуск главного цикла приложения
root.mainloop()
