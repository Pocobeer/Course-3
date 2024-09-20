#include <windows.h>

#include <iostream>
#include <vector>

#include <GL/gl.h>
#include <GL/glu.h>
#include "GL/freeglut.h"
#include <glm/glm.hpp>
#include <glm/gtc/matrix_transform.hpp>
#include <glm/gtc/type_ptr.hpp>
#include "GraphicObject.h"

// используем пространство имен стандартной библиотеки
using namespace std;
using namespace glm;


vector<GraphicObject> graphicObjects;

//вектор цветов
vector<vec3> colors{
	{1.0f, 1.0f, 1.0f},
	{0.0f, 0.0f, 1.0f},
	{1.0f, 0.0f, 0.0f}, 
	{1.0f, 1.0f, 0.0f}, 
	{0.5f, 0.0f, 0.5f}  
};

//переменные индекса, размера вектора цветов и счетчика времени
int index = 0;
int size = 5;
int timePassed = 0;

// функция, вызываемая при изменении размеров окна
void reshape(int w, int h)
{
	// установить новую область просмотра, равную всей области окна
	glViewport(0, 0, (GLsizei)w, (GLsizei)h);

	// установить матрицу проекции с правильным аспектом
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
	gluPerspective(25.0, (float)w / h, 0.2, 70.0);
};

// функция вызывается при перерисовке окна
// в том числе и принудительно, по командам glutPostRedisplay
void display(void)
{
	// отчищаем буфер цвета и буфер глубины
	glClearColor(0.0, 0.0, 0.0, 1.0);
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	// включаем тест глубины
	glEnable(GL_DEPTH_TEST);
	// устанавливаем камеру
	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();
	gluLookAt(10, 10, 17.5, 0, 0, 0, 0, 1, 0);
	
	for (auto& go : graphicObjects) {
		go.draw();
	}

	// смена переднего и заднего буферов
	glutSwapBuffers();
};

// функция вызывается каждые 20 мс
void simulation(int value)
{
	//при вызове функции увеличиваем счетчик
	timePassed += 20;
	//при достижении 1000 мс сбрасываем счетчик и изменяем цвет
	if (timePassed == 1000) {
		index += 1;
		//обнуляем счетчик
		timePassed = 0;
		//если дошди до конца вектора сбрасываем индекс
		if (index == 5) index = 0;
		cout << "Index of current color: " << index << endl;
	}

	// устанавливаем признак того, что окно нуждается в перерисовке
	glutPostRedisplay();
	// эта же функция будет вызвана еще раз через 20 мс
	glutTimerFunc(20, simulation, 0);
};

// Функция обработки нажатия клавиш
void keyboardFunc(unsigned char key, int x, int y)
{
	/*if (key == 32) {
		index += 1;
		if (index == 5) index = 0;
	}*/
	printf("Key code is %i\n", key);
};

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
	glutCreateWindow("Laba_03");

	// УСТАНОВКА ФУНКЦИЙ ОБРАТНОГО ВЫЗОВА
	// устанавливаем функцию, которая будет вызываться для перерисовки окна
	glutDisplayFunc(display);
	// устанавливаем функцию, которая будет вызываться при изменении размеров окна
	glutReshapeFunc(reshape);
	// устанавливаем функцию, которая будет вызвана через 20 мс
	glutTimerFunc(20, simulation, 0);
	// устанавливаем функцию, которая будет вызываться при нажатии на клавишу
	glutKeyboardFunc(keyboardFunc);

	GraphicObject tempGraphicObject;
	// 1 -----------------------------------------
	tempGraphicObject.setPosition(vec3(5, 0, 0));
	tempGraphicObject.setAngle(180);
	tempGraphicObject.setСolor(vec3(1.0f, 0.0f, 0.0f));
	graphicObjects.push_back(tempGraphicObject);

	GraphicObject tempGraphicObject2;
	//2-------------------------------------------
	tempGraphicObject2.setPosition(vec3(-5, 0, 0));
	tempGraphicObject2.setAngle(0);
	tempGraphicObject2.setСolor(vec3(0.0f, 0.0f, 1.0f));
	graphicObjects.push_back(tempGraphicObject2);

	GraphicObject tempGraphicObject3;
	//3-------------------------------------------
	tempGraphicObject3.setPosition(vec3(0, 0, -5));
	tempGraphicObject3.setAngle(270);
	tempGraphicObject3.setСolor(vec3(0.0f, 1.0f, 0.0f));
	graphicObjects.push_back(tempGraphicObject3);

	GraphicObject tempGraphicObject4;
	//4-------------------------------------------
	tempGraphicObject4.setPosition(vec3(0, 0, 5));
	tempGraphicObject4.setAngle(90);
	tempGraphicObject4.setСolor(vec3(1.0f, 1.0f, 1.0f));
	graphicObjects.push_back(tempGraphicObject4);
	
	
	// основной цикл обработки сообщений ОС
	glutMainLoop();
};