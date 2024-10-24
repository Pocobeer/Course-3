#include "Simulation.h"

using namespace std;
// Глобальная камера (ее указатель будет передан из main.cpp)
extern Camera camera;
static LARGE_INTEGER frequency; // Частота таймера
static LARGE_INTEGER lastTime; // Время последнего вызова
static bool initialized = false; // Флаг инициализации

// Функция для инициализации симуляции
void initSimulation() {
    QueryPerformanceFrequency(&frequency);
    QueryPerformanceCounter(&lastTime);
    initialized = true;
}

// Функция для получения времени симуляции
float getSimulationTime() {
    if (!initialized) {
        cerr << "Simulation not initialized!" << std::endl;
        return 0.0f;
    }

    LARGE_INTEGER currentTime;
    QueryPerformanceCounter(&currentTime);

    // Вычисляем время, прошедшее с последнего вызова в секундах
    float deltaTime = static_cast<float>(currentTime.QuadPart - lastTime.QuadPart)/ frequency.QuadPart;



    // Обновляем lastTime на текущее время
    lastTime = currentTime;

    return deltaTime;
}

bool checkCollision(const ivec2& newPosition) {
    // Проверка границ карты
    //if (newPosition.x <= 0 || newPosition.x >= 20 || newPosition.y <= 0 || newPosition.y >= 20) {
    //    cout << "Collision with boundary at: (" << newPosition.x << ", " << newPosition.y << ")" << endl;
    //    return true; // Выход за пределы карты
    //}
    // Проверка на наличие объектов, с которыми нельзя пройти
    if (passabilityMap[newPosition.x][newPosition.y] == 2) {
        cout << "Collision with object at: (" << newPosition.x << ", " << newPosition.y << ")" << endl;
        return true; // 2 - это граница
    }
    // Проверка на наличие объектов, с которыми нельзя пройти
    if (passabilityMap[newPosition.x][newPosition.y] == 3) {
        cout << "Collision with object at: (" << newPosition.x << ", " << newPosition.y << ")" << endl;
        return true; // 3 - это граница
    }
    if (passabilityMap[newPosition.x][newPosition.y] == 3) {
        return false; // Позволяем движение
    }
    return false; // Нет коллизий
}

void moveObject(const ivec2& newPosition, const ivec2& oldPosition) {
    // Обновляем карту проходимости
    passabilityMap[newPosition.y][newPosition.x] = 1; // Устанавливаем новое положение объекта
    passabilityMap[oldPosition.y][oldPosition.x] = 0; // Освобождаем старое место

    // Обновление позиции объекта в вашей игровой логике (например, в массиве объектов)
    // Возможно, вам нужно будет обновить массив объектов, если он у вас есть
     mapObjects[newPosition.y][newPosition.x] = mapObjects[oldPosition.y][oldPosition.x];
     mapObjects[oldPosition.y][oldPosition.x] = nullptr; // Освобождаем старое место
}

// Обработка ввода для камеры
void keyboardFunc(float deltaTime) {
    // Используем GetAsyncKeyState для управления камерой
    if (GetAsyncKeyState(VK_UP)) {
        camera.rotateUpDown(50.0f * deltaTime); // Вращение камеры вверх
    }
    if (GetAsyncKeyState(VK_DOWN)) {
        camera.rotateUpDown(-50.0f * deltaTime); // Вращение камеры вниз
    }
    if (GetAsyncKeyState(VK_LEFT)) {
        camera.rotateLeftRight(-50.0f * deltaTime); // Вращение камеры влево
    }
    if (GetAsyncKeyState(VK_LBUTTON)) {
        camera.rotateLeftRight(-50.0f * deltaTime); // Вращение камеры влево
    }
    if (GetAsyncKeyState(VK_RBUTTON)) {
        camera.rotateLeftRight(50.0f * deltaTime); // Вращение камеры вправо
    }
    if (GetAsyncKeyState(VK_RIGHT)) {
        camera.rotateLeftRight(50.0f * deltaTime); // Вращение камеры вправо
    }
    if (GetAsyncKeyState(VK_ADD)) {
        camera.zoomInOut(-5.0f * deltaTime); // Приближение камеры
    }
    if (GetAsyncKeyState(VK_SUBTRACT)) {
        camera.zoomInOut(5.0f * deltaTime); // Отдаление камеры
    }
    if (GetAsyncKeyState('W')) { // Если нажата клавиша W
        ivec2 newPos = player->getPosition();
        newPos.y -= 1; // Движение вверх
        if (!checkCollision(newPos)) {
            player->moveTo(newPos.x, newPos.y, -0.05f, 'y'); // Перемещение игрока
        }
        else if (passabilityMap[newPos.y][newPos.x] == 1) {
            // Если объект с ID 1, перемещаем его
            moveObject(newPos, player->getPosition());
        }
    }
    if (GetAsyncKeyState('S')) { // Если нажата клавиша S
        ivec2 newPos = player->getPosition();
        newPos.y += 1; // Движение вниз
        if (!checkCollision(newPos)) {
            player->moveTo(newPos.x, newPos.y, 0.05f, 'y'); // Перемещение игрока
        }
        else if (passabilityMap[newPos.y][newPos.x] == 1) {
            // Если объект с ID 1, перемещаем его
            moveObject(newPos, player->getPosition());
        }
    }
    if (GetAsyncKeyState('A')) { // Если нажата клавиша A
        ivec2 newPos = player->getPosition();
        newPos.x -= 1; // Движение влево
        if (!checkCollision(newPos)) {
            player->moveTo(newPos.x, newPos.y, -0.05f, 'x'); // Перемещение игрока
        }
        else if (passabilityMap[newPos.y][newPos.x] == 1) {
            // Если объект с ID 1, перемещаем его
            moveObject(newPos, player->getPosition());
        }
    }
    if (GetAsyncKeyState('D')) { // Если нажата клавиша D
        ivec2 newPos = player->getPosition();
        newPos.x += 1; // Движение вправо
        if (!checkCollision(newPos)) {
            player->moveTo(newPos.x, newPos.y, 0.05f, 'x'); // Перемещение игрока
        }
        else if (passabilityMap[newPos.y][newPos.x] == 1) {
            // Если объект с ID 1, перемещаем его
            moveObject(newPos, player->getPosition());
        }
    }

}

// Функция симуляции - вызывается максимально часто
void simulation() {
    // Определение времени симуляции
    float deltaTime = getSimulationTime();

    // Обработка ввода с клавиатуры для управления камерой
    keyboardFunc(deltaTime);

    // Устанавливаем признак того, что окно нуждается в перерисовке
    glutPostRedisplay();
}
