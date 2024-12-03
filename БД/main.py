import pyodbc
from tkinter import *
from tkinter import ttk
from datetime import datetime 

def connect_to_access_db(db_file: str) -> pyodbc.Connection:
    """Устанавливает соединение с базой данных Access."""
    connection_string = rf'DRIVER={{Microsoft Access Driver (*.mdb, *.accdb)}};DBQ={db_file};'
    return pyodbc.connect(connection_string)

conn = connect_to_access_db('./Database1.accdb')

def fetch_all_users(conn: pyodbc.Connection) -> list:
    """Извлекает всех пользователей из базы."""
    cursor = conn.cursor()
    cursor.execute('SELECT * FROM Арендатор')
    rows = cursor.fetchall()
    cursor.close()
    return rows

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

users = fetch_all_users(conn)
# for user in users:
#     print(tuple_to_string(user))
conn.close()

root = Tk()
root.geometry("800x300")
root.title("Доступ к данным через высокоуровневый яп")

columns = ('ID_Арендатора', 'ФИО', 'Дата_Регистрации','Email', 'Номер_Телефона')

userTable = ttk.Treeview(columns=columns, show='headings')
userTable.pack(fill=BOTH, expand=1)

userTable.heading('ID_Арендатора', text='ID_Арендатора')
userTable.heading('ФИО', text='ФИО')
userTable.heading('Дата_Регистрации', text='Дата_Регистрации')
userTable.heading('Email', text='Email')
userTable.heading('Номер_Телефона', text='Номер_Телефона')

for col in columns:
    userTable.column(col, anchor='center', width=100)  # Устанавливаем ширину по умолчанию
    userTable.heading(col, text=col)

for user in users:
    userTable.insert("", END, values=tuple_to_string(user))


Button(root, text="Закрыть", command=root.quit).pack()

root.mainloop()