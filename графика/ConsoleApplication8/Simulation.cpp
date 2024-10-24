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
    // Проверка на наличие объектов, с которыми нельзя пройти
    if (passabilityMap[newPosition.x][newPosition.y] == 2 || passabilityMap[newPosition.x][newPosition.y] == 3) {
        return true; // 2 и 3 - это границы
    }

    //// Проверка столкновения с легким объектом
    //if (passabilityMap[newPosition.x][newPosition.y] == 1) { 
    //    // Вычисляем позицию, куда будет толкаться объект
    //    ivec2 pushedPosition = newPosition + (newPosition - player->getPosition());

    //    // Проверяем, свободна ли ячейка за легким объектом
    //    if (pushedPosition.x >= 0 && pushedPosition.x < 21 &&
    //        pushedPosition.y >= 0 && pushedPosition.y < 21 &&
    //        passabilityMap[pushedPosition.x][pushedPosition.y] == 0) {
    //        // Перемещение легкого объекта
    //        passabilityMap[pushedPosition.x][pushedPosition.y] = 1; // Устанавливаем объект на новую позицию
    //        passabilityMap[newPosition.x][newPosition.y] = 0; // Убираем объект с текущей позиции
    //        mapObjects[pushedPosition.x][pushedPosition.y] = mapObjects[newPosition.x][newPosition.y]; // Обновляем массив объектов
    //        mapObjects[newPosition.x][newPosition.y] = nullptr; // Убираем объект с текущей позиции
    //        return false; // Перемещение возможно
    //    }
    //    return true; // Столкновение с легким объектом, но перемещение невозможно
    //}
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
    if (GetAsyncKeyState('W')) { 
        ivec2 newPos = player->getPosition();
        newPos.y -= 1; // Движение вверх
        if (!checkCollision(newPos)) {
            player->moveTo(newPos.x, newPos.y, -0.05f, 'y'); // Перемещение игрока
        }
    }
    if (GetAsyncKeyState('S')) { 
        ivec2 newPos = player->getPosition();
        newPos.y += 1; // Движение вниз
        if (!checkCollision(newPos)) {
            player->moveTo(newPos.x, newPos.y, 0.05f, 'y'); // Перемещение игрока
        }
    }
    if (GetAsyncKeyState('A')) { 
        ivec2 newPos = player->getPosition();
        newPos.x -= 1; // Движение влево
        if (!checkCollision(newPos)) {
            player->moveTo(newPos.x, newPos.y, -0.05f, 'x'); // Перемещение игрока
        }
    }
    if (GetAsyncKeyState('D')) { 
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
