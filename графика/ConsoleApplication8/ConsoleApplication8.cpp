
#include <windows.h>

#include <iostream>

#include "Simulation.h"
#include "Display.h"

#include <GL/gl.h>
#include <GL/glu.h>
#include "GL/freeglut.h"// используем пространство имен стандартной библиотеки
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
	glutCreateWindow("Laba_08");
	GLenum err = glewInit();
	if (GLEW_OK != err)
	{
		printf("Error: %s\n", glewGetErrorString(err));
	}
	printf("Status: Using GLEW %s\n", glewGetString(GLEW_VERSION));
	if (GLEW_ARB_vertex_buffer_object) {
		printf("VBO is supported");
		cout << endl;
	};
	printf("GL_VENDOR = %s\n", glGetString(GL_VENDOR));
	printf("GL_RENDERER = %s\n", glGetString(GL_RENDERER));
	printf("GL_VERSION = %s\n\n", glGetString(GL_VERSION));
	initData();
	initSimulation();
	camera.setPosition(vec3(25.0f, 40.0f, 0.0f));
	//initializeMapObjects(passabilityMap);

	// УСТАНОВКА ФУНКЦИЙ ОБРАТНОГО ВЫЗОВА
	glutDisplayFunc(display);  // Устанавливаем функцию для перерисовки окна
	glutReshapeFunc(reshape);  // Устанавливаем функцию для изменения размеров окна
	glutIdleFunc(simulation);  // Устанавливаем функцию симуляции (вызывается постоянно)
	// основной цикл обработки сообщений ОС
	glutMainLoop();
};