import tkinter as tk
import ctypes
import os

def start_narrator():
    narrator_path = r"C:\Windows\System32\Narrator.exe"
    ctypes.windll.shell32.ShellExecuteW(None, "open", narrator_path, None, None, 1)

def start_magnifier():
    magnifier_path = r"C:\Windows\System32\Magnify.exe"
    ctypes.windll.shell32.ShellExecuteW(None, "open", magnifier_path, None, None, 1)

def start_on_screen_keyboard():
    osk_path = r"C:\Windows\System32\osk.exe"
    ctypes.windll.shell32.ShellExecuteW(None, "open", osk_path, None, None, 1)

# Создание основного окна
root = tk.Tk()
root.title("Специальные возможности Windows")

# Создание кнопки для запуска экранного диктора
narrator_button = tk.Button(root, text="Включить экранный диктор", command=start_narrator)
narrator_button.pack(padx=10, pady=10)

# Создание кнопки для запуска увеличительного стекла
magnifier_button = tk.Button(root, text="Включить увеличительное стекло", command=start_magnifier)
magnifier_button.pack( padx=10, pady=10)

# Создание кнопки для запуска экранной клавиатуры
osk_button = tk.Button(root, text="Включить экранную клавиатуру", command=start_on_screen_keyboard)
osk_button.pack( padx=10, pady=10)
# Запуск главного цикла приложения
root.mainloop()
