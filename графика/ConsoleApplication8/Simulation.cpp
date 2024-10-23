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
    //if (newPosition.x < -9 || newPosition.x >= 10 || newPosition.y < -9 || newPosition.y >= 10) {
    //    cout << "Collision with boundary at: (" << newPosition.x << ", " << newPosition.y << ")" << endl;
    //    return true; // Выход за пределы карты
    //}
    // Проверка на наличие объектов, с которыми нельзя пройти
    if (passabilityMap[newPosition.y][newPosition.x] == 3) {
        cout << "Collision with object at: (" << newPosition.x << ", " << newPosition.y << ")" << endl;
        return true; // 3 - это граница
    }
    return false; // Нет коллизий
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
    }
    if (GetAsyncKeyState('S')) { // Если нажата клавиша S
        ivec2 newPos = player->getPosition();
        newPos.y += 1; // Движение вниз
        if (!checkCollision(newPos)) {
            player->moveTo(newPos.x, newPos.y, 0.05f, 'y'); // Перемещение игрока
        }
    }
    if (GetAsyncKeyState('A')) { // Если нажата клавиша A
        ivec2 newPos = player->getPosition();
        newPos.x -= 1; // Движение влево
        if (!checkCollision(newPos)) {
            player->moveTo(newPos.x, newPos.y, -0.05f, 'x'); // Перемещение игрока
        }
    }
    if (GetAsyncKeyState('D')) { // Если нажата клавиша D
        ivec2 newPos = player->getPosition();
        newPos.x += 1; // Движение вправо
        if (!checkCollision(newPos)) {
            player->moveTo(newPos.x, newPos.y, 0.05f, 'x'); // Перемещение игрока
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
