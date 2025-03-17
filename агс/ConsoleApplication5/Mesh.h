#pragma once
#include <GL/glew.h>
#include <iostream>
#include "Vertex.h"
#include <vector>

using namespace std;
// КЛАСС ДЛЯ РАБОТЫ С МЕШЕМ
class Mesh
{
public:
	// конструктор
	Mesh();
	// загрузка меша из внешнего obj-файла
	bool load(const string& filename);
	// вывод меша
	void drawOne();
private:
	// индекс VAO-объекта
	GLuint vao;
	// индекс VBO-буфера вершин
	GLuint vertexBuffer;
	// индекс VBO-буфера индексов
	GLuint indexBuffer;
	// количество вершин в меше
	int vertexCount;

	// Загрузка данных из obj-файла
	bool loadObjFile(const std::string& filename, std::vector<Vertex>& vertices, std::vector<GLuint>& indices);

	// Создание буферов OpenGL
	void createBuffers(const std::vector<Vertex>& vertices, const std::vector<GLuint>& indices);
};