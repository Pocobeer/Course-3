#include "Simulation.h"
#include <windows.h> // Для использования GetAsyncKeyState, QueryPerformanceCounter и QueryPerformanceFrequency
#include <iostream>
#include "Camera.h"
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
        std::cerr << "Simulation not initialized!" << std::endl;
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

// Обработка ввода для камеры
void processInput(float deltaTime) {
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
}

// Функция симуляции - вызывается максимально часто
void simulation() {
    // Определение времени симуляции
    float deltaTime = getSimulationTime();

    // Обработка ввода с клавиатуры для управления камерой
    processInput(deltaTime);

    // Устанавливаем признак того, что окно нуждается в перерисовке
    glutPostRedisplay();
}
