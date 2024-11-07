import tkinter as tk
import pyautogui
from tkinter import messagebox

def toggle_color_filter():
    # Симуляция нажатия клавиш для включения/выключения цветного фильтра
    # Обычно это комбинация Win + Ctrl + C
    try:
        pyautogui.hotkey('win', 'ctrl', 'c')
        messagebox.showinfo("Успех", "Цветной фильтр переключен.")
    except Exception as e:
        messagebox.showerror("Ошибка", f"Не удалось переключить цветной фильтр: {e}")

# Создание основного окна
root = tk.Tk()
root.title("Управление цветным фильтром")

# Кнопка для переключения цветного фильтра
toggle_button = tk.Button(root, text="Переключить цветной фильтр", command=toggle_color_filter)
toggle_button.pack(pady=10)

# Запуск главного цикла
root.mainloop()
