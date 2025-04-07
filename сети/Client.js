const net = require('net');
const readline = require('readline');

const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout
});

const client = net.createConnection({ port: 3000, host: '127.0.0.1' }, () => {
    console.log('Подключено к серверу чата!');
});

client.on('data', (data) => {
    console.log(data.toString());
});

client.on('end', () => {
    console.log('Отключено от сервера');
    process.exit();
});

// Чтение ввода пользователя и отправка на сервер
rl.on('line', (input) => {
    client.write(input);
});