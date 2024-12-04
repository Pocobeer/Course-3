import pyodbc
from tkinter import *
from tkinter import ttk
from tkinter import messagebox
from datetime import datetime 

def connect_to_access_db(db_file: str) -> pyodbc.Connection:
    """Устанавливает соединение с базой данных Access."""
    connection_string = rf'DRIVER={{Microsoft Access Driver (*.mdb, *.accdb)}};DBQ={db_file};'
    return pyodbc.connect(connection_string)

def fetch_all_users(conn: pyodbc.Connection) -> list:
    """Извлекает всех пользователей из базы."""
    cursor = conn.cursor()
    cursor.execute('SELECT * FROM Арендатор')
    rows = cursor.fetchall()
    cursor.close()
    return rows

def update_table(conn: pyodbc.Connection, user_id: int, field: str, new_value: str):
    """Обновляет данные пользователя в базе."""
    cursor = conn.cursor()
    sql = f'UPDATE Арендатор SET {field} = ? WHERE ID_Арендатора = ?'
    cursor.execute(sql, (new_value, user_id))
    conn.commit()
    cursor.close()

def delete_table(conn: pyodbc.Connection, user_id: int):
    cursor = conn.cursor()
    sql = f'DELETE FROM Арендатор WHERE ID_Арендатора = ?'
    cursor.execute(sql, (user_id,))
    conn.commit()
    cursor.close()
    update_user_table()

def format_date(date_value):
    """Форматирует дату в строку без времени."""
    if isinstance(date_value, datetime):
        return date_value.strftime('%Y-%m-%d')  # Форматируем дату как 'ГГГГ-ММ-ДД'
    return date_value

def tuple_to_string(x):
    formatted_values = []
    for item in x:
        if isinstance(item, datetime):
            formatted_values.append(format_date(item))  # Форматируем дату
        else:
            formatted_values.append(str(item))
    return tuple(formatted_values)

def update_user_table():
    """Обновляет таблицу пользователей."""
    # Очищаем текущие данные в Treeview
    for item in userTable.get_children():
        userTable.delete(item)
    
    # Получаем новых пользователей из базы данных
    conn = connect_to_access_db('./Database1.accdb')
    users = fetch_all_users(conn)
    conn.close()
    
    # Заполняем Treeview новыми данными
    for user in users:
        userTable.insert("", END, values=tuple_to_string(user))

def open_update_window():
    """Открывает окно для изменения данных пользователя."""
    selected_item = userTable.selection()
    if not selected_item:
        messagebox.showwarning("Предупреждение", "Пожалуйста, выберите пользователя для изменения.")
        return
    
    user_id = userTable.item(selected_item)['values'][0]  # Получаем ID выбранного пользователя
    
    # Создаем новое окно
    update_window = Toplevel(root)
    update_window.title("Изменение данных")
    
    # Поля для ввода данных для изменения
    Label(update_window, text="Поле для изменения:").pack(pady=5)
    field_entry = Entry(update_window)
    field_entry.pack(pady=5)

    Label(update_window, text="Новое значение:").pack(pady=5)
    new_value_entry = Entry(update_window)
    new_value_entry.pack(pady=5)

    def update_data():
        field_to_update = field_entry.get()
        new_value = new_value_entry.get()
        
        conn = connect_to_access_db('./Database1.accdb')
        if conn:
            try:
                update_table(conn, user_id, field_to_update, new_value)
                messagebox.showinfo("Успех", "Данные успешно изменены.")
                update_user_table()  # Обновляем таблицу после изменения
                update_window.destroy()  # Закрываем окно изменения
            except Exception as e:
                messagebox.showerror("Ошибка", f"Не удалось изменить данные: {e}")
            finally:
                conn.close()

    Button(update_window, text="Изменить", command=update_data).pack(pady=10)
    Button(update_window, text="Отмена", command=update_window.destroy).pack(pady=5)



def delete_field():
    selected_item = userTable.selection()
    if not selected_item:
        messagebox.showwarning("Предупреждение", "Пожалуйста, выберите поле для удаления.")
        return
    user_id = userTable.item(selected_item)['values'][0]
    conn = connect_to_access_db('./Database1.accdb')
    if conn:
        delete_table(conn, user_id)
        update_user_table()
        conn.close()


# Инициализация основного окна
root = Tk()
root.geometry("800x300")
root.title("Доступ к данным через высокоуровневый яп")

# Определяем колонки для Treeview
columns = ('ID_Арендатора', 'ФИО', 'Дата_Регистрации', 'Email', 'Номер_Телефона')

# Создаем Treeview
userTable = ttk.Treeview(columns=columns, show='headings')
userTable.pack(fill=BOTH, expand=1)

# Настраиваем заголовки и ширину колонок
for col in columns:
    userTable.heading(col, text=col)
    userTable.column(col, anchor='center', width=100)  # Устанавливаем ширину по умолчанию

# Первоначальное заполнение таблицы
update_user_table()

# Кнопка "Обновить"
Button(root, text="Обновить", command=update_user_table).pack(side=LEFT, padx=10)

# Кнопка "Изменить данные"
Button(root, text="Изменить данные", command=open_update_window).pack(side=LEFT, padx=10)

# Кнопка "Закрыть"
Button(root, text="Закрыть", command=root.quit).pack(side=RIGHT, padx=10)

#Кнопка "Удалить записть"
Button(root, text = "Удалить запись", command = delete_field).pack(side = RIGHT, padx=10)

# Запускаем главный цикл приложения
root.mainloop()
