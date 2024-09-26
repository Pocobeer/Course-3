#include <windows.h>

#include <iostream>
#include <vector>

#include <GL/gl.h>
#include <GL/glu.h>
#include "GL/freeglut.h"
#include <glm/glm.hpp>
#include <glm/gtc/matrix_transform.hpp>
#include <glm/gtc/type_ptr.hpp>
#include "Data.h"
#include "Simulation.h"
#include "Camera.h"
#include "Display.h"

Camera camera;  // Объявляем камеру как глобальную переменную

using namespace std;
using namespace glm;

// функция, вызываемая при изменении размеров окна
/*void reshape(int w, int h)
{
    // установить новую область просмотра, равную всей области окна
    glViewport(0, 0, (GLsizei)w, (GLsizei)h);

    // установить матрицу проекции с правильным аспектом
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    gluPerspective(25.0, (float)w / h, 0.2, 70.0);
}

// функция вызывается при перерисовке окна
void display(void)
{
    // отчищаем буфер цвета и буфер глубины
    glClearColor(0.00, 0.00, 0.00, 1.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    // включаем тест глубины
    glEnable(GL_DEPTH_TEST);
    // устанавливаем камеру
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
    camera.apply();  // Применяем позицию камеры

    for (auto& go : graphicObjects) {
        go.draw();
    }

    // смена переднего и заднего буферов
    glutSwapBuffers();
}*/

int main(int argc, char** argv)
{
    setlocale(LC_ALL, "ru");

    // инициализация библиотеки GLUT
    glutInit(&argc, argv);
    // инициализация дисплея (формат вывода)
    glutInitDisplayMode(GLUT_RGBA | GLUT_DOUBLE | GLUT_DEPTH | GLUT_MULTISAMPLE);

    // СОЗДАНИЕ ОКНА:
    // 1. устанавливаем верхний левый угол окна
    glutInitWindowPosition(200, 200);
    // 2. устанавливаем размер окна
    glutInitWindowSize(800, 600);
    // 3. создаем окно
    glutCreateWindow("Laba_04");

    initData();  // Инициализация данных
    initSimulation();  // Инициализация симуляции

    camera.setPosition(vec3(10.0f, 15.0f, 17.5f));

    // УСТАНОВКА ФУНКЦИЙ ОБРАТНОГО ВЫЗОВА
    glutDisplayFunc(display);  // Устанавливаем функцию для перерисовки окна
    glutReshapeFunc(reshape);  // Устанавливаем функцию для изменения размеров окна
    glutIdleFunc(simulation);  // Устанавливаем функцию симуляции (вызывается постоянно)

    // основной цикл обработки сообщений ОС
    glutMainLoop();
}
