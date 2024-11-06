import tkinter as tk
import ctypes
import os
import subprocess

def start_narrator():
    """Запуск экранного диктора."""
    narrator_path = r"C:\Windows\System32\Narrator.exe"
    ctypes.windll.shell32.ShellExecuteW(None, "open", narrator_path, None, None, 1)

def start_magnifier():
    """Запуск увеличительного стекла."""
    magnifier_path = r"C:\Windows\System32\Magnify.exe"
    ctypes.windll.shell32.ShellExecuteW(None, "open", magnifier_path, None, None, 1)

def start_on_screen_keyboard():
    """Запуск экранной клавиатуры."""
    osk_path = r"C:\Windows\System32\osk.exe"
    ctypes.windll.shell32.ShellExecuteW(None, "open", osk_path, None, None, 1)

def toggle_high_contrast():
    """Переключение высокого контраста."""
    current_high_contrast = subprocess.check_output(
        ["powershell", "-Command", "(Get-ItemProperty -Path 'HKCU:\\Control Panel\\Accessibility').HighContrast"])
    new_value = '0' if current_high_contrast.strip() == b'1' else '1'
    subprocess.run(["powershell", "-Command", f"Set-ItemProperty -Path 'HKCU:\\Control Panel\\Accessibility' -Name 'HighContrast' -Value '{new_value}'"])

def activate_color_filter():
    """Активация цветового фильтра через параметры."""
    # Запускаем диалоговое окно с параметрами доступности для включения цветового фильтра
    subprocess.run(["control", "colorcpl"])

def start_high_contrast_settings():
    """Открытие настроек высокого контраста."""
    subprocess.Popen("control colorcpl")

def start_simplified_control():
    """Открытие панели управления для упрощенного управления."""
    subprocess.Popen("control /name Microsoft.EaseOfAccessCenter")

# Создание основного окна
root = tk.Tk()
root.title("Специальные возможности Windows")

# Кнопки для запуска специальных возможностей
narrator_button = tk.Button(root, text="Включить экранный диктор", command=start_narrator)
narrator_button.pack(padx=10, pady=10)

magnifier_button = tk.Button(root, text="Включить увеличительное стекло", command=start_magnifier)
magnifier_button.pack(padx=10, pady=10)

osk_button = tk.Button(root, text="Включить экранную клавиатуру", command=start_on_screen_keyboard)
osk_button.pack(padx=10, pady=10)

high_contrast_button = tk.Button(root, text="Переключить высокий контраст", command=toggle_high_contrast)
high_contrast_button.pack(padx=10, pady=10)

color_filters_button = tk.Button(root, text="Настройки цветовых фильтров", command=activate_color_filter)
color_filters_button.pack(padx=10, pady=10)

high_contrast_settings_button = tk.Button(root, text="Настройки высокого контраста", command=start_high_contrast_settings)
high_contrast_settings_button.pack(padx=10, pady=10)

simplified_control_button = tk.Button(root, text="Упрощенное управление", command=start_simplified_control)
simplified_control_button.pack(padx=10, pady=10)

# Запуск главного цикла приложения
root.mainloop()
