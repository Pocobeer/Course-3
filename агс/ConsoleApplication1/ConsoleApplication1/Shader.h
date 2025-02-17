#pragma once
#include <string>
#include <GL/freeglut.h>


using namespace std;

class Shader
{
public:
	// загрузка шейдера из внешних файлов
	bool load(string vertexShaderFilename, string fragmentShaderFilename);
	// выбор шейдера в качестве текущего
	void activate();
	// отключение шейдера
	static void deactivate();
private:
	// создание шейдерного объекта указанного типа
	// и загрузка исходного текста шейдера из указанного файла
	GLuint createShaderObject(GLenum shaderType, string filename);
private:
	// шейдерная программа (шейдер)
	GLuint program;
};