from flask import Flask, render_template_string, jsonify, request, redirect, flash
import pyodbc
from datetime import datetime 

app = Flask(__name__)

def connect_to_access_db(db_file: str) -> pyodbc.Connection:
    """Устанавливает соединение с базой данных Access."""
    connection_string = rf'DRIVER={{Microsoft Access Driver (*.mdb, *.accdb)}};DBQ={db_file};'
    return pyodbc.connect(connection_string)

def fetch_all_users(conn: pyodbc.Connection) -> list:
    """Извлекает всех пользователей из базы."""
    cursor = conn.cursor()
    cursor.execute('SELECT * FROM Арендатор')
    rows = cursor.fetchall()
    formatted_rows = []

    for row in rows:
        formatted_row = list(row)
        formatted_row[2] = format_date(formatted_row[2])
        formatted_row[3] = str(formatted_row[3]) 
        formatted_rows.append(formatted_row)

    cursor.close()
    return formatted_rows  

def format_date(date_value):
    """Форматирует дату в строку без времени."""
    if isinstance(date_value, datetime):
        return date_value.strftime('%Y-%m-%d')  # Форматируем дату как 'ГГГГ-ММ-ДД'
    return date_value

def update_table(conn: pyodbc.Connection, user_id: int, field: str, new_value: str):
    """Обновляет данные пользователя в базе."""
    cursor = conn.cursor()
    
    # Проверка на допустимое поле
    valid_fields = ["ФИО", "Дата_Регистрации", "Email", "Номер_Телефона"]
    if field not in valid_fields:
        raise ValueError(f"Недопустимое поле: {field}")
    
    # Экранируем одинарные кавычки в new_value
    new_value = new_value.replace("'", "''")

    # Формируем SQL-запрос
    sql = f'UPDATE Арендатор SET {field} = ? WHERE ID_Арендатора = ?'
    
    # Выполняем запрос
    cursor.execute(sql, (new_value, user_id))
    conn.commit()  # Не забудьте зафиксировать изменения
    cursor.close()

def delete_table(conn: pyodbc.Connection, user_id: int):
    cursor = conn.cursor()
    sql = f'DELETE FROM Арендатор WHERE ID_Арендатора = ?'
    cursor.execute(sql, (user_id,))
    conn.commit()
    cursor.close()

def insert_table(conn: pyodbc.Connection, full_name: str, registration_date: datetime, email: str, phone_number: str):
    """Добавляет данные пользователя в базу."""
    cursor = conn.cursor()
    sql = f'INSERT INTO Арендатор (ФИО, Дата_Регистрации, Email, Номер_Телефона) VALUES ( ?, ?, ?, ?)'
    cursor.execute(sql, (full_name, registration_date, email, phone_number))
    conn.commit()
    cursor.close()

@app.route('/')
def home():
    return render_template_string('''
    <body style = "display:flex; justify-content: center; align-items: center; flex-direction: column;">
        <dis style = "width:75%; text-align: center;">
            <h1 style="text-align: center;">Список арендаторов</h1>
            <div id = user_table></div>
            <br>
            <button onclick = "fetchUsers()">Обновить список пользователей</button>
            <br><br>
                                        
            <h1 style="text-align: center;">Редактирование данных арендатора</h1>
            <form action="/update_user" method="POST">
                <label for="user_id">ID Арендатора:</label>
                <input type="number" id="user_id" name="user_id" required><br>
                <label for="field">Поле:</label>
                <select id="field" name="field" required>
                    <option value="ФИО">ФИО</option>
                    <option value="Дата_Регистрации">Дата регистрации</option>
                    <option value="Email">Email</option>
                    <option value="Номер_Телефона">Номер телефона</option>
                </select><br>
                <label for="new_value">Новое значение:</label>
                <input type="text" id="new_value" name="new_value" required pattern = ""><br>
                <button type="submit">Обновить</button>
            </form>
                                        
            <br><br>
                                        
            <h1 style="text-align: center;">Удаление данных арендатора</h1>
            <form action="/delete_user" method="POST">
                <label for="user_id">ID Арендатора:</label>
                <input type="number" id="user_id" name="user_id" required><br>
                <button type="submit">Удалить</button>
            </form>

            <br><br>
                                        
            <h1 style="text-align: center;">Добавление данных арендатора</h1>
            <form action="/insert_user" method="POST">
                <label for="full_name">ФИО:</label>
                <input type="text" id="full_name" name="full_name" required><br>
                <label for="registration_date">Дата регистрации:</label>
                <input type="date" id="registration_date" name="registration_date" required><br>
                <label for="email">Email:</label>
                <input type="email" id="email" name="email" required><br>
                <label for="phone_number">Номер телефона:</label>
                <input type="tel" id="phone_number" name="phone_number" required><br>
                <button type="submit">Добавить</button>
            </form>
        
    </body>
                                  
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        function fetchUsers() {
            fetch('/api/users')
            .then(response => response.json())
            .then(data => {
                let table = '<table border="1" style="width:100%; margin:auto; text-align: center;">';
                table += '<tr><th>ID Арендатора</th><th>ФИО</th><th>Дата регистрации</th><th>Email</th><th>Номер телефона</th></tr>';
                data.users.forEach(user => {
                    table += '<tr>';
                    user.forEach(field => {
                        table += `<td style="text-align: center;">${field}</td>`;
                    });
                    table += '</tr>';
                });
                table += '</table>';
                document.getElementById('user_table').innerHTML = table;  // Обновляем таблицу
            })
            .catch(error => console.error('Error:', error));
        }

        document.getElementById('field').addEventListener('change', function() {
            var selectedField = this.value;
            var newValueInput = document.getElementById('new_value');

            if (selectedField === 'Номер_Телефона') {
                $('#new_value').mask("+7 (999) 999-99-99");
            } else {
                newValueInput.removeAttribute('pattern'); // Удаляем паттерн для других полей
            }
        });                                    

        window.onload = fetchUsers;
                                  
    </script>
    ''')

@app.route('/api/users')
def get_users():   
    conn = connect_to_access_db('./Database1.accdb')
    users = fetch_all_users(conn)
    conn.close()
    return jsonify(users = [list(user) for user in users])

@app.route('/update_user', methods=['POST'])
def update_user():
    user_id = int(request.form['user_id'])
    field = request.form['field']
    new_value = request.form['new_value']
    
    conn = connect_to_access_db('./Database1.accdb')
    try:
        update_table(conn, user_id, field, new_value)
    except Exception as e:
        return jsonify(error = str(e))
    finally:
        conn.close()

    return redirect('/')

@app.route('/delete_user', methods=['POST'])
def delete_user():
    user_id = int(request.form['user_id'])
    
    conn = connect_to_access_db('./Database1.accdb')
    try:
        delete_table(conn, user_id)
    except Exception as e:
        return jsonify(error = str(e))    
    finally:
        conn.close()

    return redirect('/')

@app.route('/insert_user', methods=['POST'])
def insert_user():
    full_name = request.form['full_name']
    registration_date = request.form['registration_date']
    email = request.form['email']
    phone_number = request.form['phone_number']
    
    conn = connect_to_access_db('./Database1.accdb')
    try:
        insert_table(conn, full_name, registration_date, email, phone_number)
    except Exception as e:    
        return jsonify(error = str(e))
    finally:
        conn.close()

    return redirect('/')

if __name__ == '__main__':
    app.run(port = 8000, debug = True)