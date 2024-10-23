#include "Display.h"


// Временные переменные для подсчета FPS
static int frameCount = 0;                // Количество кадров
static float fps = 0.0f;                  // Текущий FPS
static LARGE_INTEGER frequency;            // Частота таймера
static LARGE_INTEGER lastTime;             // Время последнего обновления FPS

// Функция для изменения размеров окна
void reshape(int w, int h) {
    glViewport(0, 0, (GLsizei)w, (GLsizei)h);
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    gluPerspective(25.0, (float)w / h, 0.2, 70.0);
}

// Функция вызывается при перерисовке окна
void display(void) {
    // Инициализация частоты таймера при первом вызове
    if (frameCount == 0) {
        QueryPerformanceFrequency(&frequency);
        QueryPerformanceCounter(&lastTime);
    }

    // Обновляем счетчик кадров
    frameCount++;

    // Получаем текущее время
    LARGE_INTEGER currentTime;
    QueryPerformanceCounter(&currentTime);

    // Вычисляем прошедшее время
    float deltaTime = static_cast<float>(currentTime.QuadPart - lastTime.QuadPart) / frequency.QuadPart;

    // Если прошла одна секунда, обновляем FPS
    if (deltaTime >= 1.0f) {
        fps = frameCount / deltaTime;  // Рассчитываем FPS
        frameCount = 0;                 // Сбрасываем счетчик кадров
        lastTime = currentTime;         // Обновляем время последнего обновления
    }

    // Обновляем заголовок окна
    char title[50];
    sprintf_s(title, "Laba_08 - FPS: %.2f", fps);
    glutSetWindowTitle(title);

    // Очищаем буферы
    glClearColor(0.00, 0.00, 0.00, 1.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glEnable(GL_DEPTH_TEST);

    glEnable(GL_LIGHTING);
    glEnable(GL_LIGHT0);



    camera.apply();

    lights[0].apply();
    renderScene();

    if (meshLoaded) {
        mesh->draw(); // Вызываем метод draw у объекта mesh
        //cout << "mdksw" << endl;
    }
    else {
        //cout << "mesh not loaded" << endl;
    }

    // Меняем передний и задний буферы
    glutSwapBuffers();
}

