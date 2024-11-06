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
    command = 'Set-ItemProperty -Path "HKCU:\\Software\\Microsoft\\ColorFiltering" -Name "ColorFilterActive" -Value 1'
    subprocess.run(["powershell", "-Command", command])

def stop_color_filter():
    command = 'Set-ItemProperty -Path "HKCU:\\Software\\Microsoft\\ColorFiltering" -Name "ColorFilterActive" -Value 0'
    subprocess.run(["powershell", "-Command", command])

def toggle_high_contrast():
    command = 'Set-ItemProperty -Path "HKCU:\\Control Panel\\Accessibility\\HighContrast" -Name "HighContrast" -Value 1'
    subprocess.run(["powershell", "-Command", command])

def start_text_to_speech():
    command = 'Add-Type –AssemblyName System.Speech; (New-Object System.Speech.Synthesis.SpeechSynthesizer).Speak("Hello, this is a text to speech test.")'
    subprocess.run(["powershell", "-Command", command])

# Создание основного окна
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

# Кнопка для включения цветового фильтра
color_filter_button = tk.Button(root, text="Включить цветовой фильтр", command=start_color_filter)
color_filter_button.pack(padx=10, pady=10)

# Кнопка для отключения цветового фильтра
stop_color_filter_button = tk.Button(root, text="Отключить цветовой фильтр", command=stop_color_filter)
stop_color_filter_button.pack(padx=10, pady=10)

# Кнопка для включения высокого контраста
high_contrast_button = tk.Button(root, text="Включить высокий контраст", command=toggle_high_contrast)
high_contrast_button.pack(padx=10, pady=10)

# Кнопка для запуска диктора текста
text_to_speech_button = tk.Button(root, text="Запустить диктор текста", command=start_text_to_speech)
text_to_speech_button.pack(padx=10, pady=10)

# Запуск главного цикла приложения
root.mainloop()
