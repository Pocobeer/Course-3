import pyodbc
from tkinter import *
from tkinter import ttk
from tkinter import messagebox
from datetime import datetime 
def validate_number(phone_number):
    # Убираем все нецифровые символы, кроме +
    digits = ''.join(filter(lambda x: x.isdigit() or x == '+', phone_number))
    formatted_number = ""

    if len(digits) > 0:
        formatted_number += "+7 "
    if len(digits) > 2:
        formatted_number += "(" + digits[2:5]  # Код города
    if len(digits) >= 5:
        formatted_number += ") " + digits[5:8]  # Первая часть номера
    if len(digits) >= 8:
        formatted_number += "-" + digits[8:10]  # Вторая часть номера
    if len(digits) >= 10:
        formatted_number += "-" + digits[10:12]  # Третья часть номера

    return formatted_number

def key_release(event, phone_number_entry):
    # Получаем текущее значение и форматируем его
    current_value = phone_number_entry.get()
    formatted_value = validate_number(current_value)
    phone_number_entry.delete(0, END)
    phone_number_entry.insert(0, formatted_value)

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

def insert_table(conn: pyodbc.Connection, full_name: str, registration_date: datetime, email: str, phone_number: str):
    """Добавляет данные пользователя в базу."""
    cursor = conn.cursor()
    sql = f'INSERT INTO Арендатор (ФИО, Дата_Регистрации, Email, Номер_Телефона) VALUES ( ?, ?, ?, ?)'
    cursor.execute(sql, (full_name, registration_date, email, phone_number))
    conn.commit()
    cursor.close()

# conn = connect_to_access_db('./Database1.accdb')
# insert_table(conn, 'Иванов Иван Иванович', datetime.now().date(), 'e8o3Y@example.com', '123-456-7890')

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

def open_insert_window():
    insert_window = Toplevel(root)
    insert_window.geometry("400x400")
    insert_window.title("Добавление данных")

    Label(insert_window, text="ФИО:").pack(pady=5)
    full_name_entry = Entry(insert_window)
    full_name_entry.pack(pady=5)

    Label(insert_window, text="Дата Регистрации:").pack(pady=5)
    registration_date_entry = Entry(insert_window)
    registration_date_entry.pack(pady=5)

    Label(insert_window, text="Email:").pack(pady=5)
    email_entry = Entry(insert_window)
    email_entry.pack(pady=5)

    Label(insert_window, text="Номер Телефона:").pack(pady=5)
    phone_number_entry = Entry(insert_window)
    phone_number_entry.pack(pady=5)

    # Привязываем обработчик события нажатия клавиши
    phone_number_entry.bind("<KeyRelease>", lambda event: key_release(event, phone_number_entry))

    def insert_field():
        full_name = full_name_entry.get()
        registration_date = registration_date_entry.get()
        email = email_entry.get()
        phone_number = phone_number_entry.get()  # Получаем значение из поля ввода
        formatted_phone_number = validate_number(phone_number)

        # Проверяем, корректен ли номер телефона
        if formatted_phone_number != phone_number:
            messagebox.showwarning("Ошибка", "Неверный формат номера телефона.")
            return

        conn = connect_to_access_db('./Database1.accdb')
        if conn:
            try:
                insert_table(conn, full_name, registration_date, email, formatted_phone_number)
                messagebox.showinfo("Успех", "Данные успешно добавлены.")
                update_user_table()  # Обновляем таблицу после добавления
                insert_window.destroy()  # Закрываем окно добавления
            except Exception as e:
                messagebox.showerror("Ошибка", f"Не удалось добавить данные: {e}")
            finally:
                conn.close()

    Button(insert_window, text="Добавить", command=insert_field).pack(pady=10)
    Button(insert_window, text="Отмена", command=insert_window.destroy).pack(pady=5)

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

# Кнопка "Добавить пользователя"
Button(root, text="Добавить пользователя", command=open_insert_window).pack(side=LEFT, padx=10)

# Кнопка "Закрыть"
Button(root, text="Закрыть", command=root.quit).pack(side=RIGHT, padx=10)

#Кнопка "Удалить записть"
Button(root, text = "Удалить запись", command = delete_field).pack(side = RIGHT, padx=10)

# Запускаем главный цикл приложения
root.mainloop()
