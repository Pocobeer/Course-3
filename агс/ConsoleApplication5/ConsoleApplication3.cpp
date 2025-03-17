#include <windows.h>
#include "stdio.h"
#include "GL/glew.h"
#include <glm/gtc/matrix_transform.hpp>
#include <glm/gtc/type_ptr.hpp>
#include <vector>
#include <iostream>
#include "RenderManager.h"

#include "IL/il.h"
#include "IL/ilu.h"
#include "IL/ilut.h"


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

// вспомогательная функция для инициализации графических объектов
void initGraphicObjects()
{
	// ссылка на менеджер ресурсов (для удобства)
	ResourceManager& rm = ResourceManager::instance();
	// временная переменная для хранения идентификаторов меша
	int meshId = -1;
	int textureId = -1;
	// временная переменная для представления графического объекта
	GraphicObject graphicObject;
	// добавление графического объекта
	meshId = rm.loadMesh("MESHES\\buildings\\house_2.obj");
	graphicObject.setMeshId(meshId);
	textureId = rm.loadTexture("TEXTURES\\buildings\\house_2_orange.png");
	graphicObject.setTextureId(textureId);
	graphicObject.setColor(vec4(0.2, 0.2, 0.2, 1));
	graphicObject.setPosition(vec3(0, 0, 0));
	graphicObject.setAngle(0.0);
	graphicObjects.push_back(graphicObject);
	// добавление графического объекта
	meshId = rm.loadMesh("MESHES\\natures\\big_tree.obj");
	graphicObject.setMeshId(meshId);
	textureId = rm.loadTexture("TEXTURES\\natures\\nature.png");
	graphicObject.setTextureId(textureId);
	graphicObject.setColor(vec4(0.2, 0.8, 0.2, 1));
	graphicObject.setPosition(vec3(7.5, -0.75, 2.5));
	graphicObject.setAngle(0.0);
	graphicObjects.push_back(graphicObject);
	// добавление графического объекта
	meshId = rm.loadMesh("MESHES\\natures\\big_tree.obj");
	graphicObject.setMeshId(meshId);
	textureId = rm.loadTexture("TEXTURES\\natures\\nature.png");
	graphicObject.setTextureId(textureId);
	graphicObject.setColor(vec4(0.2, 0.8, 0.2, 1));
	graphicObject.setPosition(vec3(-7.5, -0.75, 2.5));
	graphicObject.setAngle(0.0);
	graphicObjects.push_back(graphicObject);
	// добавление графического объекта
	meshId = rm.loadMesh("MESHES\\vehicles\\police_car.obj");
	graphicObject.setMeshId(meshId);
	textureId = rm.loadTexture("TEXTURES\\vehicles\\police_car.png");
	graphicObject.setTextureId(textureId);
	graphicObject.setColor(vec4(0.2, 0.2, 1.0, 1));
	graphicObject.setPosition(vec3(+4.5, -2.15, +6.5));
	graphicObject.setAngle(-115.0);
	graphicObjects.push_back(graphicObject);
	// добавление графического объекта
	meshId = rm.loadMesh("MESHES\\vehicles\\police_car.obj");
	graphicObject.setMeshId(meshId);
	textureId = rm.loadTexture("TEXTURES\\vehicles\\police_car.png");
	graphicObject.setTextureId(textureId);
	graphicObject.setColor(vec4(0.23, 0.23, 1.0, 1));
	graphicObject.setPosition(vec3(+4.25, -2.15, +10.5));
	graphicObject.setAngle(+105.0);
	graphicObjects.push_back(graphicObject);
	// добавление графического объекта
	meshId = rm.loadMesh("MESHES\\vehicles\\jeep.obj");
	graphicObject.setMeshId(meshId);
	textureId = rm.loadTexture("TEXTURES\\vehicles\\jeep_green.png");
	graphicObject.setTextureId(textureId);
	graphicObject.setColor(vec4(0.95, 0.13, 0.13, 1));
	graphicObject.setPosition(vec3(-1.25, -2.15, +9.0));
	graphicObject.setAngle(+170.0);
	graphicObjects.push_back(graphicObject);
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
	// для удобства определяем ссылку на RenderManager
	RenderManager& renderManager = RenderManager::instance();
	// начинаем вывод нового кадра
	renderManager.start();
	// добавляем в очередь все объекты, которые необходимо вывести
	for (auto& graphicObject : graphicObjects) {
		renderManager.addToRenderQueue(graphicObject);
	}
	// завершаем построение кадра
	renderManager.finish();
	// меняем передний и задний буферы цвета
	glutSwapBuffers();
	// вычисление FPS и его вывод в заголовок окна
	char windowTitle[128];
	int FPS = getFps();
	sprintf_s(windowTitle, 128, "Laba_05 [%i FPS]", FPS);
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
	float delta = 0.8f; // Шаг изменения расстояния
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
	
	// инициализация библиотеки GLUT
	glutInit(&argc, argv);
	// инициализация дисплея (формат вывода)
	glutInitDisplayMode(GLUT_RGBA | GLUT_DOUBLE | GLUT_DEPTH
		| GLUT_STENCIL | GLUT_MULTISAMPLE);
	// требования к версии OpenGL (версия 3.3 без поддержки обратной совместимости)
	//glutInitContextVersion(3, 3);
	glutInitContextProfile(GLUT_COMPATIBILITY_PROFILE);

	// устанавливаем верхний левый угол окна
	glutInitWindowPosition(300, 100);
	// устанавливаем размер окна
	glutInitWindowSize(800, 600);
	// создание окна
	glutCreateWindow("laba_04");
	// инициализация GLEW
	glewExperimental = GL_TRUE;
	GLenum err = glewInit();
	if (err != GL_NO_ERROR) {
		cerr << "ul init error!\n"; return;
	}

	// DevIl init
	ilInit();
	err = glGetError();
	if (err != GL_NO_ERROR) {
		cerr << "ul init error!\n"; return;
	}

	iluInit();
	err = glGetError();
	if (err != GL_NO_ERROR) {
		cerr << "ulu init error!\n"; return;
	}

	ilutInit();
	err = glGetError();
	if (err != GL_NO_ERROR) {
		cerr << "ulut init error!\n"; return;
	}

	ilutRenderer(ILUT_OPENGL);
	ilSetInteger(IL_KEEP_DXTC_DATA, IL_TRUE);
	ilutEnable(ILUT_GL_AUTODETECT_TEXTURE_TARGET);
	ilutEnable(ILUT_OPENGL_CONV);
	ilutEnable(ILUT_GL_USE_S3TC);

	// определение текущей версии OpenGL
	printf("OpenGL Version = %s\n\n", glGetString(GL_VERSION));
	// загрузка шейдера
	shader.load("SHADER\\Example.vsh", "SHADER\\Example.fsh");
	if (!shader.load("SHADER\\Example.vsh", "SHADER\\Example.fsh")) {
		fprintf(stderr, "Failed to load shaders\n");
		return;
	}
	// Добавление шейдера в RenderManager
	RenderManager& renderManager = RenderManager::instance();
	renderManager.addShader(shader);
	// Установка камеры в RenderManager
	renderManager.setCamera(&camera);
	initGraphicObjects();
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