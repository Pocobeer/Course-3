import flet as ft
import pyodbc

def connect_to_access_db(db_file: str) -> pyodbc.Connection:
    """Устанавливает соединение с базой данных Access."""
    connection_string = rf'DRIVER={{Microsoft Access Driver (*.mdb, *.accdb)}};DBQ={db_file};'
    return pyodbc.connect(connection_string)

def main(page: ft.Page):
    page.title = "Управление пользователями"
    
    # Элементы интерфейса
    user_list = ft.ListView(expand=True)
    add_user_input = ft.TextField(label="Добавить пользователя", autofocus=True)
    
    # Функция для обновления списка пользователей
    def update_user_list():
        conn = connect_to_access_db('./Database1.accdb')
        cursor = conn.cursor()
        cursor.execute('SELECT * FROM Арендатор')
        users = cursor.fetchall()
        cursor.close()
        conn.close()
        
        user_list.controls.clear()
        for user in users:
            user_list.controls.append(ft.Text(f"{user.ФИО} (ID: {user.ID_Арендатора})"))
        page.update()

    # Функция для добавления пользователя
    def add_user(e):
        name = add_user_input.value
        if name:
            conn = connect_to_access_db('./Database1.accdb')
            cursor = conn.cursor()
            cursor.execute('INSERT INTO Арендатор (ФИО) VALUES (?)', (name,))
            conn.commit()
            cursor.close()
            conn.close()
            add_user_input.value = ""
            update_user_list()

    # Кнопка для добавления пользователя
    add_user_button = ft.ElevatedButton("Добавить", on_click=add_user)

    # Добавление элементов на страницу
    page.add(
        add_user_input,
        add_user_button,
        user_list
    )

    # Первоначальное обновление списка пользователей
    update_user_list()

# Запуск приложения
ft.app(target=main)
