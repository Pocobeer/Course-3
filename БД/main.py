import pyodbc
from tkinter import *
from tkinter import ttk

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

users = fetch_all_users(conn)
for user in users:
    print(user)
conn.close()

# root = Tk()
# root.geometry("300x300")
# root.title("Доступ к данным через высокоуровневый яп")

# columns = ('id', 'name', 'registration date','email', 'phone number')

# userTable = ttk.Treeview(columns=columns, show='headings')
# userTable.pack(fill=BOTH, expand=1)

# userTable.heading('id', text='id')
# userTable.heading('name', text='name')
# userTable.heading('registration date', text='registration date')
# userTable.heading('email', text='email')
# userTable.heading('phone number', text='phone number')

# for user in users:
#     userTable.insert("", END, values=user)

# root.mainloop()