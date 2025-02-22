#include <windows.h>
#include "stdio.h"
#include "GL/glew.h"
#include <glm/gtc/matrix_transform.hpp>
#include <glm/gtc/type_ptr.hpp>
#include "Shader.h"
// используемые пространства имен (для удобства)
using namespace glm;
using namespace std;

static float simulationTime = 0.0f;
static float deltaTime = 0.0f;

// функция для вывода квадрата с ребрами равными единице (от -0.5 до +0.5)
void drawObject()
{
	// переменные для вывода объекта (прямоугольника из двух треугольников)
	static bool init = true;
	static GLuint VAO_Index = 0; // индекс VAO-буфера
	static GLuint VBO_Index = 0; // индекс VBO-буфера
	static int VertexCount = 0; // количество вершин
	// при первом вызове инициализируем VBO и VAO
	if (init) {
		init = false;
		// создание и заполнение VBO
		glGenBuffers(1, &VBO_Index);
		glBindBuffer(GL_ARRAY_BUFFER, VBO_Index);
		GLfloat Verteces[] = {
		-0.5, +0.5,
		-0.5, -0.5,
		+0.5, +0.5,
		+0.5, +0.5,
		-0.5, -0.5,
		+0.5, -0.5
		};
		glBufferData(GL_ARRAY_BUFFER, sizeof(Verteces), Verteces, GL_STATIC_DRAW);
		// создание VAO
		glGenVertexArrays(1, &VAO_Index);
		glBindVertexArray(VAO_Index);
		// заполнение VAO
		glBindBuffer(GL_ARRAY_BUFFER, VBO_Index);
		glVertexAttribPointer(0, 2, GL_FLOAT, GL_FALSE, 0, 0);
		glEnableVertexAttribArray(0);
		// "отвязка" буфера VAO, чтоб случайно не испортить
		glBindVertexArray(0);
		// указание количество вершин
		VertexCount = 6;
	}
	// выводим прямоугольник
	glBindVertexArray(VAO_Index);
	glDrawArrays(GL_TRIANGLES, 0, 6);
}

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

// используемый шейдер (пока только один)
Shader shader;

// ДАННЫЕ ДЛЯ ВЫВОДА ПРЯМОУГОЛЬНИКА
// текущее смещение прямоугольника
vec2 offset = vec2(0, 0);
// скорость (направление) перемещения прямоугольника
vec2 speed = vec2(+0.30, -0.25);
// первый цвет (для градиентной заливки)
vec4 color1 = vec4(1, 0, 0, 1);
// второй цвет (для градиентной заливки)
vec4 color2 = vec4(0, 1, 0, 1);
// третий цвет (для градиентной заливки)
vec4 color3 = vec4(0, 0, 1, 1);

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

	// формируем матрицу проекции
	mat4 projectionMatrix;
	projectionMatrix = perspective(radians(35.0), 800.0 / 600.0, 1.0, 100.0);
	// генерирование матрицы камеры
	mat4 viewMatrix;
	// позиция камеры - (0, 3, 5)
	vec3 eye = vec3(0.0, 3.0, 5.0);
	// точка, в которую направлена камера - (0, 0, 0);
	vec3 center = vec3(0, 0, 0);
	// примерный вектор "вверх" (0, 1, 0)
	vec3 up = vec3(0, 1, 0);
	// матрица камеры
	viewMatrix = lookAt(eye, center, up);
	// матрица модели
	mat4 modelMatrix;
	// модель располагается в точке (1,0,0) без поворота
	modelMatrix = mat4(
		vec4(1, 0, 0, 0), // 1-ый столбец: направление оси X
		vec4(0, 1, 0, 0), // 2-ой столбец: направление оси Y
		vec4(0, 0, 1, 0), // 3-ий столбец: направление оси Z
		vec4(1, 0, 0, 1)); // 4-ый столбец: позиция объекта (начала координат)
	// вычисляем матрицу наблюдения модели
	mat4 modelViewMatrix = viewMatrix * modelMatrix;
	// активация шейдера
	shader.activate();
	// устанавливаем uniform-переменные для матриц проекции и наблюдения модели
	shader.setUniform("projectionMatrix", projectionMatrix);
	shader.setUniform("modelViewMatrix", modelViewMatrix);
	// устанавливаем значение uniform-переменной для цвета каждого фрагмента
	vec4 color = vec4(0, 0, 1, 1);
	shader.setUniform("color", color);
	// выводим кубик
	drawBox();
	// смена переднего и заднего буферов
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
}
// функция вызывается, когда процессор простаивает, т.е. максимально часто
void simulation()
{
	static float lastTime = 0.0f;
	float currentTime = getSimulationTime();

	// Вычисляем deltaTime
	deltaTime = currentTime - lastTime;
	lastTime = currentTime;

	// Обновляем позицию с учетом времени
	offset += speed * deltaTime;

	// Отскок от границ экрана [-0.5, 0.5]
	if (offset.x > 0.5f || offset.x < -0.5f) {
		speed.x *= -1;
		offset.x = clamp(offset.x, -0.5f, 0.5f);
	}
	if (offset.y > 0.5f || offset.y < -0.5f) {
		speed.y *= -1;
		offset.y = clamp(offset.y, -0.5f, 0.5f);
	}

	// установка признака необходимости перерисовать окно
	glutPostRedisplay();
};

// основная функция
void main(int argc, char** argv)
{
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
	glutCreateWindow("laba_02");
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
	// устанавливаем функцию, которая будет вызываться для перерисовки окна
	glutDisplayFunc(display);
	// устанавливаем функцию, которая будет вызываться при изменении размеров окна
	glutReshapeFunc(reshape);
	// устанавливаем функцию, которая вызывается всякий раз, когда процессор простаивает
	glutIdleFunc(simulation);
	// основной цикл обработки сообщений ОС
	glutMainLoop();
}