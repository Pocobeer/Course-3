#include <windows.h>
#include "PhongMaterial.h"
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
#include "GraphicObject.h"


Camera camera;  // Объявляем камеру как глобальную переменную

using namespace std;
using namespace glm;

int main(int argc, char** argv)
{
    setlocale(LC_ALL, "ru");
    auto material = make_shared<PhongMaterial>();
    try {
        material->load("materials/material_1.txt");
    }
    catch (const exception& e) {
        cerr << e.what() << endl;
        return -1;
    }

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
