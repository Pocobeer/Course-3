#include <windows.h>
#include "stdio.h"
#include "GL/glew.h"
#include <glm/gtc/matrix_transform.hpp>
#include <glm/gtc/type_ptr.hpp>
#include <vector>
#include <iostream>
#include "Shader.h"
#include "Camera.h"
#include "GraphicObject.h"

// используемые пространства имен (для удобства)
using namespace glm;
using namespace std;

bool rightMouseButtonPressed = false;
int lastX = 0, lastY = 0;

static float simulationTime = 0.0f;
static float deltaTime = 0.0f;

Camera camera;
Shader shader;
vector<GraphicObject> graphicObjects;

// функция вывода кубика с ребрами единичной длины
// каждая координата (x, y, z) меняется от -0.5 до +0.5
void drawBox()
{
	// переменные для вывода объекта (прямоугольника из двух треугольников)
	static GLuint VAO_Index = 0; // индекс VAO-буфера
	static GLuint VBO_Index = 0; // индекс VBO-буфера
	static int VertexCount = 0; // количество вершин
	static bool init = true;
	if (init) {
		// создание и заполнение VBO
		glGenBuffers(1, &VBO_Index);
		glBindBuffer(GL_ARRAY_BUFFER, VBO_Index);
		GLfloat Verteces[] = {
			// передняя грань (два треугольника)
			-0.5, +0.5, +0.5, -0.5, -0.5, +0.5, +0.5, +0.5, +0.5,
			+0.5, +0.5, +0.5, -0.5, -0.5, +0.5, +0.5, -0.5, +0.5,
			// задняя грань (два треугольника)
			+0.5, +0.5, -0.5, +0.5, -0.5, -0.5, -0.5, +0.5, -0.5,
			-0.5, +0.5, -0.5, +0.5, -0.5, -0.5, -0.5, -0.5, -0.5,
			// правая грань (два треугольника)
			+0.5, -0.5, +0.5, +0.5, -0.5, -0.5, +0.5, +0.5, +0.5,
			+0.5, +0.5, +0.5, +0.5, -0.5, -0.5, +0.5, +0.5, -0.5,
			// левая грань (два треугольника)
			-0.5, +0.5, +0.5, -0.5, +0.5, -0.5, -0.5, -0.5, +0.5,
			-0.5, -0.5, +0.5, -0.5, +0.5, -0.5, -0.5, -0.5, -0.5,
			// верхняя грань (два треугольника)
			-0.5, +0.5, -0.5, -0.5, +0.5, +0.5, +0.5, +0.5, -0.5,
			+0.5, +0.5, -0.5, -0.5, +0.5, +0.5, +0.5, +0.5, +0.5,
			// нижняя грань (два треугольника)
			-0.5, -0.5, +0.5, -0.5, -0.5, -0.5, +0.5, -0.5, +0.5,
			+0.5, -0.5, +0.5, -0.5, -0.5, -0.5, +0.5, -0.5, -0.5
		};
		glBufferData(GL_ARRAY_BUFFER, sizeof(Verteces), Verteces, GL_STATIC_DRAW);
		// создание VAO
		glGenVertexArrays(1, &VAO_Index);
		glBindVertexArray(VAO_Index);
		// инициализация VAO
		glBindBuffer(GL_ARRAY_BUFFER, VBO_Index);
		int location = 0;
		glVertexAttribPointer(location, 3, GL_FLOAT, GL_FALSE, 0, 0);
		glEnableVertexAttribArray(location);
		// "отвязка" буфера VAO на всякий случай, чтоб случайно не испортить
		glBindVertexArray(0);
		// указание количество вершин
		VertexCount = 6 * 6;
		init = false;
	}
	// вывод модели кубика на экран
	glBindVertexArray(VAO_Index);
	glDrawArrays(GL_TRIANGLES, 0, VertexCount);
	GLenum err = glGetError();
	if (err != GL_NO_ERROR) {
		cerr << "OpenGL error during drawBox(): " << err << endl;
	}
}

// Функция получения времени симуляции
float getSimulationTime() {
	static int startTime = glutGet(GLUT_ELAPSED_TIME); // В миллисекундах
	int currentTime = glutGet(GLUT_ELAPSED_TIME);
	return (currentTime - startTime) / 1000.0f; // Переводим в секунды
}

int getFps() {
	static int frameCount = 0;
	static float lastTime = 0.0f;
	static int fps = 0;

	float currentTime = getSimulationTime();
	frameCount++;

	if (currentTime - lastTime >= 1.0f) {
		fps = frameCount;
		frameCount = 0;
		lastTime = currentTime;
	}
	return fps;
}

// ДАННЫЕ ДЛЯ ВЫВОДА ПРЯМОУГОЛЬНИКА
vec4 color = vec4(1, 0, 0, 1);

void display()
{
	// очистка буфера кадра
	glClearColor(1.0, 1.0, 1.0, 1.0);
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	// включение теста глубины (на всякий случай)
	glEnable(GL_DEPTH_TEST);
	// вывод полигонов в виде линий с отсечением нелицевых граней
	glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);
	glEnable(GL_CULL_FACE);
	glCullFace(GL_BACK);
	// активируем шейдер, используемый для вывода объекта
	shader.activate();
	// устанавливаем матрицу проекции
	mat4& projectionMatrix = camera.getProjectionMatrix();
	shader.setUniform("projectionMatrix", projectionMatrix);
	shader.setUniform("color", color);
	// получаем матрицу камеры
	mat4& viewMatrix = camera.getViewMatrix();
	// выводим все объекты
	for (auto& grObj : graphicObjects) {
		// устанавливаем матрицу наблюдения модели
		mat4 modelViewMatrix = viewMatrix * grObj.getModelMatrix();
		shader.setUniform("modelViewMatrix", modelViewMatrix);
		// устанавливаем цвет
		shader.setUniform("color", grObj.getColor());
		// выводим модель кубика
		drawBox();
	}
	// меняем передний и задний буферы цвета
	glutSwapBuffers();
	// вычисление FPS и его вывод в заголовок окна
	char windowTitle[128];
	int FPS = getFps();
	sprintf_s(windowTitle, 128, "Laba_03 [%i FPS]", FPS);
	glutSetWindowTitle(windowTitle);
}

// функция, вызываемая при изменении размеров окна
void reshape(int w, int h)
{
	// установить новую область просмотра, равную всей области окна
	glViewport(0, 0, w, h);
	// устанавливаем матрицу проекции
	camera.setProjectionMatrix(35.0f, (float)w / h, 1.0f, 500.0f);
}
// функция вызывается, когда процессор простаивает, т.е. максимально часто
void simulation() {
	static float lastTime = 0.0f;
	float currentTime = getSimulationTime();

	// Вычисляем deltaTime
	deltaTime = currentTime - lastTime;
	lastTime = currentTime;

	float moveSpeed = 2.0f * deltaTime; // Скорость перемещения камеры

	// Обработка перемещения камеры с клавиатуры
	if (GetAsyncKeyState('W') & 0x8000) {
		camera.moveOXZ(0.0f, moveSpeed); // Движение вперед
	}
	if (GetAsyncKeyState('S') & 0x8000) {
		camera.moveOXZ(0.0f, -moveSpeed); // Движение назад
	}
	if (GetAsyncKeyState('A') & 0x8000) {
		camera.moveOXZ(-moveSpeed, 0.0f); // Движение влево
	}
	if (GetAsyncKeyState('D') & 0x8000) {
		camera.moveOXZ(moveSpeed, 0.0f); // Движение вправо
	}

	// Обработка вращения камеры при зажатой правой кнопке мыши
	static POINT lastCursorPos = { 0, 0 }; // Объявляем lastCursorPos здесь
	static bool isFirstPress = true;     // Флаг для отслеживания первого нажатия

	if (GetAsyncKeyState(VK_RBUTTON) & 0x8000) {
		// Получаем текущее положение курсора
		POINT cursorPos;
		GetCursorPos(&cursorPos);

		// Если это первое нажатие, обновляем lastCursorPos
		if (isFirstPress) {
			lastCursorPos = cursorPos;
			isFirstPress = false;
		}

		// Вычисляем смещение курсора
		float dx = cursorPos.x - lastCursorPos.x;
		float dy = cursorPos.y - lastCursorPos.y;

		// Вращение камеры
		float rotateSpeed = 0.1f; // Чувствительность вращения
		camera.rotate(dx * rotateSpeed, dy * rotateSpeed);

		// Обновляем предыдущее положение курсора
		lastCursorPos = cursorPos;
	}
	else {
		// Если правая кнопка мыши отпущена, сбрасываем флаг isFirstPress
		isFirstPress = true;
	}

	// Установка признака необходимости перерисовать окно
	glutPostRedisplay();
}


void mouseWheel(int wheel, int direction, int x, int y)
{
	// Определяем, на сколько необходимо приблизить/удалить камеру
	float delta = 0.1f; // Шаг изменения расстояния
	if (direction > 0)
	{
		// Вращение колесика вверх (приближение)
		camera.zoom(+delta); // Уменьшаем расстояние до цели
	}
	else
	{
		// Вращение колесика вниз (удаление)
		camera.zoom(-delta); // Увеличиваем расстояние до цели
	}
}

// основная функция
void main(int argc, char** argv)
{
	GraphicObject obj1 = GraphicObject();
	vec3 pos1 = vec3{ 0.0f, 0.0f, 0.0f };
	obj1.setColor(color);
	obj1.setPosition(pos1);
	graphicObjects.emplace_back(obj1);
	GraphicObject obj2 = GraphicObject();
	vec3 pos2 = vec3{ 0.0f, 0.0f, 1.0f };
	obj2.setColor(color);
	obj2.setPosition(pos2);
	graphicObjects.emplace_back(obj2);
	GraphicObject obj3 = GraphicObject();
	vec3 pos3 = vec3{ 0.0f, 1.0f, 0.5f };
	obj3.setColor(color);
	obj3.setPosition(pos3);
	graphicObjects.emplace_back(obj3);
	// инициализация библиотеки GLUT
	glutInit(&argc, argv);
	// инициализация дисплея (формат вывода)
	glutInitDisplayMode(GLUT_RGBA | GLUT_DOUBLE | GLUT_DEPTH
		| GLUT_STENCIL | GLUT_MULTISAMPLE);
	// требования к версии OpenGL (версия 3.3 без поддержки обратной совместимости)
	glutInitContextVersion(3, 3);
	glutInitContextProfile(GLUT_CORE_PROFILE);

	// устанавливаем верхний левый угол окна
	glutInitWindowPosition(300, 100);
	// устанавливаем размер окна
	glutInitWindowSize(800, 600);
	// создание окна
	glutCreateWindow("laba_03");
	// инициализация GLEW
	GLenum err = glewInit();
	if (GLEW_OK != err)
	{
		fprintf(stderr, "Glew error: %s\n", glewGetErrorString(err));
		return;
	}
	// определение текущей версии OpenGL
	printf("OpenGL Version = %s\n\n", glGetString(GL_VERSION));
	// загрузка шейдера
	shader.load("SHADER\\Example.vsh", "SHADER\\Example.fsh");
	if (!shader.load("SHADER\\Example.vsh", "SHADER\\Example.fsh")) {
		fprintf(stderr, "Failed to load shaders\n");
		return;
	}
	// устанавливаем функцию, которая будет вызываться для перерисовки окна
	glutDisplayFunc(display);
	// устанавливаем функцию, которая будет вызываться при изменении размеров окна
	glutReshapeFunc(reshape);
	// устанавливаем функцию, которая вызывается всякий раз, когда процессор простаивает
	glutIdleFunc(simulation);
	glutMouseWheelFunc(mouseWheel);
	// основной цикл обработки сообщений ОС
	glutMainLoop();
}