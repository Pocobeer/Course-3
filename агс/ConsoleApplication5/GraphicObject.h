#pragma once
#include <glm/gtc/type_ptr.hpp>

using namespace glm;
using namespace std;

// КЛАСС ДЛЯ РАБОТЫ С ГРАФИЧЕСКИМ ОБЪЕКТОМ
class GraphicObject
{
public:
	// конструктор по умолчанию
	GraphicObject();
	// установить цвет объекта
	void setColor(const vec4& color);
	// установить позицию объекта
	void setPosition(const vec3& position);
	// установить угол поворота в градусах относительно оси OY по часовой стрелке
	void setAngle(float degree);
	// установить идентификатор используемого меша
	void setMeshId(int id);
	void setTextureId(int id);
	// получить различные параметры
	vec4& getColor();
	mat4& getModelMatrix();
	int getMeshId();
	int getTextureId();
private:
	// идентификатор используемого меша
	int meshId;
	int textureId;
	// цвет объекта
	vec4 color;
	// матрица модели (задает позицию и ориентацию)
	mat4 modelMatrix;
};