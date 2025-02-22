#pragma once
#include <string>
#include <GL/freeglut.h>
#include <glm/glm.hpp>
#include <map>

using namespace std;
using namespace glm;

class Shader
{
public:
	// загрузка шейдера из внешних файлов
	bool load(string vertexShaderFilename, string fragmentShaderFilename);
	// выбор шейдера в качестве текущего
	void activate();
	// отключение шейдера
	static void deactivate();
	// установка uniform-переменных
	void setUniform(std::string name, int value);
	void setUniform(std::string name, float value);
	void setUniform(std::string name, glm::vec2& value);
	void setUniform(std::string name, glm::vec4& value);
	void setUniform(std::string name, glm::mat4& value);
private:
	// создание шейдерного объекта указанного типа
	// и загрузка исходного текста шейдера из указанного файла
	GLuint createShaderObject(GLenum shaderType, string filename);

	// получение индекса (location) uniform-переменной
	GLuint getUniformLocation(std::string name);
private:
	// id "текущей" выбранной шейдерной программы
	// используется чтобы повторно не активировать шейдерную программу,
	// если она уже активирована
	static GLuint currentProgram;

	// шейдерная программа (шейдер)
	GLuint program;

	// "справочник" uniform-переменных,
	// который определяет ранее запомненное соответствие
	// между именем uniform-переменной и её индексом (location)
	map <string, GLuint> uniforms;
};