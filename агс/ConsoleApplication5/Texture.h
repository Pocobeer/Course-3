#pragma once
#include <GL/glew.h>
#include <string>
#include <IL/il.h>
//#include <IL/ilu.h>
//#include <IL/ilut.h>

using namespace std;

// КЛАСС ДЛЯ РАБОТЫ С ТЕКСТУРОЙ
class Texture
{
public:
	// загрузка текстуры из внешнего файла
	bool load(string filename);
	// применение текстуры (привязка к текстурному блоку)
	void bind(GLenum texUnit = GL_TEXTURE0);
private:
	// индекс текстурного объекта
	GLuint texIndex;
};