#pragma once
#include <vector>
#include "Shader.h"
#include "Camera.h"
#include "GraphicObject.h"
#include "Mesh.h"
#include "ResourceManager.h"

// КЛАСС ДЛЯ ВЗАИМОДЕЙСТВИЯ С OPENGL
// ВЕСЬ ВЫВОД ОСУЩЕСТВЛЯЕТСЯ ЧЕРЕЗ ЕДИНСТВЕННЫЙ ЭКЗЕМПЛЯР ДАННОГО КЛАССА
class RenderManager
{
public:
	// Статик-метод для получения экземпляра менеджера ресурса.
	static RenderManager& instance()
	{
		static RenderManager renderManager;
		return renderManager;
	}
	void addShader(const Shader& shader);
	// инициализация объекта RenderManager, выполняется после инициализации OpenGL:
	// загрузка шейдеров, установка неизменных параметров и прочая инициализация
	void init();
	// Начало вывода очередного кадра (подготовка, очистка вектора графических объектов)
	void start();
	// установка используемой камеры
	void setCamera(Camera* camera);
	// добавление в очередь рендеринга очередного объекта для вывода
	void addToRenderQueue(GraphicObject& graphicObject);
	// завершение вывода кадра (основная работа)
	void finish();
private:
	// конструктор по умолчанию (приватный)
	RenderManager() {};
	// конструктора копирования нет
	RenderManager(const RenderManager& root) = delete;
	// оператора присваивания нет
	RenderManager& operator=(const RenderManager&) = delete;
private:
	// используемые шейдеры
	std::vector<Shader> shaders;
	// указатель на камеру
	Camera* camera;
	// список графических объектов, которые необходимо вывести в данном кадре
	std::vector<GraphicObject> graphicObjects;
};