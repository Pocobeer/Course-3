#include <windows.h>

#include <iostream>

#include <GL/gl.h>
#include <GL/glu.h>
#include "GL/freeglut.h"
#include "Data.h"
#include "Simulation.h"
#include "Display.h"
// используем пространство имен стандартной библиотеки
using namespace std;

void main(int argc, char** argv)
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
	glutCreateWindow("Laba_06");

	initData();
	initSimulation();
	camera.setPosition(vec3(10.0f, 15.0f, 17.5f));

	// УСТАНОВКА ФУНКЦИЙ ОБРАТНОГО ВЫЗОВА
	glutDisplayFunc(display);  // Устанавливаем функцию для перерисовки окна
	glutReshapeFunc(reshape);  // Устанавливаем функцию для изменения размеров окна
	glutIdleFunc(simulation);  // Устанавливаем функцию симуляции (вызывается постоянно)
	// основной цикл обработки сообщений ОС
	glutMainLoop();
};