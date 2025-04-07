const net = require('net');
const clients = []; // Массив подключённых клиентов

const server = net.createServer((socket) => {
    console.log('Новый клиент подключился');
    clients.push(socket);

    // Отправляем приветствие
    socket.write('Добро пожаловать в чат! Введите имя: ');

    let username = '';
    socket.on('data', (data) => {
        const message = data.toString().trim();

        // Если имя не задано, сохраняем его
        if (!username) {
            username = message;
            socket.write(`Привет, ${username}! Теперь ты в чате.\n`);
            broadcast(`${username} присоединился к чату.`, socket);
            return;
        }

        // Рассылаем сообщение всем, кроме отправителя
        broadcast(`${username}: ${message}`, socket);
    });

    // Обработка отключения клиента
    socket.on('end', () => {
        console.log(`${username} отключился`);
        clients.splice(clients.indexOf(socket), 1);
        broadcast(`${username} покинул чат.`, socket);
    });

    // Обработка ошибок
    socket.on('error', (err) => {
        console.log('Ошибка:', err.message);
    });
});

// Функция рассылки сообщений всем клиентам, кроме отправителя
function broadcast(message, sender) {
    clients.forEach(client => {
        if (client !== sender) {
            client.write(message + '\n');
        }
    });
    console.log(message); 
}

// Запуск сервера
const PORT = 3000;
const HOST = '127.0.0.1';
server.listen(PORT, HOST, () => {
    console.log(`Сервер чата запущен на ${HOST}:${PORT}`);
});